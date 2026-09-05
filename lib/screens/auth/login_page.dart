import 'package:flutter/material.dart';

import '../../data/auth_repository.dart';
import '../../data/note_repository.dart';
import '../../theme/nest_theme.dart';
import '../../widgets/nest_marks.dart';
import '../setup/setup_flow.dart';
import '../shell/home_shell.dart';
import 'register_page.dart';

/// Sign in to an account stored on this device. Requirement 2.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? _error;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _busy = true;
    });

    final failure = await AuthRepository.instance.signIn(
      email: _email.text,
      password: _password.text,
    );

    if (!mounted) return;

    if (failure != null) {
      setState(() {
        _error = failure.message;
        _busy = false;
      });
      return;
    }

    await NoteRepository.instance.load();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => NoteRepository.instance.setupDone
            ? const HomeShell()
            : const SetupFlow(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WELCOME BACK', style: nestEyebrow),
                  const SizedBox(height: 10),
                  Highlighted(
                    child: Text('NoteNest', style: t.displaySmall),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign in to open your notebook.',
                    style: t.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  AuthField(
                    label: 'EMAIL',
                    hint: 'you@university.edu',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    label: 'PASSWORD',
                    hint: 'Your password',
                    controller: _password,
                    obscure: _obscure,
                    onToggleObscure: () =>
                        setState(() => _obscure = !_obscure),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    AuthErrorLine(message: _error!),
                  ],
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: Text(_busy ? 'Signing in...' : 'Sign in'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: TextButton(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterPage(),
                                ),
                              ),
                      child: const Text('New here? Create an account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared by both auth screens so the two look identical.
class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.helper,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: nestEyebrow),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textCapitalization: capitalization,
          style: const TextStyle(fontSize: 15, color: NestColor.ink),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: NestColor.paper,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 20,
                      color: NestColor.inkFaint,
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NestRadius.tile),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NestRadius.tile),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(NestRadius.tile),
              borderSide: const BorderSide(color: NestColor.pen, width: 2),
            ),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(helper!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}

class AuthErrorLine extends StatelessWidget {
  const AuthErrorLine({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: NestColor.o(NestColor.redPen, 0.08),
        borderRadius: BorderRadius.circular(NestRadius.tile),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 18, color: NestColor.redPen),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: NestColor.redPen),
            ),
          ),
        ],
      ),
    );
  }
}
