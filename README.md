# Tbib Get Timezone Location

 Get timezone location from time offset user

 <h3> this package use for get timezone location from location device and timezone database </h3>

 <h3> Note</h3>
 <p> Why this package created  </p>
 <p> created for get timezone from time offset and location because some devices not get timezone form internet so await FlutterTimezone.getLocalTimezone(); not working  </p>

 <h3> ios permission </h3>
 <h4> info.plist </h4>

 ```plist
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>$(PRODUCT_NAME) uses location to get your timezone.</string>
  

 ```

  <h4> podfile </h4>

  ```pod
  target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
    ]   
  ```

 <h3> android permission </h3>

 ```xml
  <!-- Always include this permission -->
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

  <!-- Include only if your app benefits from precise location access. -->
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
 
 ```

 <h3> How use it </h3>

 ```dart
 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TbibGetTimezoneLocation().init();
    var timezoneName = await TbibGetTimezoneLocation().getTimezones();
  log(timezoneName.toString());
  ......

 }
 
 ```
