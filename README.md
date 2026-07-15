# About
Repozytorium zawiera skrypty w bashu automatyzujące weryfikację środowiska oraz ułatwiające zarządzanie kontenerami Docker. Wspomagają poprawne uruchomienie skonteneryzownej aplikacji oraz poprawiają Developer Experience.

# Kontekst projektu
Prosty serwer Express.js połączony z bazą danych PostgreSQL. Całe środowisko jest w pełni skonteneryzowane za pomocą Docker Compose. Baza danych jest automatycznie inicjalizowana przy pierwszym uruchomieniu przy użyciu pliku init.sql montowanego w folderze /docker-entrypoint-initdb.d/.

# Projekt 1: Skrypt walidacyjny
Skrypt sprawdza, czy projekt zawiera wszystkie wymagane zmienne środowiskowe przed startem serwera. Przyspiesza to debugowanie błędów i pozwala natychmiast wykryć braki w konfiguracji.

Dodatkowo skrypt sprawdza czy baza danych jest już gotowa na nawiązanie połączenia i dopiero wtedy uruchamia aplikację. Dzięki temu zachowujemy poprawną kolejność tworzenia zasobów.

```sh
docker compose up --build -d
```

Skrypt nazywa się `entrypoint.sh` i jest przekazywany przez parametr `ENTRYPOINT` w `Dockerfile`.

# Projekt 2: Interaktywne zarządzanie kontenerami

Lekkie, interaktywne narzędzie w Bashu do prostego i błyskawicznego zarządzania kontenerami Docker bez konieczności ręcznego wpisywania poleceń i przekopiowywania ID kontenerów. Ma ono na celu poprawic komfort pracy dewelopera

Wykorzystałem `fzf`, który w jednej linijce realizuje obsługę inputu usera, wyszukiwanie i walidacje. Przekazuje fzf liste kontenerow, a on zwraca jedną linie wybraną przez usera.

**Możliwe akcje:** Zatrzymanie kontenera, restart kontenera, podgląd logów w czasie rzeczywistym oraz wejście do terminala wewnątrz kontenera.

```sh
./scripts/docker-helper.sh
```