// lib/view/welcome_page.dart
import 'package:flutter/material.dart';
import 'home_page.dart'; // Importa a página da grade

// Convertido para StatefulWidget para permitir animação
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

// Adiciona 'with SingleTickerProviderStateMixin' para o AnimationController
class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  
  // Controladores para a animação de "pulsação" do botão
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configura o controlador da animação
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500), // Duração de 1.5s
    );

    // Configura a animação para variar a opacidade do brilho
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Inicia a animação em loop (vai e volta)
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    // Limpa o controlador da memória
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cor de destaque (Verde Neon)
    final Color accentColor = Colors.greenAccent[400]!;

    return Scaffold(
      body: Container(
        // 1. FUNDO COM GRADIENTE SUTIL (para profundidade)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!, // Cor de fundo principal
              Colors.black,      // Preto puro na parte de baixo
            ],
          ),
        ),
        child: SafeArea( 
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                
                const Spacer(flex: 2), 

                // 2. GIF COM "GLOW" (BRILHO)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.5),
                        blurRadius: 30.0, // Aumenta o "espalhamento" do brilho
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
                    // Adiciona um brilho sutil ao texto também
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
                    fontWeight: FontWeight.w300, // Fonte mais fina
                  ),
                ),

                const Spacer(flex: 3),

                // 3. BOTÃO COM ANIMAÇÃO DE PULSAÇÃO
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        // O brilho (sombra) é animado
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(_glowAnimation.value), // Opacidade animada
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: child, // O child é o InkWell + Botão
                    );
                  },
                  // O 'child' do AnimatedBuilder é o nosso botão.
                  // Isso é mais eficiente, pois o botão em si não é reconstruído, 
                  // apenas o 'Container' de brilho em volta dele.
                  child: Material(
                    color: Colors.transparent, // Necessário para o InkWell
                    child: InkWell(
                      onTap: () {
                        // Desativa a animação antes de trocar de tela
                        _animationController.stop(); 
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      splashColor: Colors.green[700], // Efeito de clique
                      borderRadius: BorderRadius.circular(8.0),
                      child: Ink(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          // O botão em si tem um gradiente
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
                            color: Colors.black87, // Texto preto
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