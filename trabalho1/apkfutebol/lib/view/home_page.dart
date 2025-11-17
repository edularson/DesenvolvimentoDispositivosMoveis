import 'package:apkfutebol/view/busca_jogador_page.dart';
import 'package:apkfutebol/view/busca_time_page.dart'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // --- PALETA DE CORES ---
  final Color corFundo = const Color(0xFF121212);
  final Color corVerdeNeon = const Color(0xFF39FF14);
  // --- FIM DA PALETA ---

  // --- COMPONENTE DE BOTÃO REUTILIZÁVEL ---
  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: corVerdeNeon,
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black), // Ícone preto
        label: Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.black, // Texto preto para contrastar
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Image.asset(
                'assets/imgs/soccer.gif',
                height: 300,
                width: 300,
              ),

              SizedBox(height: 40),
              Text(
                "Futebol APP", 
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Seu gerenciador de craques",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                  ),
                ),
              ),
              Spacer(),

              _buildMenuButton(
                context: context,
                title: "Buscar Jogadores",
                icon: Icons.person_search,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuscaJogadorPage()),
                  );
                },
              ),
              SizedBox(height: 20), 
              _buildMenuButton(
                context: context,
                title: "Buscar Times",
                icon: Icons.shield,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuscaTimePage()),
                  );
                },
              ),
              SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }
}