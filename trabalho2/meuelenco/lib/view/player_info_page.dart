import 'dart:io';
import 'package:flutter/material.dart';
import '../database/helper/player_helper.dart'; 
import '../database/model/player_model.dart';
import 'player_page.dart'; 

const String deleteSignal = "DELETED";

class PlayerInfoPage extends StatefulWidget {
  final Player player;
  const PlayerInfoPage({Key? key, required this.player}) : super(key: key);

  @override
  State<PlayerInfoPage> createState() => _PlayerInfoPageState();
}

class _PlayerInfoPageState extends State<PlayerInfoPage> {
  late Player _player;
  final PlayerHelper _helper = PlayerHelper(); 

  @override
  void initState() {
    super.initState();
    _player = widget.player; 
  }

  void _navigateToEditPage() async {
    final updatedPlayer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(player: _player),
      ),
    );
    if (updatedPlayer != null) setState(() => _player = updatedPlayer);
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: Text("Tem certeza que deseja excluir o jogador ${_player.name}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _helper.deletePlayer(_player.id!);
                Navigator.pop(dialogContext); 
                Navigator.pop(context, deleteSignal); 
              },
            ),
          ],
        );
      },
    );
  }

  int _calculateOverall(Player player) {
    if (player.rating == null || player.rating == 0) return 60; 
    int baseOverall = 60 + (player.rating! * 6).toInt(); 
    if (player.age != null && player.age! > 25) {
      baseOverall += (player.age! - 25) ~/ 3; 
    }
    return baseOverall.clamp(40, 99); 
  }

  @override
  Widget build(BuildContext context) {
    int overall = _calculateOverall(_player); 

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _player); 
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_player.name), 
          actions: [
            IconButton(icon: const Icon(Icons.edit), onPressed: _navigateToEditPage),
            IconButton(icon: const Icon(Icons.delete), onPressed: _showDeleteConfirmationDialog),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2.0), // Dourado
                  gradient: LinearGradient( 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ Colors.grey[850]!, Colors.black87 ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 1.5),
                          ),
                          child: Text(
                            overall.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary, // Dourado
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Hero(
                          tag: _player.id.toString(),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 3.0),
                              image: DecorationImage(
                                image: _player.img != null
                                    ? FileImage(File(_player.img!))
                                    : const AssetImage("assets/imgs/player_placeholder.png")
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _player.name,
                      style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _player.position ?? "Posição não informada",
                      style: const TextStyle(fontSize: 18.0, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    _buildReadOnlyStars(_player.rating, size: 25), 
                  ],
                ),
              ),
              const SizedBox(height: 25),

              Text(
                "Informações Principais",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.secondary, // Dourado
                ),
              ),
              const SizedBox(height: 10),
              _buildStatsGrid(),
              const SizedBox(height: 25),

              _buildInfoTile(
                icon: Icons.flag_outlined,
                title: "Nacionalidade",
                subtitle: _player.nationality ?? "Não informada",
              ),
              _buildInfoTile(
                icon: Icons.accessibility_new,
                title: "Pé Dominante",
                subtitle: _player.dominantFoot ?? "Não informado",
              ),
              _buildInfoTile(
                icon: Icons.trending_up,
                title: "Valor de Mercado",
                subtitle: _player.marketValue ?? "Não informado",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyStars(double? rating, {double size = 30}) {
    double currentRating = rating ?? 0.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < currentRating ? Icons.star : Icons.star_border,
          color: Theme.of(context).colorScheme.secondary, // Dourado
          size: size,
        );
      }),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      crossAxisCount: 2, 
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      childAspectRatio: 2.5, 
      children: [
        _buildStatItem(Icons.person, "Idade", _player.age?.toString() ?? "N/A"),
        _buildStatItem(Icons.shield, "Clube", _player.club ?? "N/A"),
        _buildStatItem(Icons.numbers, "Camisa", _player.shirtNumber?.toString() ?? "N/A"),
        _buildStatItem(Icons.group, "Overall", _calculateOverall(_player).toString()), 
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          // *** MUDANÇA AQUI ***
          // O ícone agora usa a cor 'primary' (Verde)
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 30), // Dourado
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}