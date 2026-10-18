
import 'package:flutter/material.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart'; 
  
import 'portao.dart'; 
import 'tema/app_tema.dart'; 
  
// Troque pelos dados do SEU projeto Supabase 
// (Project Settings > API Keys), como nas Aulas 07 e 09. 
const supabaseUrl = 'https://jrzaukgayydhaazshfla.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpyemF1a2dheXlkaGFhenNoZmxhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk3NzcwODMsImV4cCI6MjEwNTM1MzA4M30.k4OwQ0g6Ct9k4dr2kXbgEeIVoYWlyikZ_YSJ3qPtr8U'; 
  
Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await Supabase.initialize( 
    url: supabaseUrl, 
    anonKey: supabaseAnonKey, 
  ); 
  runApp(const MainApp()); 
} 
  
class MainApp extends StatelessWidget { 
  const MainApp({super.key}); 
  
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      debugShowCheckedModeBanner: false, 
      title: 'Registro de Ocorrência', 
      theme: AppTema.claro, // <- o arquivo de estilizações 
      home: const Portao(), 
    ); 
  } 
}