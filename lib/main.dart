import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:csp_news_blog/screens/home_screen.dart';
import 'package:csp_news_blog/screens/page_not_found_screen.dart';
import 'config.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: apiKey,
          authDomain: authDomain,
          projectId: projectId,
          storageBucket: storageBucket,
          messagingSenderId: messagingSenderId,
          appId: appId));

  if (userEmulator) {
    // await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
    // FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);

    FirebaseStorage.instanceFor(bucket: storageBucket)
        .useStorageEmulator('localhost', 9199);
  }
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) => PageNotFoundScreen(key: key)),
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const HomePage(),
        "/web/": (BuildContext context) => const HomePage(),
        "/web/#/": (BuildContext context) => const HomePage(),
        "/#/": (BuildContext context) => const HomePage(),
        "#/web/": (BuildContext context) => const HomePage(),
        "#/web/#": (BuildContext context) => const HomePage(),
      },
      title: '雲端新知部落格',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
