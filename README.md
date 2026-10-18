# Registro de Ocorrência

App Flutter para registrar uma ocorrência com **foto** (câmera) e **localização** (GPS), com login e cadastro de usuários feitos pelo **Supabase**.

Este guia leva você do zero até o app rodando na sua máquina, mesmo que você ainda não tenha Flutter, Supabase ou nenhum plugin instalado.

---

## Sumário

1. [O que o app faz](#1-o-que-o-app-faz)
2. [Pré-requisitos](#2-pré-requisitos)
3. [Instalar o Flutter](#3-instalar-o-flutter)
4. [Preparar um dispositivo para rodar o app](#4-preparar-um-dispositivo-para-rodar-o-app)
5. [Baixar o projeto e instalar as dependências](#5-baixar-o-projeto-e-instalar-as-dependências)
6. [Criar e configurar o Supabase](#6-criar-e-configurar-o-supabase)
7. [Configurar as permissões de câmera e localização](#7-configurar-as-permissões-de-câmera-e-localização)
8. [Rodar o app](#8-rodar-o-app)
9. [Testando a experiência completa](#9-testando-a-experiência-completa)
10. [Problemas comuns](#10-problemas-comuns)
11. [Estrutura do projeto](#11-estrutura-do-projeto)

---

## 1. O que o app faz

| Tela | O que acontece |
| --- | --- |
| **Login** | Entrar com e-mail e senha ou criar uma conta nova (Supabase Auth). |
| **Registro** | Tirar uma foto com a câmera, capturar latitude/longitude/precisão do GPS e sair da conta. |

O arquivo [lib/portao.dart](lib/portao.dart) funciona como "porteiro": se existe uma sessão ativa, mostra a tela de registro; se não, mostra o login.

**Pacotes usados:**

| Pacote | Para quê |
| --- | --- |
| [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) | Login, cadastro e sessão do usuário |
| [`image_picker`](https://pub.dev/packages/image_picker) | Abrir a câmera e receber a foto |
| [`geolocator`](https://pub.dev/packages/geolocator) | Pedir permissão e ler a posição GPS |

---

## 2. Pré-requisitos

- Windows 10/11, macOS ou Linux
- [Git](https://git-scm.com/downloads)
- [Visual Studio Code](https://code.visualstudio.com/) (com as extensões **Flutter** e **Dart**) **ou** [Android Studio](https://developer.android.com/studio)
- Uma conta gratuita no [Supabase](https://supabase.com/)
- Um celular Android (com cabo USB) **ou** um emulador Android
  - Para iPhone/simulador iOS é preciso um Mac com Xcode.

> **Versão do Dart:** o [pubspec.yaml](pubspec.yaml) exige `sdk: ^3.12.2`. Use uma versão estável recente do Flutter que já traga o Dart 3.12.2 ou superior.

---

## 3. Instalar o Flutter

> Já tem o Flutter? Rode `flutter --version`. Se o Dart for 3.12.2 ou maior, pule para a [seção 4](#4-preparar-um-dispositivo-para-rodar-o-app). Se for menor, rode `flutter upgrade`.

### Opção A — pelo VS Code (mais fácil)

1. Instale o VS Code e a extensão **Flutter** (ela instala a extensão Dart junto).
2. Abra a paleta de comandos (`Ctrl+Shift+P`) e escolha **Flutter: New Project**.
3. O VS Code vai avisar que não encontrou o SDK e oferecer **Download SDK**. Escolha uma pasta **sem espaços e sem acentos** (ex.: `C:\dev\flutter`).
4. Aceite a opção de adicionar o Flutter ao `PATH`.

### Opção B — manual

1. Baixe o SDK em <https://docs.flutter.dev/get-started/install> e extraia em uma pasta sem espaços (ex.: `C:\dev\flutter`).
2. Adicione `C:\dev\flutter\bin` à variável de ambiente `Path`:
   *Iniciar → "Editar as variáveis de ambiente do sistema" → Variáveis de Ambiente → Path → Editar → Novo*.
3. Feche e abra o terminal de novo.

### Conferir a instalação

```bash
flutter --version
flutter doctor
```

O `flutter doctor` lista o que está faltando. Para este projeto, o importante é ficar **verde** nos itens:

- `Flutter`
- `Android toolchain` (para rodar no Android)
- `Chrome` (opcional, para rodar no navegador)

Se o `Android toolchain` reclamar das licenças, rode:

```bash
flutter doctor --android-licenses
```

e aceite tudo com `y`.

---

## 4. Preparar um dispositivo para rodar o app

O app usa **câmera e GPS**, então o ideal é rodar em um **celular Android** ou **emulador Android**.

### Opção A — Celular Android físico (recomendado)

1. No celular, vá em *Configurações → Sobre o telefone* e toque 7 vezes em **Número da versão** para liberar as **Opções do desenvolvedor**.
2. Em *Configurações → Sistema → Opções do desenvolvedor*, ative **Depuração USB**.
3. Conecte o celular no computador pelo cabo e aceite a mensagem "Permitir depuração USB?".
4. Confira se ele aparece:

   ```bash
   flutter devices
   ```

### Opção B — Emulador Android

1. Instale o [Android Studio](https://developer.android.com/studio) (ele traz o Android SDK).
2. Abra o Android Studio → **More Actions → Virtual Device Manager → Create Device**.
3. Escolha um aparelho (ex.: Pixel 7), uma imagem de sistema recente **com Google Play/Google APIs** e finalize.
4. Clique no ▶ para ligar o emulador.
5. Confira com `flutter devices`.

> **Dica:** a câmera do emulador mostra uma "cena virtual" e a localização é simulada. Veja como definir uma posição na [seção 9](#9-testando-a-experiência-completa).

### Opção C — Navegador Chrome (teste rápido)

Funciona para testar login e localização sem instalar Android. A câmera vira um seletor de arquivo na maioria dos navegadores de computador.

---

## 5. Baixar o projeto e instalar as dependências

```bash
git clone <URL-DO-REPOSITÓRIO>
cd registro_ocorrencia_anne_carlini
flutter pub get
```

O `flutter pub get` baixa tudo o que está no [pubspec.yaml](pubspec.yaml), incluindo `supabase_flutter`, `image_picker` e `geolocator`.

### Se os plugins não estiverem no pubspec.yaml

Caso você esteja montando o projeto do zero ou tenha apagado as dependências, adicione os plugins com:

```bash
flutter pub add supabase_flutter
flutter pub add image_picker
flutter pub add geolocator
```

Depois confira se aparecem em `dependencies:` no [pubspec.yaml](pubspec.yaml):

```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^14.1.1
  image_picker: ^1.2.4
  supabase_flutter: ^2.18.3
```

> Sempre que mexer no `pubspec.yaml`, rode `flutter pub get` de novo. Ao adicionar um plugin nativo (câmera, GPS), **pare o app e rode de novo** — o *hot reload* não carrega plugins novos.

---

## 6. Criar e configurar o Supabase

O app usa apenas a **autenticação** do Supabase (e-mail e senha). Não é preciso criar tabelas.

### 6.1 Criar a conta e o projeto

1. Acesse <https://supabase.com/> e clique em **Start your project**. Dá para entrar com o GitHub.
2. Clique em **New project**.
3. Preencha:
   - **Name:** `registro-ocorrencia` (ou outro nome)
   - **Database Password:** crie uma senha e guarde (não é usada pelo app, mas o Supabase exige)
   - **Region:** `South America (São Paulo)`
4. Clique em **Create new project** e espere 1 a 2 minutos até ele ficar pronto.

### 6.2 Pegar a URL e a chave pública

1. No painel do projeto, abra **Project Settings** (ícone de engrenagem).
2. Em **Data API** (ou **API**), copie a **Project URL**. Ela tem o formato:

   ```text
   https://xxxxxxxxxxxxxxxxxxxx.supabase.co
   ```

3. Em **API Keys**, copie a chave **pública**:
   - a **anon / public** (começa com `eyJ...`), **ou**
   - a **Publishable key** (começa com `sb_publishable_...`), nos projetos mais novos.

> ⚠️ **Nunca** use a chave `service_role` / `secret` no app. Ela dá acesso total ao banco e não pode ficar no celular do usuário.

### 6.3 Colocar as chaves no app

Abra [lib/main.dart](lib/main.dart) e troque os valores pelas chaves do **seu** projeto:

```dart
const supabaseUrl = 'https://SEU-PROJETO.supabase.co';
const supabaseAnonKey = 'SUA-CHAVE-PUBLICA';
```

### 6.4 Liberar o login por e-mail

1. No painel, vá em **Authentication → Sign In / Providers** (em versões antigas: **Authentication → Providers**).
2. Confirme que **Email** está **habilitado**.
3. **Para testar mais rápido (opcional):** desative **Confirm email**.
   - **Desativado:** ao tocar em *Criar conta*, o usuário já entra direto.
   - **Ativado:** o app mostra *"Conta criada. Confirme seu e-mail."*. Abra o e-mail, clique no link e depois volte ao app e toque em **Entrar**.

> O Supabase gratuito limita a quantidade de e-mails de confirmação por hora. Se os e-mails pararem de chegar, desative o *Confirm email* ou crie o usuário em **Authentication → Users → Add user** (marcando *Auto Confirm User*).

---

## 7. Configurar as permissões de câmera e localização

O `image_picker` e o `geolocator` precisam que o app **declare** as permissões. Sem isso, o botão *Obter localização* mostra erro ou o app fecha ao abrir a câmera.

### 7.1 Android

Abra [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml) e adicione as linhas abaixo **logo depois** de `<manifest ...>` e **antes** de `<application`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Supabase: acesso à internet -->
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- geolocator: localização -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <application
        ...
```

> O `image_picker` usa o app de câmera do próprio sistema, então **não** precisa da permissão `CAMERA` no Android.
>
> A permissão `INTERNET` já vem ligada em modo *debug*, mas sem ela o login **falha no APK de release**. Por isso vale deixar declarada.

### 7.2 iOS (só se for rodar em iPhone, precisa de Mac)

Abra [ios/Runner/Info.plist](ios/Runner/Info.plist) e adicione dentro do `<dict>` principal:

```xml
<key>NSCameraUsageDescription</key>
<string>O app usa a câmera para registrar a foto da ocorrência.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>O app pode acessar suas fotos para registrar a ocorrência.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>O app usa sua localização para registrar onde a ocorrência aconteceu.</string>
```

Depois rode:

```bash
cd ios
pod install
cd ..
```

### 7.3 Web

Não precisa configurar nada. O navegador pede a permissão de localização sozinho. Ela só funciona em `localhost` ou em sites `https`.

---

## 8. Rodar o app

1. Ligue o emulador ou conecte o celular.
2. Veja os dispositivos disponíveis:

   ```bash
   flutter devices
   ```

3. Rode:

   ```bash
   flutter run
   ```

   Se houver mais de um dispositivo, escolha pelo ID:

   ```bash
   flutter run -d <id-do-dispositivo>   # ex.: emulator-5554
   flutter run -d chrome                # no navegador
   ```

**Pelo VS Code:** escolha o dispositivo no canto inferior direito da barra de status e aperte `F5`.

A primeira execução no Android demora alguns minutos (o Gradle baixa muita coisa). As próximas são bem mais rápidas.

**Atalhos no terminal enquanto o app roda:**

| Tecla | Ação |
| --- | --- |
| `r` | Hot reload (aplica mudanças de código na hora) |
| `R` | Hot restart (reinicia o app) |
| `q` | Encerrar |

---

## 9. Testando a experiência completa

1. **Criar conta:** digite um e-mail e uma senha (mínimo de **6 caracteres**) e toque em **Criar conta**.
   - Se aparecer *"Conta criada. Confirme seu e-mail."*, confirme pelo link do e-mail e depois toque em **Entrar**.
2. **Entrar:** o app troca sozinho para a tela **Registro de Ocorrência** e mostra *"Logado como: seu@email"*.
3. **Tirar foto:** toque em **Tirar foto**, fotografe e confirme. A imagem aparece no cartão *1. Registro fotográfico*.
4. **Obter localização:** toque em **Obter localização** e aceite a permissão. Aparecem latitude, longitude e precisão em metros.
5. **Sair:** toque no ícone de sair (↪) na barra superior. O app volta para o login.
6. **Sessão salva:** feche e abra o app sem sair da conta. Ele abre direto na tela de registro.

Para conferir se o usuário foi criado, veja **Authentication → Users** no painel do Supabase.

### No emulador Android

- **Localização:** no emulador, clique em **⋯ (Extended controls) → Location**, escolha um ponto no mapa e clique em **Set location**. Depois toque em *Obter localização* no app.
- **Câmera:** a câmera traseira abre uma cena 3D virtual. Segure `Alt` e use `W A S D` e o mouse para se mover nela, depois tire a foto.

---

## 10. Problemas comuns

| Problema | Solução |
| --- | --- |
| `flutter` não é reconhecido como comando | O Flutter não está no `PATH`. Refaça a [seção 3](#3-instalar-o-flutter) e **reabra** o terminal. |
| `The current Dart SDK version is X... requires ^3.12.2` | Seu Flutter está desatualizado. Rode `flutter upgrade`. |
| `No supported devices connected` | Ligue o emulador ou ative a depuração USB e rode `flutter devices`. |
| `MissingPluginException` | Plugin novo e o app ainda rodando com a versão antiga. Pare (`q`) e rode `flutter run` de novo. Se não resolver: `flutter clean` e depois `flutter pub get`. |
| *"Permissão de localização negada."* | Você negou a permissão. Vá em *Configurações do celular → Apps → registro_ocorrencia_anne_carlini → Permissões → Localização* e permita. Também confira o [passo 7.1](#71-android). |
| *"Serviço de localização desligado."* | Ative o GPS/Localização no celular ou emulador. |
| *"Não foi possível obter a localização."* | O GPS não respondeu em 15 segundos. No emulador, defina uma posição (veja a [seção 9](#no-emulador-android)); no celular, vá para um lugar mais aberto e tente de novo. |
| *"Invalid login credentials"* | E-mail ou senha errados, ou a conta ainda não foi confirmada por e-mail. |
| *"Email not confirmed"* | Clique no link do e-mail ou desative *Confirm email* ([passo 6.4](#64-liberar-o-login-por-e-mail)). |
| *"Sem conexão."* | Sem internet, ou URL/chave do Supabase erradas no [lib/main.dart](lib/main.dart). |
| *"Password should be at least 6 characters"* | Use uma senha com 6 caracteres ou mais. |
| O projeto Supabase parou de responder | Projetos gratuitos são **pausados** depois de um tempo sem uso. Entre no painel e clique em **Restore project**. |
| Build do Android travado no Gradle | Na primeira vez é normal demorar. Se falhar, rode `flutter clean`, depois `flutter pub get` e `flutter run`. |
| Câmera não funciona no Windows (`flutter run -d windows`) | O `image_picker` não abre a câmera no Windows desktop. Use Android ou Chrome. |

---

## 11. Estrutura do projeto

```text
lib/
├── main.dart                 # Inicializa o Supabase e abre o app (URL e chave ficam aqui)
├── portao.dart               # Decide entre Login e Registro conforme a sessão
├── telas/
│   ├── login_screen.dart     # Entrar / Criar conta
│   └── registro_screen.dart  # Foto (image_picker) + GPS (geolocator) + Sair
└── tema/
    └── app_tema.dart         # Cores e estilos do app
```

---

**Autora:** Anne Carlini
