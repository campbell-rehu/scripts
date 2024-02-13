if [[ -z "$1" ]]; then
    echo "usage: ./scp-to-server.sh [source_dir|file_path] [target_username] [target_ip_address] [target_dir]"
    echo "please enter a source directory or file path"
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "usage: ./scp-to-server.sh [source_dir|file_path] [target_username] [target_ip_address] [target_dir]"
    echo "please enter a target username"
    exit 1
fi

if [[ -z "$3" ]]; then
    echo "usage: ./scp-to-server.sh [source_dir|file_path] [target_username] [target_ip_address] [target_dir]"
    echo "please enter a target ip address"
    exit 1
fi

if [[ -z "$4" ]]; then
    echo "usage: ./scp-to-server.sh [source_dir|file_path] [target_username] [target_ip_address] [target_dir]"
    echo "please enter a target directory"
    exit 1
fi

echo "running command: scp -r $1 $2@$3:$4"
scp -r "$1" "$2"@"$3":"$4"
