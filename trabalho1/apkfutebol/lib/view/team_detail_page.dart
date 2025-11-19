import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamDetailPage extends StatelessWidget {
  final Map<String, dynamic> team;
  const TeamDetailPage({Key? key, required this.team}) : super(key: key);

  final Color corFundo = const Color(0xFF121212);
  final Color corCard = const Color(0xFF1E1E1E);
  final Color corDestaqueOuro = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final String? bannerUrl = team['strTeamBanner'] ?? team['strStadiumThumb'];
    final String? logoUrl = team['strTeamBadge'] ?? team['strTeamLogo'] ?? team['strTeamJersey'];
    final String nome = team['strTeam'] ?? "Time Desconhecido";
    final String ano = team['intFormedYear'] ?? "N/A";
    final String estadio = team['strStadium'] ?? "N/A";
    final String liga = team['strLeague'] ?? "N/A";
    final String descricao = team['strDescriptionPT'] ?? team['strDescriptionEN'] ?? "Nenhuma descrição disponível.";

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        title: Text(
          nome,
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: corDestaqueOuro),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (bannerUrl != null)
              Image.network(
                bannerUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 200,
                  color: corCard,
                  child: Center(
                    child: (logoUrl != null) 
                           ? Image.network(logoUrl, height: 100, fit: BoxFit.contain)
                           : Icon(Icons.shield, size: 100, color: Colors.grey[700]),
                  )
                ),
              )
            else
              Container(
                  height: 200,
                  color: corCard,
                  child: Center(
                    child: (logoUrl != null) 
                           ? Image.network(logoUrl, height: 100, fit: BoxFit.contain)
                           : Icon(Icons.shield, size: 100, color: Colors.grey[700]),
                  )
                ),
            
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
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      Chip(
                        avatar: Icon(Icons.calendar_today, color: corDestaqueOuro),
                        label: Text(
                          "Fundado em $ano",
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                      Chip(
                        avatar: Icon(Icons.flag, color: corDestaqueOuro),
                        label: Text(
                          liga,
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                      Chip(
                        avatar: Icon(Icons.stadium, color: corDestaqueOuro),
                        label: Text(
                          estadio,
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
                        ),
                        backgroundColor: corCard,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Descrição",
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