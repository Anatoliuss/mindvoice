import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AiGeneratedAdvice extends StatelessWidget {
  const AiGeneratedAdvice({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // TODO: Replace with real general advice if available
    const String generalAdvice = 'Take a moment to breathe deeply and focus on something positive today.';
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Generated Advice'),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppTheme.lightTheme.colorScheme.onSurface, size: 24),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'General Advice',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                generalAdvice,
                style: AppTheme.lightTheme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                'Date: ${today.day}/${today.month}/${today.year}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
