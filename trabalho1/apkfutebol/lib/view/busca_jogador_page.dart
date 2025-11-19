
import 'package:apkfutebol/service/football_service.dart';
import 'package:apkfutebol/view/player_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuscaJogadorPage extends StatefulWidget {
  @override
  _BuscaJogadorPageState createState() => _BuscaJogadorPageState();
}

class _BuscaJogadorPageState extends State<BuscaJogadorPage> {
  final TextEditingController _controller = TextEditingController();
  final apiService = FootballApiService();
  List<dynamic> _resultados = [];
  bool _isLoading = false;
  bool _primeiraBusca = true;
  
  final Color corFundo = const Color(0xFF121212);
  final Color corCard = const Color(0xFF1E1E1E);
  final Color corDestaqueOuro = const Color(0xFFD4AF37);

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
      final resultados = await apiService.buscaJogadorPeloNome(searchTerm);
      setState(() {
        _resultados = resultados;
        _isLoading = false;
      });
      if (resultados.isEmpty) {
        _showErrorDialog("Nenhum jogador encontrado com o nome '$searchTerm'.");
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
      // --- APP BAR ATUALIZADA ---
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: corDestaqueOuro),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Meus Jogadores",
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        centerTitle: true,
        actions: [], 
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Buscar Jogador...",
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
              _primeiraBusca ? "Busque um jogador" : "Resultados da Busca",
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
      return GridView.builder(
        key: const Key('lista_grid'),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75, 
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _resultados.length,
        itemBuilder: (context, index) {
          final jogador = _resultados[index];
          return PlayerCard(
            jogador: jogador,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerDetailPage(player: jogador),
                ),
              );
            },
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


class PlayerCard extends StatelessWidget {
  final Map<String, dynamic> jogador;
  final VoidCallback onTap;

  const PlayerCard({
    Key? key,
    required this.jogador,
    required this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final String? fotoUrl = jogador['strCutout'] ?? jogador['strThumb'];
    final String nome = jogador['strPlayer'] ?? "Jogador";
    final String posicao = jogador['strPosition'] ?? "Desconhecido";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: const Color(0xFFD4AF37),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[700],
                  backgroundImage: (fotoUrl != null && fotoUrl.isNotEmpty)
                      ? NetworkImage(fotoUrl)
                      : null,
                  child: (fotoUrl == null || fotoUrl.isEmpty)
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              
              Text(
                nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 4),
              Text(
                posicao,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}