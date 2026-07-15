#!/bin/bash

if ! command -v docker &> /dev/null; then
    echo "Błąd: Docker nie jest zainstalowany lub nie jest dostępny w PATH." >&2
    exit 1
fi

if ! command -v fzf &> /dev/null; then
    echo "Błąd: Narzędzie 'fzf' nie jest zainstalowane." >&2
    exit 1
fi

# Pobranie listy uruchomionych kontenerów i przekazanie jej do fzf, który zwróci pojedynczą linię wybraną przez usera
echo "Pobieranie listy kontenerów..."
selected_container=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}" | fzf --header-lines=1 --prompt="Wybierz kontener: " --height=40% --border)

if [ -z "$selected_container" ]; then
    echo "Anulowano. Nie wybrano żadnego kontenera."
    exit 0
fi

# Wyciągnięcie ID kontenera i jego nazwy
CONTAINER_ID=$(echo "$selected_container" | awk '{print $1}')
CONTAINER_NAME=$(echo "$selected_container" | awk '{print $2}')

echo "Wybrany kontener: $CONTAINER_NAME ($CONTAINER_ID)"
echo "--------------------------------------------------"

actions="1. Terminal wewnątrz kontenera\n2. Podgląd logów\n3. Zrestartuj kontener\n4. Zatrzymaj kontener\n5. Wyjdź"
selected_action=$(echo -e "$actions" | fzf --prompt="Wybierz akcję dla $CONTAINER_NAME: " --height=15% --border)

case "$selected_action" in
    *Shell*)
        echo "Uruchamianie terminala w kontenerze $CONTAINER_NAME..."
        docker exec -it "$CONTAINER_ID" /bin/bash 2>/dev/null || docker exec -it "$CONTAINER_ID" /bin/sh
        ;;
    *logów*)
        echo "Wyświetlanie logów dla $CONTAINER_NAME"
        docker logs -f "$CONTAINER_ID"
        ;;
    *Zrestartuj*)
        echo "Restartowanie kontenera $CONTAINER_NAME..."
        if docker restart "$CONTAINER_ID" >/dev/null; then
            echo "Kontener został pomyślnie zrestartowany."
        else
            echo "Błąd podczas restartowania kontenera." >&2
        fi
        ;;
    *Zatrzymaj*)
        echo "Zatrzymywanie kontenera $CONTAINER_NAME..."
        if docker stop "$CONTAINER_ID" >/dev/null; then
            echo "Kontener został pomyślnie zatrzymany."
        else
            echo "Błąd podczas zatrzymywania kontenera." >&2
        fi
        ;;
    *)
        echo "Anulowano."
        exit 0
        ;;
esac