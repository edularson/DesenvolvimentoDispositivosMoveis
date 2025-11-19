import 'package:flutter/material.dart';
import 'home_page.dart'; 

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500), 
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Colors.greenAccent[400]!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!, 
              Colors.black,      
            ],
          ),
        ),
        child: SafeArea( 
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                
                const Spacer(flex: 2), 

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.5),
                        blurRadius: 30.0, 
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/gifs/soccer.gif',
                    height: 200, 
                  ),
                ),
                const SizedBox(height: 32),
                
                // --- Títulos ---
                Text(
                  'Meus Jogadores',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: accentColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seu gerenciador de craques',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w300, 
                  ),
                ),

                const Spacer(flex: 3),

                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(_glowAnimation.value), 
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: child, 
                    );
                  },
                  child: Material(
                    color: Colors.transparent, 
                    child: InkWell(
                      onTap: () {
                        _animationController.stop(); 
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      splashColor: Colors.green[700], 
                      borderRadius: BorderRadius.circular(8.0),
                      child: Ink(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accentColor, Colors.green[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          'Ver Meus Jogadores',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87, 
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}