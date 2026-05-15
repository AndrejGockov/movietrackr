import 'package:flutter/material.dart';
import 'package:movietrackr/widgets/shared/loading_screen.dart';
import '../../app_theme.dart';

class UpdateBioDialog extends StatefulWidget {
  final String currentBio;
  final Function(String newBio) onConfirm;

  const UpdateBioDialog({
    super.key,
    required this.currentBio,
    required this.onConfirm,
  });

  @override
  State<UpdateBioDialog> createState() => _UpdateBioDialogState();
}

class _UpdateBioDialogState extends State<UpdateBioDialog> {
  late TextEditingController _bioController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkBlue,
      title: Text("Edit Bio", style: AppTheme.h3SemiboldOnMediumBlue),
      content: TextField(
        controller: _bioController,
        maxLines: 3,
        maxLength: 150,
        style: AppTheme.h5SemiboldOnMediumBlue,
        decoration: InputDecoration(
          hintText: "Tell us about yourself...",
          hintStyle: const TextStyle(color: Colors.white30),
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
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepBlue),
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox(width: AppTheme.md, height: AppTheme.md, child: LoadingScreen())
              : Text("Save", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
      ],
    );
  }

  void _submit() async {
    setState(() => isLoading = true);
    await widget.onConfirm(_bioController.text.trim());
    if (mounted) Navigator.pop(context);
  }
}