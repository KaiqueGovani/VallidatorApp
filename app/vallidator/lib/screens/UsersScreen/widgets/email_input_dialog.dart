import 'package:flutter/material.dart';
import 'package:vallidator/themes/main_colors.dart';

class EmailInputDialog extends StatefulWidget {
  const EmailInputDialog({super.key});

  @override
  State<EmailInputDialog> createState() => _EmailInputDialogState();
}

class _EmailInputDialogState extends State<EmailInputDialog> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Text(
          'Add a new user',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Type the user email to send an invitation.'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null; // Return null if the entered email is valid
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, [false]);
            },
            child: const Text("CANCEL",
                style: TextStyle(color: MainColors.dangerRed)),
          ),
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, [true, _emailController.text]);
                }
              },
              child: const Text(
                'SEND',
                style: TextStyle(
                    color: MainColors.tertiary, fontWeight: FontWeight.bold),
              )),
        ]);
  }
}
