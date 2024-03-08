#!/bin/bash

node_version="14"
container_name="node_http_server"

if ! command -v docker &> /dev/null; then
    echo "Docker nie jest zainstalowany."
    exit 1
fi

echo "FROM node:$node_version" > Dockerfile
echo "WORKDIR /app" >> Dockerfile
echo "COPY . /app" >> Dockerfile
echo "EXPOSE 8080" >> Dockerfile
echo "CMD [\"node\", \"server.js\"]" >> Dockerfile

echo "const http = require('http');" > server.js
echo "const server = http.createServer((req, res) => {" >> server.js
echo "  res.writeHead(200, {'Content-Type': 'text/plain'});" >> server.js
echo "  res.end('Hello World\\n');" >> server.js
echo "});" >> server.js
echo "server.listen(8080, '0.0.0.0', () => {" >> server.js
echo "  console.log('Serwer nasłuchuje na porcie 8080');" >> server.js
echo "});" >> server.js

docker build -t $container_name .
docker run -p 8080:8080 --name $container_name $container_name

rm Dockerfile server.js
