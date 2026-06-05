import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
 final supabase=Supabase.instance.client;
 bool _loading=false;
 void _register()async{
  setState(() {
    _loading=true;
  });
  try {final result=await supabase.auth.signUp(email: emailController.text, password: passwordController.text);
    final user=result.user;
    if (user==null) {
      throw "failed loginpage";
    }
   await supabase.from("profile").insert({"id":user.id , "name":nameController.text,"role":"client"});
        
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Record Registerd")));
         
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
         title: Text("RegisterPage"),
      ),
      body: Column(
        children: [
           TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Enter Name"),
          ),
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
         _loading ? CircularProgressIndicator() : ElevatedButton(onPressed: _register, child: Text("Login")),
            SizedBox(height: 20,),
        ],
      ),
    );
  }
}