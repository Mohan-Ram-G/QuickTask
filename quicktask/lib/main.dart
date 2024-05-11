import 'package:flutter/material.dart';
import './pages/loginpage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'Qw3zooTyKnng2DOQjDE6UiA0uIq7G3pLZWNScrUK';
  const keyClientKey = 'UmXbhq5c8qZGbCmZHtjYRD136XwYp7cCoRe107Lb';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: homePage(),
      home: loginPage(),
    );
  }
}
