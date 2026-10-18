import 'package:flutter/material.dart';

// =====================================================================
// ARQUIVO DE ESTILIZAÇÕES DO APP
// Tudo o que é cor, fonte, borda e formato de botão fica AQUI.
// As telas só usam Theme.of(context) ou AppCores: se quiser mudar o
// visual do app inteiro, você muda só este arquivo.
// =====================================================================

// Paleta "segurança industrial": grafite + amarelo de sinalização.
class AppCores {
  static const Color grafite = Color(0xFF1E2530);
  static const Color grafiteClaro = Color(0xFF2E3846);
  static const Color amarelo = Color(0xFFFFB300);
  static const Color fundo = Color(0xFFF2F3F5);
  static const Color superficie = Colors.white;
  static const Color borda = Color(0xFFDDE1E6);
  static const Color texto = Color(0xFF1E2530);
  static const Color textoSuave = Color(0xFF5F6B7A);
  static const Color erro = Color(0xFFD32F2F);
}

class AppTema {
  static ThemeData get claro {
    const esquema = ColorScheme(
      brightness: Brightness.light,
      primary: AppCores.grafite,
      onPrimary: Colors.white,
      secondary: AppCores.amarelo,
      onSecondary: AppCores.grafite,
      error: AppCores.erro,
      onError: Colors.white,
      surface: AppCores.superficie,
      onSurface: AppCores.texto,
    );

    final bordaCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppCores.borda),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: AppCores.fundo,

      // Barra superior escura, título à esquerda.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppCores.grafite,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),

      // Cartões brancos, cantos arredondados e borda fina.
      cardTheme: CardThemeData(
        color: AppCores.superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppCores.borda),
        ),
      ),

      // Botão principal: amarelo de sinalização, largura total.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppCores.amarelo,
          foregroundColor: AppCores.grafite,
          disabledBackgroundColor: AppCores.borda,
          disabledForegroundColor: AppCores.textoSuave,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Botão de texto (ex.: "Criar conta").
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppCores.grafite,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Campos de texto brancos com borda arredondada.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppCores.superficie,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: bordaCampo,
        enabledBorder: bordaCampo,
        focusedBorder: bordaCampo.copyWith(
          borderSide: const BorderSide(color: AppCores.amarelo, width: 2),
        ),
      ),

      // Tipografia usada pelas telas.
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppCores.texto,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppCores.texto,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: AppCores.texto,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          color: AppCores.textoSuave,
        ),
      ),

      // Avisos que aparecem embaixo da tela.
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppCores.grafiteClaro,
      ),
    );
  }
}
