import 'package:bitirme_project/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome to FruitVision",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  SizedBox(height: 10),
                  Container(
                    width: 155,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Colors.lightGreen, Colors.deepOrange],
                      ),
                    ),
                  ),
                  Text(
                    "FruitVision",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pacifico(fontSize: 55, color: Colors.white)
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 84,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Colors.lightGreen, Colors.deepOrange],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(elevation: 12),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>cameraScreen()));
                    }, 
                    icon: Icon(Icons.arrow_circle_right_outlined,size: 30, color: Colors.blue.shade700,), 
                    label: Text("Başla",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.blue.shade700),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
