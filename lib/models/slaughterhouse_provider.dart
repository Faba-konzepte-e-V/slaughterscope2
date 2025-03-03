import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';


class SlaughterhouseProvider extends ChangeNotifier {
  List<Slaughterhouse> slaughterhouses = [];

  Future<void> loadData() async {
    final csvFile = await rootBundle.loadString('assets/slaughterhouses.csv');
    final rows = const CsvToListConverter(eol: '\n', fieldDelimiter: '\t')
        .convert(csvFile, shouldParseNumbers: false);

    // Extract header
    final headers = rows.first.cast<String>();
    final dataRows = rows.skip(1); // Skip header row

    slaughterhouses = dataRows.map((row) {
      final rowData = Map<String, dynamic>.fromIterables(headers, row);
      return Slaughterhouse.fromCsv(rowData);
    }).toList();

    notifyListeners();
  }
}

class Slaughterhouse {
  final String name;
  final String street;
  final String postalCode;
  final String city;
  final String district;
  final String state;
  final String category;
  final String activities;
  final String species;
  final String notes;
  final double latitude;
  final double longitude;

  Slaughterhouse({
    required this.name,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.district,
    required this.state,
    required this.category,
    required this.activities,
    required this.species,
    required this.notes,
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create a Slaughterhouse from a CSV row
  factory Slaughterhouse.fromCsv(Map<String, dynamic> row) {
    return Slaughterhouse(
      name: row['Name des Betriebs'] ?? '',
      street: row['Straße'] ?? '',
      postalCode: row['PLZ'] ?? '',
      city: row['Stadt'] ?? '',
      district: row['Landkreis'] ?? '',
      state: row['Bundesland'] ?? '',
      category: row['Kategorie'] ?? '',
      activities: row['Weitere Aktivitäten'] ?? '',
      species: row['Tierarten / Erzeugnis'] ?? '',
      notes: row['Bemerkungen'] ?? '',
      latitude: double.tryParse(row['latitude']?.replaceAll(',', '.') ?? '0') ?? 0,
      longitude: double.tryParse(row['longitude']?.replaceAll(',', '.') ?? '0') ?? 0,
    );
  }
}
