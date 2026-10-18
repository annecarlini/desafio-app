import 'package:flutter/material.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart'; 
  
import '../tema/app_tema.dart'; 
  
class LoginScreen extends StatefulWidget { 
  const LoginScreen({super.key}); 
  
  @override 
  State<LoginScreen> createState() => _LoginScreenState(); 
} 
  
class _LoginScreenState extends State<LoginScreen> { 
  final _email = TextEditingController(); 
  final _senha = TextEditingController(); 
  bool _carregando = false; 
  
  @override 
  void dispose() { 
    _email.dispose(); 
    _senha.dispose(); 
    super.dispose(); 
  } 
  
  void _mostrarMensagem(String texto) { 
    if (!mounted) return; 
    ScaffoldMessenger.of(context).showSnackBar( 
      SnackBar(content: Text(texto)), 
    ); 
  } 
  
  // ---------------- ENTRAR ---------------- 
  Future<void> _entrar() async { 
    setState(() => _carregando = true); 
    try { 
      await Supabase.instance.client.auth.signInWithPassword( 
        email: _email.text.trim(), 
        password: _senha.text, 
      ); 
      // Deu certo? O Portão troca de tela sozinho. 
    } on AuthException catch (erro) { 
      _mostrarMensagem(erro.message); 
    } catch (_) { 
      _mostrarMensagem('Sem conexão.'); 
    } finally { 
      if (mounted) setState(() => _carregando = false); 
    } 
  } 
  
  // ---------------- CRIAR CONTA ---------------- 
  Future<void> _cadastrar() async { 
    setState(() => _carregando = true); 
    try { 
      final resposta = await Supabase.instance.client.auth.signUp( 
        email: _email.text.trim(), 
        password: _senha.text, 
      ); 
      if (resposta.session == null) { 
        _mostrarMensagem('Conta criada. Confirme seu e-mail.'); 
      } 
    } on AuthException catch (erro) { 
      _mostrarMensagem(erro.message); 
    } catch (_) { 
      _mostrarMensagem('Sem conexão.'); 
    } finally { 
      if (mounted) setState(() => _carregando = false); 
    } 
  } 
  
  // ---------------- INTERFACE ---------------- 
  @override 
  Widget build(BuildContext context) { 
    final tema = Theme.of(context); 
  
    return Scaffold( 
      body: Center( 
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(24), 
          child: ConstrainedBox( 
            constraints: const BoxConstraints(maxWidth: 420), 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [ 
                Center( 
                  child: Container( 
                    width: 72, 
                    height: 72, 
                    decoration: BoxDecoration( 
                      color: AppCores.grafite, 
                      borderRadius: BorderRadius.circular(20), 
                    ), 
                    child: const Icon( 
                      Icons.engineering, 
                      color: AppCores.amarelo, 
                      size: 40, 
                    ), 
                  ), 
                ), 
                const SizedBox(height: 20), 
                Text( 
                  'Registro de Ocorrência', 
                  textAlign: TextAlign.center, 
                  style: tema.textTheme.headlineSmall, 
                ), 
                const SizedBox(height: 4), 
                Text( 
                  'Entre para registrar foto e localização', 
                  textAlign: TextAlign.center, 
                  style: tema.textTheme.bodySmall, 
                ), 
                const SizedBox(height: 28), 
                Card( 
                  child: Padding( 
                    padding: const EdgeInsets.all(20), 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.stretch, 
                      children: [ 
                        TextField( 
                          controller: _email, 
                          keyboardType: TextInputType.emailAddress, 
                          decoration: const InputDecoration( 
                            labelText: 'E-mail', 
                            prefixIcon: Icon(Icons.mail_outline), 
                             ), 
                        ), 
                        const SizedBox(height: 16), 
                        TextField( 
                          controller: _senha, 
                          obscureText: true, 
                          decoration: const InputDecoration( 
                            labelText: 'Senha', 
                            prefixIcon: Icon(Icons.lock_outline), 
                          ), 
                        ), 
                        const SizedBox(height: 24), 
                        FilledButton( 
                          onPressed: _carregando ? null : _entrar, 
                          child: Text( 
                            _carregando ? 'Aguarde...' : 'Entrar', 
                          ), 
                        ), 
                        const SizedBox(height: 8), 
                        TextButton( 
                          onPressed: _carregando ? null : _cadastrar, 
                          child: const Text('Criar conta'), 
                        ), 
                      ], 
                    ), 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
} 
