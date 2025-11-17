import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lablink/Home/home.dart';
import 'package:lablink/SuperAdmin/Providers/dashboard_provider.dart';
import 'package:lablink/firebase_options.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // debugPaintPointersEnabled = true;
  runApp(
  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
    child: MyApp())
  );
}
