import 'package:flutter/material.dart';
import 'package:absensibi/pages/home.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/abstract_bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_bi.png',
                      width: 150.0,
                      height: 150.0,
                    ),
                    SizedBox(height: 20.0),
                    Image.asset(
                      'assets/images/slogan_1.png',
                      width: 300.0,
                      height: 50.0,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Color(0xFF7900B1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'ABSENBI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 300.0,
                            height: 50.0,
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                hintText: 'NIS',
                                hintStyle: TextStyle(fontSize: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(
                            width: 300.0,
                            height: 50.0,
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                labelText: 'Password',
                                hintText: 'Masukkan Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          SizedBox(
                            width: 300.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => HomePage(),
                                  )
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
