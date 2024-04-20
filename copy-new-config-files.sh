#!/bin/bash

function errorMessage () {
  echo "$1"
  echo "Usage: ./copy-new-config.files.sh [--dry-run] SOURCE_DIR TARGET_DIR [...SKIP_FILES]"
}

if [[ $1 == "--help" ]]; then
  echo "Usage: ./copy-new-config.files.sh [--dry-run] SOURCE_DIR TARGET_DIR [...SKIP_FILES]"
  exit 0
fi

# Get file name
dry_run=false
if [[ $1 == "--dry-run" ]]; then
    dry_run=true
    shift 
fi

SOURCE_DIR=$1
shift
if [[ -z "$SOURCE_DIR" ]]; then
  errorMessage "Please provide a SOURCE_DIR" 
  exit 1
fi

TARGET_DIR=$1
shift
if [[ -z "$TARGET_DIR" ]]; then
  errorMessage "Please provide a TARGET_DIR" 
  exit 1
fi

SKIPS=("$@")
SKIP_FILES=()

for SKIP in "${SKIPS[@]}"; do
  FILE=$(echo "$SKIP" | rev | cut -f1 -d'/' - | rev)
  SKIP_FILES+=("$FILE")
done

if $dry_run; then
  printf "==== running in dry-run mode ====\n\n"
else
  printf "==== running in normal mode ====\n\n"
fi

# Get list of files from SOURCE_DIR
SOURCE_FILES=($(ls "$SOURCE_DIR"))

FILES_TO_COPY_AND_SYMLINK=()

# Loop through SOURCE_FILES and add any files that are not symbolic links to the FILES_TO_COPY_AND_SYMLINK list
for file in "${SOURCE_FILES[@]}"; do
  if echo "$SKIP_FILES" | grep -F -q -x "$file" ; then
    echo "skipping $file..."
    continue
  fi
  if [[ ! -L "$SOURCE_DIR/$file" ]]; then
    echo "no symlink found for $file"
    FILES_TO_COPY_AND_SYMLINK+=("$file")
  fi
done

PATH_ROOT=${TARGET_DIR%/}

# Build the path where the file should go in the TARGET_DIR
# TODO: this only supports files that are 4 sub-directories deep. Find a way to improve this. Maybe compare the TARGET_DIR path and match it against the SOURCE_DIR path?
FILE_PATH=$(echo "$SOURCE_DIR" | rev | cut -f1 -f2 -f3 -f4 -d'/' - | rev)

for FILE in "${FILES_TO_COPY_AND_SYMLINK[@]}"; do
  DEST_PATH="$PATH_ROOT/$FILE_PATH/$FILE"
  printf "processing file: %s\n" "$FILE"
  if [[ ! -d "$PATH_ROOT/$FILE_PATH" ]]; then
    echo "$PATH_ROOT/$FILE_PATH is invalid. Exiting early..."
    exit 1
  fi

  if $dry_run; then
    printf "would run:\n\n cp -R %s %s\n ln -sf %s %s\n\n" "$FILE" "$DEST_PATH" "$DEST_PATH" "$FILE"
  else
    # Copy the file
    cp -r "$FILE" "$DEST_PATH"
    # Create a symbolic link from the copied file at $DEST_PATH back to the file in the original directory
    ln -sf "$DEST_PATH" "$FILE"
  fi
done

if ! $dry_run; then
    echo "dotfiles and config directories are in-sync."
fi

