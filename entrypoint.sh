#!/bin/bash
set -e  

echo "--- [1/2] Sprawdzam obecność wymaganych zmiennych środowiskowych ---"
REQUIRED_VARS=("DB_HOST" "DB_PORT" "DB_USER" "DB_PASSWORD" "DB_NAME")

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Błąd: Brak wymaganej zmiennej środowiskowej: $var" >&2
        exit 1
    fi
done

echo "Wszystkie wymagane zmienne środowiskowe są obecne."

echo "--- [2/2] Oczekiwanie na bazę danych ($DB_HOST:$DB_PORT) ---"
MAX_RETRIES=30
RETRY_COUNT=0

while ! nc -z -w 2 "$DB_HOST" "$DB_PORT"; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ "$RETRY_COUNT" -gt "$MAX_RETRIES" ]; then
        echo "Błąd: Przekroczono limit czasu oczekiwania na bazę danych." >&2
        exit 1
    fi
    echo "Baza danych nie odpowiada. Próba $RETRY_COUNT/$MAX_RETRIES... (czekam 1s)"
    sleep 1
done
echo "Połączenie TCP z bazą danych nawiązane pomyślnie."

echo "=== Wszystko OK. Uruchamiam serwer aplikacji ==="

# proces bash jest ZASTĘPOWANY (przejmuje PID 1) przez node
exec "$@"