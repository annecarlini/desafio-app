import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // NOVO 

import '../tema/app_tema.dart'; // NOVO

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() =>
      _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Objeto do plugin que acessa câmera e galeria.
  final ImagePicker _picker = ImagePicker();

  // Estado da tela: tudo começa vazio (null).
  Uint8List? _fotoBytes; // bytes da foto
  Position? _posicao; // última posição lida
  String? _mensagem; // aviso de erro
  bool _buscandoLocal = false; // esperando o GPS?

  // ---------------- CÂMERA ----------------
  Future<void> _tirarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
    );

    // null = usuário fechou sem tirar foto.
    if (foto == null) return;

    final Uint8List bytes = await foto.readAsBytes();

    setState(() {
      _fotoBytes = bytes;
    });
  }

  // ------------- LOCALIZAÇÃO -------------
  Future<void> _obterLocalizacao() async {
    setState(() {
      _buscandoLocal = true;
      _mensagem = null;
    });

    try {
      // 1. O serviço de localização está ligado?
      final bool servicoAtivo =
          await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        _mostrarMensagem('Serviço de localização desligado.');
        return;
      }

      // 2. Já temos permissão? Se não, pedimos.
      LocationPermission permissao =
          await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      // 3. O usuário negou?
      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        _mostrarMensagem('Permissão de localização negada.');
        return;
      }

      // 4. Tudo certo: lemos a posição atual.
      final Position posicao =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      setState(() {
        _posicao = posicao;
      });
    } catch (_) {
      _mostrarMensagem(
          'Não foi possível obter a localização.');
    } finally {
      setState(() {
        _buscandoLocal = false;
      });
    }
  }


  // ---------------- SAIR (NOVO) ---------------- 
  Future<void> _sair() async { 
    // Apaga a sessão. O Portão volta para o login sozinho. 
    await Supabase.instance.client.auth.signOut(); 
  } 

  // ---------------- AUXILIARES ----------------
  void _mostrarMensagem(String texto) {
    setState(() {
      _mensagem = texto;
    });
  }

  String _textoLocalizacao() {
    if (_posicao == null) {
      return 'Localização ainda não capturada.';
    }
    final p = _posicao!;
    return 'Latitude: ${p.latitude.toStringAsFixed(6)}\n'
        'Longitude: ${p.longitude.toStringAsFixed(6)}\n'
        'Precisão: ${p.accuracy.toStringAsFixed(0)} m';
  }

  Widget _quadroFoto() {
    if (_fotoBytes == null) {
      return const Center(
        child: Text('Nenhuma foto registrada'),
      );
    }
    return Image.memory(_fotoBytes!, fit: BoxFit.cover);
  }


 // ---------------- INTERFACE (NOVO VISUAL) ---------------- 
  @override 
  Widget build(BuildContext context) { 
    final tema = Theme.of(context); 
    final String email = 
        Supabase.instance.client.auth.currentUser?.email ?? ''; 
    final String rotuloLocal = 
        _buscandoLocal ? 'Buscando...' : 'Obter localização'; 
  
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Registro de Ocorrência'), 
        actions: [ 
          IconButton( 
            tooltip: 'Sair', 
            onPressed: _sair, 
            icon: const Icon(Icons.logout), 
          ), 
        ], 
      ), 
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [ 
            Text('Logado como: $email', style: tema.textTheme.bodySmall), 
            const SizedBox(height: 12), 
  
            // ---------- Cartão 1: foto ---------- 
            Card( 
              child: Padding( 
                padding: const EdgeInsets.all(16), 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.stretch, 
                  children: [ 
                    Text( 
                      '1. Registro fotográfico', 
                      style: tema.textTheme.titleMedium, 
                    ), 
                    const SizedBox(height: 12), 
                    Container( 
                      height: 220, 
                      clipBehavior: Clip.antiAlias, 
                      decoration: BoxDecoration( 
                        color: AppCores.fundo, 
                        borderRadius: BorderRadius.circular(12), 
                      ), 
                      child: _quadroFoto(), 
                    ), 
                    const SizedBox(height: 12), 
                    FilledButton.icon( 
                      onPressed: _tirarFoto, 
                      icon: const Icon(Icons.photo_camera), 
                      label: const Text('Tirar foto'), 
 ), 
                  ], 
                ), 
              ), 
            ), 
            const SizedBox(height: 16), 
  
            // ---------- Cartão 2: localização ---------- 
            Card( 
              child: Padding( 
                padding: const EdgeInsets.all(16), 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.stretch, 
                  children: [ 
                    Text( 
                      '2. Localização', 
                      style: tema.textTheme.titleMedium, 
                    ), 
                    const SizedBox(height: 12), 
                    Text( 
                      _textoLocalizacao(), 
                      style: tema.textTheme.bodyMedium, 
                    ), 
                    const SizedBox(height: 12), 
                    FilledButton.icon( 
                      onPressed: 
                          _buscandoLocal ? null : _obterLocalizacao, 
                      icon: const Icon(Icons.my_location), 
                      label: Text(rotuloLocal), 
                    ), 
                    if (_mensagem != null) 
                      Padding( 
                        padding: const EdgeInsets.only(top: 12), 
                        child: Text( 
                          _mensagem!, 
                          style: TextStyle(color: tema.colorScheme.error), 
                        ), 
                      ), 
                  ], 
                ), 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 