import 'package:flutter/material.dart';
import '../../app_theme.dart';

class DeleteAccountDialog extends StatefulWidget {
  final Function(String email, String password) onConfirm;

  const DeleteAccountDialog({super.key, required this.onConfirm});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.md),
      ),
      title: Text(
        "Delete your account",
        style: AppTheme.h3SemiboldOnMediumBlue,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "This action is permanent and cannot be undone.",
            style: AppTheme.h5SemiboldOnMediumBlue,
          ),
          const SizedBox(height: AppTheme.xl),
          _buildField("Email", Icons.email, _emailController, false),
          const SizedBox(height: AppTheme.xl),
          _buildField("Password", Icons.lock, _passwordController, true),
          if (errorMessage != null) ...[
            const SizedBox(height: AppTheme.sm),
            Text(errorMessage!, style: AppTheme.h6SemiboldPrimaryRed),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.sm),
            ),
          ),
          onPressed: isLoading ? null : handleDelete,
          child: isLoading
              ? const SizedBox(
                  height: AppTheme.md,
                  width: AppTheme.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text("Delete account", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
      ],
    );
  }

  void handleDelete() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await widget.onConfirm(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildField(
    String hint,
    IconData icon,
    TextEditingController controller,
    bool obscure,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: AppTheme.h5SemiboldOnMediumBlue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTheme.h4SemiboldOnMediumBlue,
        prefixIcon: Icon(icon, color: AppTheme.lightBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.md),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.md),
          borderSide: const BorderSide(color: AppTheme.mediumBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.lightBlue),
          borderRadius: BorderRadius.circular(AppTheme.md),
        ),
      ),
    );
  }
}
