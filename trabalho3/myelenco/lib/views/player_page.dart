import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/player_model.dart';
import '../services/firestore_service.dart';

class PlayerPage extends StatefulWidget {
  final Player? player;
  const PlayerPage({super.key, this.player});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _clubController = TextEditingController();
  final _shirtController = TextEditingController();
  final _valueController = TextEditingController();

  final _marketValueMask = MaskTextInputFormatter(
    mask: '€ #.###.###.###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String? _position;
  String? _nationality;
  String? _dominantFoot;
  String? _imagePath;
  double _rating = 0.0;

  final List<String> _positions = [
    'Goleiro',
    'Defensor',
    'Meio-campista',
    'Atacante',
  ];
  final List<String> _nationalities = [
    'Brasileiro',
    'Argentino',
    'Português',
    'Francês',
    'Alemão',
    'Inglês',
  ];
  final List<String> _feet = ['Direito', 'Esquerdo', 'Ambidestro'];

  @override
  void initState() {
    super.initState();
    if (widget.player != null) {
      _nameController.text = widget.player!.name;
      _ageController.text = widget.player!.age.toString();
      _clubController.text = widget.player!.club;
      _shirtController.text = widget.player!.shirtNumber.toString();
      _valueController.text = widget.player!.marketValue;

      _position = widget.player!.position;
      _nationality = widget.player!.nationality;
      _dominantFoot = widget.player!.dominantFoot;
      _imagePath = widget.player!.img;
      _rating = widget.player!.rating;
    }
  }

  void _savePlayer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_position == null || _nationality == null || _dominantFoot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos de seleção."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final playerToSave = Player(
      id: widget.player?.id,
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      club: _clubController.text,
      shirtNumber: int.tryParse(_shirtController.text) ?? 0,
      marketValue: _valueController.text,
      position: _position!,
      nationality: _nationality!,
      dominantFoot: _dominantFoot!,
      rating: _rating,
      img: _imagePath,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? error = await _firestoreService.validatePlayer(playerToSave);

      if (error != null) {
        if (mounted) Navigator.pop(context);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
          );
        }
        return;
      }

      if (widget.player == null) {
        await _firestoreService.addPlayer(playerToSave);
      } else {
        await _firestoreService.updatePlayer(playerToSave);
      }

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro técnico: $e")));
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _imagePath = image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player == null ? "Novo Jogador" : "Editar Jogador"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: ClipOval(
                      child: _imagePath != null
                          ? Image.file(
                              File(_imagePath!),
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            )
                          : Image.asset(
                              "assets/imgs/player_placeholder.png",
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Avaliação do Jogador",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 30,
                    ),
                    onPressed: () => setState(() => _rating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 10),

              _buildTextField(_nameController, "Nome"),
              _buildTextField(_ageController, "Idade", isNumber: true),
              _buildTextField(
                _shirtController,
                "Número da Camisa",
                isNumber: true,
              ),
              _buildTextField(_clubController, "Clube Atual"),

              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  controller: _valueController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_marketValueMask],
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Valor de Mercado",
                  ),
                  validator: (v) => v!.isEmpty ? "Campo Obrigatório" : null,
                ),
              ),

              _buildDropdown(
                "Posição",
                _positions,
                _position,
                (v) => setState(() => _position = v),
              ),
              _buildDropdown(
                "Nacionalidade",
                _nationalities,
                _nationality,
                (v) => setState(() => _nationality = v),
              ),
              _buildDropdown(
                "Pé Dominante",
                _feet,
                _dominantFoot,
                (v) => setState(() => _dominantFoot = v),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _savePlayer,
                  icon: const Icon(Icons.save),
                  label: const Text("SALVAR JOGADOR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label),
        validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selected,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: selected,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        dropdownColor: Colors.grey[800],
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
