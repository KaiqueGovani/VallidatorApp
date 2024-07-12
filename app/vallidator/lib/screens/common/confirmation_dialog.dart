import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção!",
  String content = "Deseja realmente executar esta ação?",
  String affirmativeOption = "Confirmar",
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.white,
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    affirmativeOption.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold),
                  )),
            ]);
      });
}
