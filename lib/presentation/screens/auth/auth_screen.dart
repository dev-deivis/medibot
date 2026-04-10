import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showPasswordResetDialog() {
    final resetEmailController = TextEditingController(text: _emailController.text.trim());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Recuperar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.',
              style: TextStyle(color: AppTheme.textSlate500, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'ejemplo@correo.com',
                hintStyle: const TextStyle(color: AppTheme.textSlate400),
                filled: true,
                fillColor: AppTheme.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppTheme.textSlate500)),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = resetEmailController.text.trim();
              if (email.isEmpty) return;
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(authRepositoryProvider).resetPassword(email);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Revisa tu correo para restablecer tu contraseña')),
                  );
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No encontramos una cuenta con ese correo')),
                  );
                }
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    if (_tabController.index == 0) {
      // Login
      await ref.read(authNotifierProvider.notifier).signIn(email, password);
    } else {
      // Register
      await ref.read(authNotifierProvider.notifier).signUp(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Escuchar si el usuario se loguea para cerrar esta pantalla
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && mounted) {
          // Si hay usuario, volvemos a la raíz para ver el HomeScreen
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    });

    // Escuchar errores
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error.toString()}')),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          size: 40,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'MediBot',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSlate900,
                        ),
                      ),
                      const Text(
                        'Tu asistente de salud inteligente',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSlate500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  labelColor: AppTheme.textSlate900,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelColor: AppTheme.textSlate400,
                  tabs: const [
                    Tab(text: 'Iniciar sesión'),
                    Tab(text: 'Registrarse'),
                  ],
                ),

                const SizedBox(height: 32),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Correo electrónico',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSlate900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'ejemplo@correo.com',
                        hintStyle: const TextStyle(color: AppTheme.textSlate400),
                        filled: true,
                        fillColor: AppTheme.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSlate900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: AppTheme.textSlate400),
                        filled: true,
                        fillColor: AppTheme.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppTheme.textSlate400,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_tabController.index == 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showPasswordResetDialog,
                          child: const Text(
                            '¿Olvidé mi contraseña?',
                            style: TextStyle(
                              color: AppTheme.textSlate500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    
                    // Botón principal con Loading
                    ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleAuth,
                      style: ElevatedButton.styleFrom(
                        shadowColor: AppTheme.primary.withOpacity(0.3),
                        elevation: 8,
                      ),
                      child: authState.isLoading 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : Text(_tabController.index == 0 ? 'Ingresar' : 'Crear cuenta'),
                    ),
                    
                    const SizedBox(height: 32),

                    const Row(
                      children: [
                        Expanded(child: Divider(color: AppTheme.backgroundLight, thickness: 2)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'O CONTINUAR CON',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSlate400,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppTheme.backgroundLight, thickness: 2)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Google Login
                    OutlinedButton(
                      onPressed: authState.isLoading 
                        ? null 
                        : () => ref.read(authNotifierProvider.notifier).signInWithGoogle(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(color: AppTheme.backgroundLight, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                            height: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Google',
                            style: TextStyle(
                              color: AppTheme.textSlate900,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(color: AppTheme.textSlate400, fontSize: 12, height: 1.5),
                          children: [
                            TextSpan(text: 'Al continuar, aceptas nuestros\n'),
                            TextSpan(
                              text: 'Términos de Servicio',
                              style: TextStyle(decoration: TextDecoration.underline, color: AppTheme.textSlate500),
                            ),
                            TextSpan(text: ' y '),
                            TextSpan(
                              text: 'Privacidad',
                              style: TextStyle(decoration: TextDecoration.underline, color: AppTheme.textSlate500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
