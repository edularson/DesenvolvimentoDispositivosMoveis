import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importar Google Fonts

class PlayerDetailPage extends StatelessWidget {
  final Map<String, dynamic> player;

  const PlayerDetailPage({Key? key, required this.player}) : super(key: key);

  // --- NOVA PALETA DE CORES ---
  final Color corFundo = const Color(0xFF121212);
  final Color corCard = const Color(0xFF1E1E1E);
  final Color corDestaqueOuro = const Color(0xFFD4AF37);
  // --- FIM DA PALETA ---

  @override
  Widget build(BuildContext context) {
    // Pega os dados do map
    final String? fotoUrl = player['strRender'] ?? player['strCutout'] ?? player['strThumb'];
    final String nome = player['strPlayer'] ?? "Jogador Desconhecido";
    final String nacionalidade = player['strNationality'] ?? "N/A";
    final String time = player['strTeam'] ?? "Sem time";
    final String posicao = player['strPosition'] ?? "N/A";
    final String dataNasc = player['dateBorn'] ?? "N/A";
    final String descricao = player['strDescriptionPT'] ?? player['strDescriptionEN'] ?? "Nenhuma descrição disponível.";

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        title: Text(
          nome,
          // Usando a fonte Poppins
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: corDestaqueOuro), // Ícone Dourado
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- FOTO DO JOGADOR ---
            if (fotoUrl != null)
              Container(
                height: 300,
                color: corCard, // Fundo cinza escuro para a foto
                child: Image.network(
                  fotoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Icon(Icons.person, size: 150, color: Colors.grey[700]),
                ),
              )
            else
              Container(
                height: 300,
                color: corCard,
                child: Icon(Icons.person, size: 150, color: Colors.grey[700]),
              ),
            
            // --- TÍTULO E DETALHES ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Chips de informação
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      Chip(
                        avatar: Icon(Icons.flag, color: corDestaqueOuro),
                        label: Text(
                          nacionalidade,
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                      Chip(
                        avatar: Icon(Icons.shield, color: corDestaqueOuro),
                        label: Text(
                          time,
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                      Chip(
                        avatar: Icon(Icons.sports_soccer, color: corDestaqueOuro),
                        label: Text(
                          posicao,
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                       Chip(
                        avatar: Icon(Icons.cake, color: corDestaqueOuro),
                        label: Text(
                          dataNasc,
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                    ],
                  ),

                  // --- DESCRIÇÃO ---
                  SizedBox(height: 20),
                  Text(
                    "Biografia",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: corDestaqueOuro, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(color: Colors.grey[800], height: 15),
                  Text(
                    descricao,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.grey[400], fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}