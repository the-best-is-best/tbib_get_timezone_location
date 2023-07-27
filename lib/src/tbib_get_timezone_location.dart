import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tbib_get_timezone_location/gen/assets.gen.dart';

/// {@template tbib_get_timezone_location}
/// Get timezone location from time offest user
/// {@endtemplate}
class TbibGetTimezoneLocation {
  /// {@macro tbib_get_timezone_location}
  static late String dbPath;

  /// init database
  Future<void> init() async {
    final databaseFile =
        await _createDatabase(const $AssetsDatabaseGen().timeZone);
    // final database = await openDatabase(databaseFile.path);
    dbPath = databaseFile.path;
  }

  Future<File> _createDatabase(String dbName) async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.location);
      exit(0);
    }
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, 'assets', 'database', dbName);

    final exists = await databaseExists(dbPath);
    if (!exists) {
      // Create the directory structure if it does not exist
      await Directory(dirname(dbPath)).create(recursive: true);

      // Copy the database from the assets folder to the documents directory
      final data =
          await rootBundle.load('packages/tbib_get_timezone_location/$dbName');
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(dbPath).writeAsBytes(bytes);
    }

    return File(dbPath);
  }

  Future<String?> _getUserCountryCode() async {
    await Geolocator.requestPermission();
    final position = await Geolocator.getCurrentPosition();
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final countryCode = placemarks.first.country;
    return countryCode;
  }

  /// get timezone
  Future<String?> getTimezones() async {
    final offsetWithSeconds = DateTime.now().timeZoneOffset.inSeconds;
    final getUserCountry = await _getUserCountryCode();
    log('getUserCountry: $getUserCountry');
    final db = await openDatabase(dbPath);
    final countryCodeResult = await db.query(
      'country',
      where: 'country = ?',
      whereArgs: [getUserCountry],
    );
    final result = await db.query(
      'time_zone',
      where: 'country_code = ? AND gmt_offset = ?',
      whereArgs: [countryCodeResult.first['country_code'], offsetWithSeconds],
    );
    await db.close();
    return result.first['zone_name'] as String?;
  }
}
