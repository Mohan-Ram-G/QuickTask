import 'package:flutter/material.dart';
import './pages/homepage.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'Qw3zooTyKnng2DOQjDE6UiA0uIq7G3pLZWNScrUK';
  const keyClientKey = 'UmXbhq5c8qZGbCmZHtjYRD136XwYp7cCoRe107Lb';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: homePage(),
      // home: loginPage(),
    );
  }
}
