import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../database/helper/player_helper.dart';
import '../database/model/player_model.dart';

class PlayerPage extends StatefulWidget {
  final Player? player;
  const PlayerPage({Key? key, this.player}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final PlayerHelper _helper = PlayerHelper();
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _clubController = TextEditingController();
  final _shirtNumberController = TextEditingController();
  final _marketValueController = TextEditingController();

  String? _selectedPosition;
  String? _selectedNationality;
  String? _selectedDominantFoot;

  final _marketValueMask = MaskTextInputFormatter(
      mask: '€ #.###.###.###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final List<String> _positions = [
    'Goleiro', 'Defensor', 'Meio-campista', 'Atacante'
  ];
  final List<String> _nationalities = [
    'Brasileiro', 'Argentino', 'Português', 'Francês', 'Alemão', 'Inglês'
  ];
  final List<String> _dominantFeet = ['Direito', 'Esquerdo', 'Ambidestro'];

  bool _userEdited = false;
  Player? _editPlayer;


  @override
  void initState() {
    super.initState();
    if (widget.player == null) {
      _editPlayer = Player(name: "", rating: 0.0); 
    } else {
      _editPlayer = widget.player;
      if (_editPlayer!.rating == null) { 
          _editPlayer!.rating = 0.0;
      }
      _nameController.text = _editPlayer?.name ?? '';
      _ageController.text = _editPlayer?.age?.toString() ?? '';
      _clubController.text = _editPlayer?.club ?? '';
      _shirtNumberController.text = _editPlayer?.shirtNumber?.toString() ?? '';
      _marketValueController.text = _editPlayer?.marketValue ?? '';
      _selectedPosition = _editPlayer?.position;
      _selectedNationality = _editPlayer?.nationality;
      _selectedDominantFoot = _editPlayer?.dominantFoot;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editPlayer?.name.isEmpty ?? true
            ? "Novo Jogador"
            : _editPlayer!.name),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePlayer,
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _selectImage, 
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editPlayer?.img != null
                        ? FileImage(File(_editPlayer!.img!))
                        : const AssetImage("assets/imgs/player_placeholder.png")
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Text("Avaliação do Jogador", style: TextStyle(fontSize: 16, color: Colors.white70)),
            _buildStarRating(),
            const SizedBox(height: 10),

            _buildTextField(
              label: "Nome",
              controller: _nameController,
              onChanged: (text) {
                _userEdited = true;
                setState(() { _editPlayer?.name = text; });
              },
            ),
            _buildTextField(
              label: "Idade",
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (text) {
                _userEdited = true;
                _editPlayer?.age = int.tryParse(text);
              },
            ),
            _buildTextField(
              label: "Número da Camisa",
              controller: _shirtNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (text) {
                _userEdited = true;
                _editPlayer?.shirtNumber = int.tryParse(text);
              },
            ),
            _buildTextField(
              label: "Clube Atual",
              controller: _clubController,
              onChanged: (text) {
                _userEdited = true;
                _editPlayer?.club = text;
              },
            ),
            _buildTextField(
              label: "Valor de Mercado",
              controller: _marketValueController,
              keyboardType: TextInputType.number,
              inputFormatters: [_marketValueMask],
              onChanged: (text) {
                _userEdited = true;
                _editPlayer?.marketValue = text;
              },
            ),
            const SizedBox(height: 10),
            _buildDropdown(
              label: "Posição",
              value: _selectedPosition,
              items: _positions,
              onChanged: (value) {
                setState(() {
                  _userEdited = true;
                  _selectedPosition = value;
                  _editPlayer?.position = value;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildDropdown(
              label: "Nacionalidade",
              value: _selectedNationality,
              items: _nationalities,
              onChanged: (value) {
                setState(() {
                  _userEdited = true;
                  _selectedNationality = value;
                  _editPlayer?.nationality = value;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildDropdown(
              label: "Pé Dominante",
              value: _selectedDominantFoot,
              items: _dominantFeet,
              onChanged: (value) {
                setState(() {
                  _userEdited = true;
                  _selectedDominantFoot = value;
                  _editPlayer?.dominantFoot = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o seletor de estrelas interativo
  Widget _buildStarRating() {
    double currentRating = _editPlayer?.rating ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        double starValue = index + 1.0;
        
        return IconButton(
          icon: Icon(
            currentRating >= starValue ? Icons.star : Icons.star_border,
            color: Theme.of(context).colorScheme.secondary, // Dourado 
            size: 30,
          ),
          onPressed: () {
            setState(() {
              _userEdited = true;
              if (currentRating == starValue) {
                _editPlayer?.rating = 0.0;
              } else {
                _editPlayer?.rating = starValue;
              }
            });
          },
        );
      }),
    );
  }


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration( labelText: label ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration( labelText: label ),
        dropdownColor: Colors.grey[800], 
        style: const TextStyle(color: Colors.white), 
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _selectImage() async {
    final ImageSource? source = await _showImageSourceDialog();
    if (source == null) return; 

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _editPlayer?.img = image.path;
        _userEdited = true;
      });
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria (Fotos)'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showValidationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // *** FUNÇÃO ATUALIZADA COM VALIDAÇÃO DE NOME DUPLICADO ***
  void _savePlayer() async {
    // 1. Validação: Nome Vazio
    String currentName = _editPlayer?.name ?? "";
    if (currentName.isEmpty) {
      _showValidationSnackBar("O nome do jogador é obrigatório!");
      return; 
    }

    // *** NOVA VALIDAÇÃO DE NOME DUPLICADO ***
    Player? existingPlayer = await _helper.getPlayerByName(currentName);
    
    if (existingPlayer != null) {
      // Um jogador com este nome JÁ existe.
      // Verificamos se é o MESMO jogador que estamos editando.
      if (existingPlayer.id != _editPlayer?.id) {
        // É UM JOGADOR DIFERENTE. Bloquear.
        _showValidationSnackBar("Já existe um jogador com este nome!");
        return; // Para a execução
      }
      // Se existingPlayer.id == _editPlayer?.id, é o mesmo jogador.
      // Não há problema, podemos continuar.
    }
    // *** FIM DA NOVA VALIDAÇÃO ***

    // 2. Validação: Idade (Obrigatória e Mínima)
    if (_editPlayer?.age == null) {
      _showValidationSnackBar("O campo 'Idade' é obrigatório.");
      return; 
    }
    if (_editPlayer!.age! < 16) {
      _showValidationSnackBar("O jogador deve ter pelo menos 16 anos.");
      return; 
    }
    // 3. Validação: Posição
    if (_editPlayer?.position == null) {
      _showValidationSnackBar("Por favor, selecione uma posição.");
      return; 
    }
    // 4. Validação: Nacionalidade
    if (_editPlayer?.nationality == null) {
       _showValidationSnackBar("Por favor, selecione uma nacionalidade.");
       return;
    }
    // 5. Validação: Número da Camisa
    if (_editPlayer?.shirtNumber == null) {
       _showValidationSnackBar("O número da camisa é obrigatório.");
       return;
    }
    // 6. Validação: Rating
    if (_editPlayer?.rating == null || _editPlayer!.rating == 0.0) {
       _showValidationSnackBar("Por favor, dê uma avaliação (1 a 5 estrelas) para o jogador.");
       return;
    }

    // Se passou por todas as validações, pode salvar.
    if (_editPlayer?.id != null) {
      await _helper.updatePlayer(_editPlayer!);
    } else {
      await _helper.savePlayer(_editPlayer!);
    }
    Navigator.pop(context, _editPlayer);
  }
}