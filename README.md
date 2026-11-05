# Find Duplicates for Piwigo

Find Duplicates is a plugin for [Piwigo](https://piwigo.org/) that helps you find duplicate and similar images in your gallery using pHash/dHash and time-based comparisons.

## Features
- **Visual Similarity:** Uses dHash algorithm to find images that are visually similar, even if they have different resolutions or formats.
- **Time Similarity:** Can group photos taken around the same time.
- **Easy Review:** Intuitive admin interface to review and manage duplicates.

## Requirements
- **PHP:** 7.4 or newer (fully compatible with PHP 8.x) with the **GD** extension (`ext-gd`) enabled for visual hash generation.
- **Database:** MySQL 5.7+ / 8.x or MariaDB 10.x+.

## Installation

1. Download the latest release from the [Piwigo Extension directory](https://piwigo.org/ext/index.php?eid=1123)
2. Extract the downloaded archive into the `plugins/` directory of your Piwigo installation. The folder should be named `find_duplicates` (or similar depending on extraction, but must match the plugin ID).
3. Log in to your Piwigo administration panel.
4. Go to **Plugins > Manage**.
5. Find "Find Duplicates" in the list and click **Install**, then **Activate**.

## Usage
Once activated, you can access the tool via the left sidebar in the admin panel under **Photos > Find Duplicates**.

## License
This project is licensed under the GNU General Public License v2.0 or later. See the `LICENSE` file for details.

---

# Find Duplicates dla Piwigo

Find Duplicates to wtyczka dla galerii [Piwigo](https://piwigo.org/), która pomaga znaleźć duplikaty i podobne zdjęcia w Twojej galerii za pomocą porównywania hashów obrazu (pHash/dHash) oraz czasu.

## Funkcje
- **Podobieństwo wizualne:** Wykorzystuje algorytm dHash do wyszukiwania zdjęć, które wyglądają podobnie, nawet jeśli różnią się rozdzielczością lub formatem.
- **Podobieństwo czasowe:** Grupuje zdjęcia wykonane w podobnym czasie.
- **Łatwy przegląd:** Intuicyjny interfejs w panelu administratora do przeglądania i zarządzania duplikatami.

## Wymagania
- **PHP:** 7.4 lub nowsze (pełna kompatybilność z PHP 8.x) z włączonym rozszerzeniem **GD** (`ext-gd`, wymagane do generowania hashów wizualnych).
- **Baza danych:** MySQL 5.7+ / 8.x lub MariaDB 10.x+.

## Instalacja

1. Pobierz najnowszą wersję z [katalogu rozszerzeń Piwigo](https://piwigo.org/ext/index.php?eid=1123)
2. Rozpakuj pobrane archiwum do katalogu `plugins/` w Twojej instalacji Piwigo.
3. Zaloguj się do panelu administracyjnego Piwigo.
4. Przejdź do **Wtyczki > Zarządzaj**.
5. Znajdź "Find Duplicates" na liście i kliknij **Instaluj**, a następnie **Aktywuj**.

## Użytkowanie
Po aktywacji dostęp do narzędzia uzyskasz przez lewe menu w panelu administratora w sekcji **Zdjęcia > Find Duplicates**.

## Licencja
Ten projekt jest licencjonowany na warunkach licencji GNU General Public License v2.0 lub nowszej. Zobacz plik `LICENSE` w celu uzyskania szczegółów.
