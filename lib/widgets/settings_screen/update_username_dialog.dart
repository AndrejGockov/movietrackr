import 'package:flutter/material.dart';
import '../../app_theme.dart';

class UpdateUsernameDialog extends StatefulWidget {
  final Function(String newName) onConfirm;
  final String currentName;

  const UpdateUsernameDialog({
    super.key,
    required this.onConfirm,
    required this.currentName,
  });

  @override
  State<UpdateUsernameDialog> createState() => _UpdateUsernameDialogState();
}

class _UpdateUsernameDialogState extends State<UpdateUsernameDialog> {
  late TextEditingController _nameController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  Widget build(BuildContext context) {
    // Keeps track if the names changed
    final String input = _nameController.text.trim();
    final bool canSave =
        input.isNotEmpty && input != widget.currentName && !isLoading;

    return AlertDialog(
      backgroundColor: AppTheme.darkBlue,
      title: Text("Update Username", style: AppTheme.h3SemiboldOnMediumBlue),
      content: TextField(
        controller: _nameController,
        style: AppTheme.h5SemiboldOnMediumBlue,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "Username",
          prefixIcon: Icon(Icons.person, color: AppTheme.lightBlue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.md),
            borderSide: const BorderSide(color: AppTheme.mediumBlue),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.deepBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.sm),
            ),
          ),
          onPressed: canSave ? _submit : null,
          child: isLoading
              ? const SizedBox(
                  height: AppTheme.md,
                  width: AppTheme.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text("Save", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
      ],
    );
  }

  void _submit() async {
    setState(() => isLoading = true);
    await widget.onConfirm(_nameController.text.trim());
    if (mounted) Navigator.pop(context);
  }
}
