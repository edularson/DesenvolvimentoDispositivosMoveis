import 'package:flutter/material.dart';
import 'package:meuelenco/view/welcome_page.dart';

void main() {
  runApp(MaterialApp(
    home: const WelcomePage(), 
    
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900], 
      primaryColor: Colors.grey[850],
      
      // *** MUDANÇA AQUI ***
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.green, // Swatch principal
      ).copyWith(
        primary: Colors.greenAccent[400],    // Verde Neon para elementos interativos
        secondary: Colors.amber,          // Dourado para detalhes e estrelas
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white), 
      ),

      // *** MUDANÇA AQUI ***
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.greenAccent[400], // Verde
        foregroundColor: Colors.black87, // <-- Texto escuro para legibilidade
      ),
      
      cardTheme: CardThemeData( 
        color: Colors.grey[850], 
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),

      tabBarTheme: TabBarThemeData( 
        labelColor: Colors.amber, 
        unselectedLabelColor: Colors.white70, 
        indicator: UnderlineTabIndicator( 
          borderSide: BorderSide(color: Colors.amber, width: 3.0),
        ),
      ),

      // *** MUDANÇA AQUI ***
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder( // Borda de foco
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.greenAccent[400]!, width: 2.0), // Verde
        ),
        filled: true,
        fillColor: Colors.grey[800],
      ),

      // *** MUDANÇA AQUI ***
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent[400], // Verde
          foregroundColor: Colors.black87, // <-- Texto escuro para legibilidade
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle( 
            fontSize: 18, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}