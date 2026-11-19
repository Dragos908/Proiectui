import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_service.dart';

/// Start page: shows only the "Pornește prezentarea" button.
class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  void initState() {
    super.initState();
    // Silent background setup (nothing is shown on screen): creates the
    // Firebase node with default values if it does not exist yet.
    FirebaseService().initializeNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: SizedBox(
          width: 420,
          child: ElevatedButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
              Navigator.pushReplacementNamed(context, '/presentation');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C5F2D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text(
              'Pornește prezentarea',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
