# Tbib Get Timezone Location

 Get timezone location from time offset user

 <h3> this package use for get timezone location from location device and timezone database </h3>

 <h3> Note</h3>
 <p> Why this package created  </p>
 <p> created for get timezone from time offset and location because some devices not get timezone form internet so await FlutterTimezone.getLocalTimezone(); not working  </p>

 <h3> ios permission </h3>

 ```plist
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>$(PRODUCT_NAME) uses location to get your timezone.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>$(PRODUCT_NAME) uses location to get your timezone.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>$(PRODUCT_NAME) uses location to get your timezone.</string>
    <key>NSLocationUsageDescription</key>
    <string>$(PRODUCT_NAME) uses location to get your timezone.</string>

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
