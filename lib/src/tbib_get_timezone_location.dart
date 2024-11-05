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
  static String? dbPath;

  /// init database
  Future<void> init() async {
    final databaseFile =
        await _createDatabase(const $AssetsDatabaseGen().timeZone);
    // final database = await openDatabase(databaseFile.path);
    dbPath = databaseFile?.path;
  }

  Future<File?> _createDatabase(String dbName) async {
    // If location permission is not required for the database, remove the following block
    var permission = await Permission.location.request();
    if (!permission.isGranted) {
      await AppSettings.openAppSettings(type: AppSettingsType.location);
      return null;
    }

    try {
      // Get the application documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final dbPath = join(documentsDirectory.path, dbName);

      // Check if the database already exists
      if (await databaseExists(dbPath)) {
        return File(dbPath); // Return the existing database
      }

      // Create directory if not exists
      await Directory(dirname(dbPath)).create(recursive: true);

      // Copy the database from assets
      final data =
          await rootBundle.load('packages/tbib_get_timezone_location/$dbName');
      final bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the data to the new file
      final file = await File(dbPath).writeAsBytes(bytes, flush: true);
      return file;
    } catch (e) {
      print('Error creating database: $e');
      return null;
    }
  }

  Future<String?> _getUserCountryCode() async {
    final permission = await Permission.location.isGranted;
    log('permission: $permission');
    if (!permission) {
      return null;
    }
    await Geolocator.requestPermission();

    final position = await Geolocator.getCurrentPosition();
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final countryCode = placemarks.first.country;
    return countryCode;
  }

  /// get timezone
  Future<String?> getTimezones() async {
    // if(Platform.isAndroid && )
    // final permission = await Permission.storage.isGranted &&
    //     await Permission.location.isGranted;

    if (dbPath == null) {
      return null;
    }

    if (dbPath == null) {
      await init();
    }
    final offsetWithSeconds = DateTime.now().timeZoneOffset.inSeconds;
    final getUserCountry = await _getUserCountryCode();
    log('getUserCountry: $getUserCountry');
    final db = await openDatabase(dbPath!);
    final countryCodeResult = await db.query(
      'country',
      where: 'country = ?',
      whereArgs: [getUserCountry],
    );
    final countryCode = countryCodeResult.first['country_code'];
    final result = await db.query(
      'time_zone',
      limit: 1,
      where: 'country_code = ? AND gmt_offset = ?',
      whereArgs: [countryCode, offsetWithSeconds],
    );

    await db.close();
    try {
      return result.first['zone_name'] as String?;
    } catch (e) {
      log("error $e");
      return null;
    }
  }
}
