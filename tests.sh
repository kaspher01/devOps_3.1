#!/bin/bash

if ! command -v docker &> /dev/null; then
    echo "Test nieudany: Docker nie jest zainstalowany."
    exit 1
fi

if [ ! -x "./script.sh" ]; then
    echo "Test nieudany: Brak uprawnień do wykonania skryptu."
    exit 1
fi

./script.sh

if [ "$(docker ps -q -f name=node_http_server)" ]; then
    echo "Test udany: Kontener został uruchomiony poprawnie."
else
    echo "Test nieudany: Kontener nie został uruchomiony."
    exit 1
fi

response=$(curl -s http://localhost:8080)
expected_response="Hello World"
if [ "$response" = "$expected_response" ]; then
    echo "Test udany: Serwer zwraca oczekiwany tekst."
else
    echo "Test nieudany: Serwer zwraca nieoczekiwany tekst."
    exit 1
fi

docker stop node_http_server
docker rm node_http_server

echo "Wszystkie testy zakończone pomyślnie."
