
import 'package:apkfutebol/service/football_service.dart';
import 'package:apkfutebol/view/team_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuscaTimePage extends StatefulWidget {
  @override
  _BuscaTimePageState createState() => _BuscaTimePageState();
}

class _BuscaTimePageState extends State<BuscaTimePage> {
  final TextEditingController _controller = TextEditingController();
  final apiService = FootballApiService();
  List<dynamic> _resultados = [];
  bool _isLoading = false;
  bool _primeiraBusca = true;

  // --- PALETA DE CORES PROFISSIONAL ---
  final Color corFundo = const Color(0xFF121212);
  final Color corCard = const Color(0xFF1E1E1E);
  final Color corDestaqueOuro = const Color(0xFFD4AF37);
  // --- FIM DA PALETA ---

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: corCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(
          "Atenção",
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white70)),
        ),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: corDestaqueOuro, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _realizarBusca() async {
    final searchTerm = _controller.text;
    if (searchTerm.isEmpty) {
      _showErrorDialog("Por favor, digite um nome para buscar.");
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _primeiraBusca = false;
      _resultados = [];
    });
    try {
      final resultados = await apiService.buscaTimePeloNome(searchTerm);
      setState(() {
        _resultados = resultados;
        _isLoading = false;
      });
      if (resultados.isEmpty) {
        _showErrorDialog("Nenhum time encontrado com o nome '$searchTerm'.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Erro de conexão. Verifique sua internet e tente novamente.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      // --- APP BAR PROFISSIONAL ---
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: corDestaqueOuro),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Buscar Times",
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        centerTitle: true,
        actions: [], // Ícones removidos
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            // --- BARRA DE BUSCA PROFISSIONAL ---
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Buscar Time...",
                hintStyle: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[600])),
                fillColor: corCard,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: corDestaqueOuro),
                  onPressed: _realizarBusca,
                ),
              ),
              style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontSize: 16)),
              onSubmitted: (_) => _realizarBusca(),
            ),
            SizedBox(height: 20),
            Text(
              _primeiraBusca ? "Busque um time" : "Resultados da Busca",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: corDestaqueOuro,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _buildResultados(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultados() {
    if (_isLoading) {
      return Center(
        key: const Key('loading'),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(corDestaqueOuro),
        ),
      );
    }

    if (_resultados.isNotEmpty) {
      // Usando um ListView normal, já que não temos tantos dados
      return ListView.builder(
        key: const Key('lista_times'),
        itemCount: _resultados.length,
        itemBuilder: (context, index) {
          final time = _resultados[index];
          // Lembre-se: os logos dos times não funcionam na API gratuita
          // A API envia 'null', então o ícone 🛡️ será exibido.
          final String? logoUrl = time['strTeamBadge'] ?? time['strTeamLogo'] ?? time['strTeamJersey'];

          return Card(
            color: corCard,
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              splashColor: corFundo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamDetailPage(team: time),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: (logoUrl != null && logoUrl.isNotEmpty)
                      ? Image.network(
                          logoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Icon(Icons.shield, color: Colors.grey[600], size: 40),
                        )
                      : Icon(Icons.shield, color: Colors.grey[600], size: 40),
                  title: Text(
                    time['strTeam'] ?? "Time Desconhecido",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Text(
                    time['strLeague'] ?? "Liga Desconhecida",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
                ),
              ),
            ),
          );
        },
      );
    }

    return Center(
      key: const Key('inicial'),
      child: Text(
        _primeiraBusca ? "" : "Nenhum resultado.",
        style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white70, fontSize: 18)),
        textAlign: TextAlign.center,
      ),
    );
  }
}