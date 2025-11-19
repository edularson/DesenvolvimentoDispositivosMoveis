import 'dart:io'; 
import 'package:flutter/material.dart';
import '../database/helper/player_helper.dart';
import '../database/model/player_model.dart';
import 'player_page.dart';
import 'player_info_page.dart'; 

const String deleteSignal = "DELETED";

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlayerHelper helper = PlayerHelper();
  
  List<Player> allPlayers = []; 
  List<Player> displayedPlayers = [];
  
  bool _isSearching = false; 
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _getAllPlayers(); 
    
    _searchController.addListener(_filterPlayers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPlayers);
    _searchController.dispose();
    super.dispose();
  }

  void _getAllPlayers() {
    helper.getAllPlayers().then((list) {
      setState(() {
        allPlayers = list; 
        displayedPlayers = list; 
      });
    });
  }
  
  void _filterPlayers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      displayedPlayers = allPlayers.where((player) {
        return player.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPlayerPage();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _isSearching ? "Resultados da Busca" : "Meu Elenco", 
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: Theme.of(context).colorScheme.secondary, // Dourado
              ),
            ),
          ),
          Expanded( 
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10), 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 10.0, 
                mainAxisSpacing: 10.0, 
                childAspectRatio: 0.7, 
              ),
              itemCount: displayedPlayers.length,
              itemBuilder: (context, index) {
                return _buildPlayerGridItem(context, displayedPlayers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), 
          onPressed: _toggleSearch, 
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true, 
          decoration: const InputDecoration(
            hintText: "Buscar jogador por nome...",
            border: InputBorder.none, 
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      );
    } else {
      return AppBar(
        centerTitle: true,
        leading: Padding( 
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.sports_soccer, color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text(
          "Meus Jogadores",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          IconButton( 
            icon: const Icon(Icons.search), 
            onPressed: _toggleSearch, 
          ),
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderAZ,
                child: Text("Ordenar de A-Z"),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderZA,
                child: Text("Ordenar de Z-A"),
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      );
    }
  }


  Widget _buildPlayerGridItem(BuildContext context, Player player) {
    int overall = _calculateOverall(player);

    return GestureDetector(
      onTap: () {
        _showPlayerInfoPage(player);
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
              colors: [
                Colors.grey[850]!,
                Colors.grey[900]!,
              ],
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
                        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2.0), 
                        image: DecorationImage(
                          image: player.img != null
                              ? FileImage(File(player.img!))
                              : const AssetImage("assets/imgs/player_placeholder.png")
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 1.0),
                  ),
                  child: Text(
                    overall.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary, 
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
                      player.position ?? "Sem Posição",
                      style: const TextStyle(
                        fontSize: 13.0, 
                        color: Colors.white70 
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    _buildReadOnlyStars(player.rating), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildReadOnlyStars(double? rating) {
    double currentRating = rating ?? 0.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < currentRating ? Icons.star : Icons.star_border,
          color: Theme.of(context).colorScheme.secondary, 
          size: 16, 
        );
      }),
    );
  }

  void _showPlayerInfoPage(Player player) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerInfoPage(player: player),
      ),
    );
    if (result != null) _getAllPlayers();
  }

  void _showPlayerPage({Player? player}) async {
    final newPlayer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(player: player),
      ),
    );
    if (newPlayer != null) _getAllPlayers();
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        allPlayers.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        allPlayers.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    _filterPlayers();
  }
}