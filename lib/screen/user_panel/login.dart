import 'package:flutter/material.dart';
import 'package:my_web_app/screen/admin_panel/dashboard.dart';
import 'package:my_web_app/screen/user_panel/mainscreen.dart';
import 'package:my_web_app/screen/user_panel/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
 final supabase=Supabase.instance.client;
 bool _loading=false;
 void _login()async{
  setState(() {
    _loading=true;
  });
  try {final result=await supabase.auth.signInWithPassword(email: emailController.text, password: passwordController.text);
    final user=result.user;
    if (user==null) {
      throw "failed loginpage";
    }
    final profile=await supabase.from("profile").select("name,role").eq("id", user.id).single();
    final role=profile["role"] as String;
    final name=profile["name"] as String;
    final email=user.email ?? "";
    if (role=="admin") {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen(name: name)));
    }else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(userName:name,userEmail: email,)));

    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("invalid ${e.toString()}")));
  }finally{
    setState(() {
      _loading=false;
    });
  }
 }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.amber,
         title: Text("LoginPage"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Enter Email"),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Enter password"),
          ),
          SizedBox(height: 20,),
         _loading ? CircularProgressIndicator() : ElevatedButton(onPressed: _login, child: Text("Login")),
            SizedBox(height: 20,),
          TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));}, child: Text("Register")),
        ],
      ),
    );
  }
}