import 'package:flutter/material.dart';
import 'package:my_web_app/screen/user_panel/mainscreen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

await Supabase.initialize(
  url: 'https://vushjadzixjrzhyjnymn.supabase.co',
  anonKey: 'sb_publishable_PmTM-TEeL6EPYpTnAE50PA_5T1y8Chf',
);

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
 const  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: MainScreen(userName: "Guest",userEmail: "GuestEmail",)
       
      
    );
    
  }
}
