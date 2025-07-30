import 'package:flutter/material.dart';

class UpdatePointsDialog extends StatefulWidget {
  const UpdatePointsDialog({super.key});

  @override
  State<UpdatePointsDialog> createState() => _UpdatePointsDialogState();
}

class _UpdatePointsDialogState extends State<UpdatePointsDialog> {
  final TextEditingController _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Licitpont beállítása"),
      content: TextField(
        controller: _pointsController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Alap pontszám',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Mégse"),
        ),
        ElevatedButton(
          onPressed: () {
            final input = _pointsController.text;
            final points = int.tryParse(input);
            if (points != null) {
              print("Licitpont beállítva: $points");
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Érvénytelen szám.")),
              );
            }
          },
          child: const Text("Mentés"),
        ),
      ],
    );
  }
}
