import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'main_wrapper.dart';

class LoginScreen extends StatefulWidget {
  final String logoUrl;
  const LoginScreen({super.key, required this.logoUrl});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Dynamic Logo from Admin Dashboard
              widget.logoUrl.isNotEmpty 
                ? Image.network(widget.logoUrl, height: 120)
                : Icon(Icons.school, size: 100, color: color),
              const SizedBox(height: 40),
              const Text("Login to Study", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _name,
                decoration: InputDecoration(hintText: "Full Name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: "Mobile Number", prefixText: "+91 ", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: _isLoading ? null : () async {
                    if(_name.text.isEmpty || _phone.text.length < 10) return;
                    setState(() => _isLoading = true);
                    bool ok = await ApiService.loginUser(_name.text, _phone.text);
                    if(ok) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const MainWrapper()));
                    setState(() => _isLoading = false);
                  },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("GET STARTED", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}