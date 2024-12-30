import 'dart:async';
import 'package:ardennes/injection.dart';
import 'package:ardennes/models/accounts/fake_user_data.dart';
import 'package:ardennes/models/companies/fake_company_data.dart';
import 'package:ardennes/models/drawings/fake/fake_drawing_detail_data.dart';
import 'package:ardennes/models/drawings/fake/fake_drawings_catalog_data.dart';
import 'package:ardennes/models/projects/fake_project_data.dart';
import 'package:ardennes/models/screens/fake_home_screen_data.dart';
import 'package:ardennes/route_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "assets/.env");
  if (dotenv.get("USE_FIREBASE_EMU", fallback: "false") == "true") {
    await _configureFirebaseAuth();
    await _configureFirebaseFirestore();
    await _configureFirebaseStorage();
  }
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

Future<void> _configureFirebaseAuth() async {
  var host = dotenv.get("FIREBASE_EMU_URL", fallback: "localhost");
  var port = int.parse(dotenv.get("AUTH_EMU_PORT", fallback: "9099"));
  await FirebaseAuth.instance.useAuthEmulator(host, port);
  debugPrint('Using Firebase Auth emulator on: $host:$port');
}

Future<void> _configureFirebaseFirestore() async {
  var host = dotenv.get("FIREBASE_EMU_URL", fallback: "localhost");
  var port = int.parse(dotenv.get("FIRESTORE_EMU_PORT", fallback: "8080"));
  FirebaseFirestore.instance.useFirestoreEmulator(host, port);
  debugPrint('Using Firebase Firestore emulator on: $host:$port');
  // Leave as commented if loading from firebase emualator export
  // E.g. firebase emulators:start --import=.firebase/emulator/export
  // populateFirestore();
}

void populateFirestore() {
  populateCompanies();
  populateProjects();
  final drawings = populateDrawingsDetailNoorAcademy();
  populateDrawingsCatalogNoorAcademy(drawings);
  populateUsers();
  populateHomeScreens();
}

Future<void> _configureFirebaseStorage() async {
  var host = dotenv.get("FIREBASE_EMU_URL", fallback: "localhost");
  var port = int.parse(dotenv.get("STORAGE_EMU_PORT", fallback: "9199"));
  FirebaseStorage.instance.useStorageEmulator(host, port);
  debugPrint('Using Firebase storage emulator on: $host:$port');
}


