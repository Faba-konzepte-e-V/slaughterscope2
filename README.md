
# Slaughterscope Map Flutter App

This Flutter web and Android application displays a map of slaughterhouses in Germany, using public data from a CSV file. 
The app features marker clustering, popups with detailed information, and zoom controls.
It is built with `flutter_map` and related packages to provide an interactive map experience.

---

## **Features**

1. **Interactive Map**:
   - Displays slaughterhouses in Germany on a map using markers.
   - Uses OpenStreetMap tiles for the map layer.

2. **Marker Clustering**:
   - Clusters markers for better visibility at lower zoom levels.
   - Automatically splits clusters as the user zooms in.

3. **Detailed Info Cards**:
   - Displays detailed information (name, address, activities, etc.) about a slaughterhouse when a marker is clicked/tapped.
   - Cards include German translations of all fields and expanded abbreviations.

4. **Zoom Controls**:
   - Floating buttons for zooming in and out.
   - Clicking a marker zooms to street level and centers the map.

5. **CSV Data Parsing**:
   - Data is loaded from a tab-separated CSV file located in the `assets` folder.
   - Abbreviations in activities are dynamically expanded with their German meanings.

---

## **Installation**

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Git

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

---

## **Data Source**

The app uses a CSV file (`assets/slaughterhouses.csv`) with the following columns:
- **Neue Zulassungsnummer(n)**: New approval number(s)
- **Name des Betriebs**: Name of the establishment
- **Straße**: Street address
- **PLZ**: Postal code
- **Stadt**: City
- **Landkreis**: District
- **Bundesland**: State
- **Kategorie**: Category
- **Weitere Aktivitäten**: Additional activities (expanded dynamically)
- **Tierarten / Erzeugnis**: Species or products
- **Bemerkungen**: Notes
- **latitude**: Latitude coordinate
- **longitude**: Longitude coordinate

---

## **CSV Abbreviations**

### **Category and Activity Codes**
The `Kategorie` and `Weitere Aktivitäten` columns contain abbreviations. These are expanded dynamically in the app as follows:

| Abbreviation   | German Description                                          |
|----------------|------------------------------------------------------------|
| `0(CS)`        | Kategorie 0 (Kühlhaus)                                     |
| `0(RW)`        | Kategorie 0 (Betrieb für Umpacken und Neuverpacken)        |
| `0(WM)`        | Kategorie 0 (Großhandelsmarkt)                             |
| `II(SH)`       | Kategorie II (Schlachthof für Geflügel und Hasentiere)     |
| `II(CP)`       | Kategorie II (Zerlegebetrieb für Geflügel und Hasentiere)  |
| `III(SH)`      | Kategorie III (Schlachthof für Farmwild)                   |
| `III(CP)`      | Kategorie III (Zerlegebetrieb für Farmwild)                |
| `IV(GHE)`      | Kategorie IV (Wildbearbeitungsbetrieb)                     |
| `IV(CP)`       | Kategorie IV (Zerlegebetrieb für Wild)                     |
| `V(MM)`        | Kategorie V (Betrieb für Hackfleisch)                      |
| `V(MP)`        | Kategorie V (Betrieb für Fleischzubereitungen)             |
| `VI(PP)`       | Kategorie VI (Verarbeitungsbetrieb für Fleischerzeugnisse) |
| `VIII(PP)`     | Kategorie VIII (Verarbeitungsbetrieb für Fischerzeugnisse) |
| `X(PP)`        | Kategorie X (Verarbeitungsbetrieb für Eier und Eiprodukte) |
| `X(EPC)`       | Kategorie X (Eierpackstelle)                               |
| `XII(PP)`      | Kategorie XII (Verarbeitungsbetrieb für geschmolzene tierische Fette und Grieben) |
| `XIII(PP)`     | Kategorie XIII (Verarbeitungsbetrieb für behandelte Mägen, Blasen und Därme) |

---

## **Project Structure**

```plaintext
lib/
├── main.dart                   # Entry point of the app
├── models/
│   ├── slaughterhouse.dart     # Model for Slaughterhouse data
│   └── slaughterhouse_provider.dart  # State management and CSV parsing
├── screens/
│   └── map_screen.dart         # Main screen with map and markers
assets/
└── slaughterhouses.csv         # Data source for the app
```

---

## **Dependencies**

Here are the main dependencies used in the project:
- `flutter_map`: Interactive maps
- `flutter_map_marker_cluster`: Marker clustering
- `provider`: State management
- `csv`: CSV file parsing
- `latlong2`: Latitude and longitude utilities

Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_map: ^5.0.0
  flutter_map_marker_cluster: ^1.4.0
  provider: ^6.1.2
  csv: ^5.0.0
  latlong2: ^0.9.1

flutter:
  assets:
    - assets/slaughterhouses.csv
```

---

## **Known Issues**

1. **Tile Server Warning**:
    - The app uses OpenStreetMap tiles (`https://tile.openstreetmap.org/{z}/{x}/{y}.png`).
    - Avoid subdomains (`a`, `b`, `c`) as they are deprecated.

2. **Large Dataset Performance**:
    - Marker clustering may lag with very large datasets. TBD to load the data with ssh from a DB

---

## **Contributing**

1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of feature"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Create a pull request.

---

## **License**

TBD

---

## **Contact**

For questions or feedback, please contact via https://faba-konzepte.de/kontakt/
