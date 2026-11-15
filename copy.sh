# Run this to build and copy the website to a server.

host=$1
version=$2
result=`nix-build`
nix-copy-closure $host $result || nix-copy-closure root@$host $result
ssh $host nix-store --add-root ~/webapp-v$version -r $result
ssh $host ln -snf ~/webapp-v$version ~/webapp
