import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AssignmentApp());
}

class AssignmentApp extends StatelessWidget {
  const AssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2D6A4F);
    return MaterialApp(
      title: 'Flutter Assignment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        textTheme: GoogleFonts.manropeTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF7F5F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1B16),
          ),
          iconTheme: IconThemeData(color: Color(0xFF1F1B16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D6A4F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final isOnboardingDone = await LocalStore.isOnboardingDone();
    final loggedInUser = await LocalStore.getLoggedInUser();

    if (!mounted) return;

    if (loggedInUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(email: loggedInUser)),
      );
      return;
    }

    if (!isOnboardingDone) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F3B2C), Color(0xFF6FB28D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.location_on, color: Colors.white, size: 64),
                SizedBox(height: 16),
                Text(
                  'Address Keeper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep your places handy, even after restarts',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finishOnboarding(BuildContext context) async {
    await LocalStore.setOnboardingDone();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EFE9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: Color(0xFF2D6A4F)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Private by design. Data stays on this device.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome!\nLet’s keep your addresses safe.',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Everything here stays on your device—onboarding, login,'
                ' and addresses—so nothing disappears after a restart.',
                style: TextStyle(color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 24),
              const _BulletLine(text: 'One‑time onboarding'),
              const _BulletLine(text: 'Secure local sign‑in'),
              const _BulletLine(text: 'Saved addresses per account'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _finishOnboarding(context),
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showSnack('Please enter email and password.');
      return;
    }
    setState(() => _busy = true);
    final ok = await LocalStore.validateLogin(email, password);
    setState(() => _busy = false);

    if (!ok) {
      _showSnack('That login doesn’t match any saved account.');
      return;
    }

    await LocalStore.setLoggedInUser(email);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(email: email)),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign in to continue managing your addresses.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _login,
                        child: Text(_busy ? 'Signing in...' : 'Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('No account yet? '),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill all fields.');
      return;
    }
    if (password != confirm) {
      _showSnack('Passwords don’t match.');
      return;
    }

    setState(() => _busy = true);
    final ok = await LocalStore.addUser(
      User(email: email, password: password, name: name),
    );
    setState(() => _busy = false);

    if (!ok) {
      _showSnack('That email is already registered.');
      return;
    }

    await LocalStore.setLoggedInUser(email);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen(email: email)),
      (route) => false,
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Create your account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your details stay on this device.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirm password'),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _signup,
                        child: Text(_busy ? 'Creating...' : 'Create account'),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.email});

  final String email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  List<Address> _addresses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    final addresses = await LocalStore.getAddresses(widget.email);
    if (!mounted) return;
    setState(() {
      _addresses = addresses;
      _loading = false;
    });
  }

  Future<void> _addAddress() async {
    final line1 = _line1Controller.text.trim();
    final line2 = _line2Controller.text.trim();
    if (line1.isEmpty || line2.isEmpty) {
      _showSnack('Please enter both address lines.');
      return;
    }
    final address = Address(line1: line1, line2: line2);
    await LocalStore.addAddress(widget.email, address);
    _line1Controller.clear();
    _line2Controller.clear();
    await _loadAddresses();
  }

  Future<void> _logout() async {
    await LocalStore.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Addresses'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE8EFE9),
                    child: Icon(Icons.person_outline, color: Color(0xFF2D6A4F)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Signed in',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          widget.email,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    TextField(
                      controller: _line1Controller,
                      decoration: const InputDecoration(labelText: 'Address line 1'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _line2Controller,
                      decoration: const InputDecoration(labelText: 'Address line 2'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addAddress,
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Saved addresses',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _addresses.isEmpty
                      ? const Center(child: Text('No addresses yet.'))
                      : ListView.separated(
                          itemCount: _addresses.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final address = _addresses[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFFE8EFE9),
                                  child: Icon(Icons.home_outlined, color: Color(0xFF2D6A4F)),
                                ),
                                title: Text(address.line1),
                                subtitle: Text(address.line2),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF2D6A4F)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class User {
  final String email;
  final String password;
  final String name;

  User({required this.email, required this.password, required this.name});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'] as String,
        password: json['password'] as String,
        name: json['name'] as String? ?? '',
      );
}

class Address {
  final String line1;
  final String line2;

  Address({required this.line1, required this.line2});

  Map<String, dynamic> toJson() => {
        'line1': line1,
        'line2': line2,
      };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        line1: json['line1'] as String? ?? '',
        line2: json['line2'] as String? ?? '',
      );
}

class LocalStore {
  static const _onboardingKey = 'onboarding_done';
  static const _usersKey = 'users';
  static const _loggedInKey = 'logged_in_user';
  static const _addressesKey = 'addresses_by_user';

  static Future<SharedPreferences> _prefs() {
    return SharedPreferences.getInstance();
  }

  static Future<bool> isOnboardingDone() async {
    final prefs = await _prefs();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingDone() async {
    final prefs = await _prefs();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await _prefs();
    return prefs.getString(_loggedInKey);
  }

  static Future<void> setLoggedInUser(String email) async {
    final prefs = await _prefs();
    await prefs.setString(_loggedInKey, email);
  }

  static Future<void> logout() async {
    final prefs = await _prefs();
    await prefs.remove(_loggedInKey);
  }

  static Future<List<User>> getUsers() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _saveUsers(List<User> users) async {
    final prefs = await _prefs();
    final encoded = jsonEncode(users.map((e) => e.toJson()).toList());
    await prefs.setString(_usersKey, encoded);
  }

  static Future<bool> addUser(User user) async {
    final users = await getUsers();
    final exists = users.any(
      (u) => u.email.toLowerCase() == user.email.toLowerCase(),
    );
    if (exists) return false;
    users.add(user);
    await _saveUsers(users);
    return true;
  }

  static Future<bool> validateLogin(String email, String password) async {
    final users = await getUsers();
    return users.any(
      (u) =>
          u.email.toLowerCase() == email.toLowerCase() &&
          u.password == password,
    );
  }

  static Future<List<Address>> getAddresses(String email) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_addressesKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded[email] as List<dynamic>? ?? [];
    return list
        .map((e) => Address.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addAddress(String email, Address address) async {
    final prefs = await _prefs();
    final raw = prefs.getString(_addressesKey);
    final decoded =
        raw == null || raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw);
    final list = (decoded[email] as List<dynamic>? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();
    list.add(address.toJson());
    decoded[email] = list;
    await prefs.setString(_addressesKey, jsonEncode(decoded));
  }
}
