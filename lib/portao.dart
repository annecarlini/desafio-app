import 'package:flutter/material.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart'; 
  
import 'telas/login_screen.dart'; 
import 'telas/registro_screen.dart'; 
  
// O "porteiro" do app (Aula 09): decide qual tela mostrar. 
class Portao extends StatelessWidget { 
  const Portao({super.key}); 
  
  @override 
  Widget build(BuildContext context) { 
    final supabase = Supabase.instance.client; 
  
    return StreamBuilder<AuthState>( 
      // Emite um evento a cada login, logout ou renovação de sessão. 
      stream: supabase.auth.onAuthStateChange, 
      builder: (context, snapshot) { 
        final sessao = supabase.auth.currentSession; 
        if (sessao == null) { 
          return const LoginScreen(); 
        } 
        return const RegistroScreen(); 
      }, 
    );
     } 
}
