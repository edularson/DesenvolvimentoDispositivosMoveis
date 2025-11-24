import 'dart:io';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/player_model.dart';
import 'player_page.dart';
import 'player_info_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  // Controle da Pesquisa
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  void logout() {
    _authService.signOut();
  }

  int _calculateOverall(Player player) {
    if (player.rating == 0) return 60;
    int baseOverall = 60 + (player.rating * 6).toInt();
    if (player.age > 25) {
      baseOverall += (player.age - 25) ~/ 3;
    }
    return baseOverall.clamp(40, 99);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerPage()),
          );
        },
        backgroundColor: Colors.greenAccent[400],
        child: const Icon(Icons.add, color: Colors.black87),
      ),

      body: StreamBuilder<List<Player>>(
        stream: _firestoreService.getPlayersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Erro ao carregar dados."));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Player> allPlayers = snapshot.data ?? [];

          List<Player> displayedPlayers = allPlayers.where((p) {
            return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (displayedPlayers.isEmpty) {
            return Center(
              child: Text(
                _isSearching
                    ? "Nenhum jogador encontrado."
                    : "Seu elenco está vazio.",
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.7,
            ),
            itemCount: displayedPlayers.length,
            itemBuilder: (context, index) =>
                _buildPlayerGridItem(context, displayedPlayers[index]),
          );
        },
      ),
    );
  }

  AppBar _buildNormalAppBar() {
    return AppBar(
      centerTitle: true,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.sports_soccer, color: Colors.amber),
      ),
      title: const Text("Meus Jogadores"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchQuery = "";
            _searchController.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: const InputDecoration(
          hintText: "Buscar jogador...",
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
        onChanged: (text) {
          setState(() {
            _searchQuery = text;
          });
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              _searchQuery = "";
            });
          },
        ),
      ],
    );
  }

  Widget _buildPlayerGridItem(BuildContext context, Player player) {
    int overall = _calculateOverall(player);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerInfoPage(player: player),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.grey[700]!, width: 1.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[850]!, Colors.grey[900]!],
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Hero(
                    tag: player.id.toString(),
                    child: Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 2.0),
                        image: DecorationImage(
                          image: player.img != null && player.img!.isNotEmpty
                              ? FileImage(File(player.img!))
                              : const AssetImage(
                                      "assets/imgs/player_placeholder.png",
                                    )
                                    as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber, width: 1),
                  ),
                  child: Text(
                    overall.toString(),
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.position,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < player.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
