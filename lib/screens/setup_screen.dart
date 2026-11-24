import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class SetupScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SetupScreen({super.key, required this.onComplete});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> with SingleTickerProviderStateMixin {
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController(text: ApiService.defaultBaseUrl);
  bool _isLoading = false;
  bool _showAdvanced = false;
  String? _error;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSave() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() => _error = 'Please enter your API key');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final baseUrl = _baseUrlController.text.trim();
    final isValid = await ApiService.validateApiKey(apiKey, baseUrl: baseUrl);

    if (isValid) {
      await ApiService.saveApiKey(apiKey);
      await ApiService.saveBaseUrl(baseUrl);
      widget.onComplete();
    } else {
      setState(() {
        _error = 'Invalid API key or unable to connect';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Animated gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.5, -0.5),
                  radius: 1.8,
                  colors: [
                    AppTheme.accentBlue.withOpacity(0.25),
                    AppTheme.background,
                    AppTheme.accentPurple.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    // Logo / Title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppTheme.accentGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentBlue.withOpacity(0.4),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.timer_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Hackstat',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your coding stats, beautifully',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // API Key input
                    Text(
                      'API KEY',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _error != null
                                  ? AppTheme.accentPink.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: TextField(
                            controller: _apiKeyController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Paste your Hackatime API key',
                              hintStyle: TextStyle(
                                color: AppTheme.textTertiary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: Icon(
                                Icons.key_rounded,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                            onChanged: (_) => setState(() => _error = null),
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: AppTheme.accentPink,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Advanced options toggle
                    GestureDetector(
                      onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                      child: Row(
                        children: [
                          Icon(
                            _showAdvanced
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Advanced options',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Advanced options
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: _showAdvanced
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'SERVER URL',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.cardColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: TextField(
                                controller: _baseUrlController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'https://hackatime.hackclub.com',
                                  hintStyle: TextStyle(
                                    color: AppTheme.textTertiary,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  prefixIcon: Icon(
                                    Icons.dns_outlined,
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 32),
                    // Connect button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CupertinoActivityIndicator(color: Colors.white)
                            : const Text(
                                'Connect',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Help text
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Find your API key at',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'hackatime.hackclub.com/settings',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accentBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
