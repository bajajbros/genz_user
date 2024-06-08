import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:customer/camera_test.dart';
import 'package:customer/module_helper/app_info.dart';
import 'package:customer/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'api/api_value.dart';
import 'firebase_options.dart';
late Socket socket;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  cameras = await availableCameras();
  runApp(
    const CustomerApp(),
  );
}

class CustomerApp extends StatefulWidget {
  const CustomerApp({Key? key}) : super(key: key);
  @override
  State<CustomerApp> createState() => _CustomerAppState();
}

class _CustomerAppState extends State<CustomerApp> {
  @override
  void initState() {
    socket = io(baseUrl, OptionBuilder().setTransports(['websocket']).build());
    log(socket.active.toString());
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true, scaffoldBackgroundColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
