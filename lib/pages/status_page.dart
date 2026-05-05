import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/firebase_service.dart';
import '../models/prezentare_state.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final _fb = FirebaseService();
  PrezentareState _state = const PrezentareState();
  bool _firebaseConnected = false;

  StreamSubscription<PrezentareState>? _stateSub;
  StreamSubscription<bool>? _connSub;

  @override
  void initState() {
    super.initState();
    _fb.initializeNode();
    _stateSub = _fb.stateStream.listen((s) {
      if (mounted) setState(() => _state = s);
    });
    _connSub = _fb.connectionStream.listen((connected) {
      if (mounted) setState(() => _firebaseConnected = connected);
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _connSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Proiect Ecologic',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Panou de control',
                style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 15),
              ),

              const SizedBox(height: 48),

              // Status row
              Row(
                children: [
                  _dot(_firebaseConnected),
                  const SizedBox(width: 10),
                  Text(
                    _firebaseConnected ? 'Firebase conectat' : 'Firebase deconectat',
                    style: TextStyle(
                      color: _firebaseConnected ? Colors.white : Colors.white38,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  _dot(_state.actiune.isNotEmpty),
                  const SizedBox(width: 10),
                  Text(
                    _state.actiune.isNotEmpty ? 'Android activ' : 'Android inactiv',
                    style: TextStyle(
                      color: _state.actiune.isNotEmpty ? Colors.white : Colors.white38,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                    Navigator.pushReplacementNamed(context, '/prezentare');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5F2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Prezentare',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    final color = active ? const Color(0xFF2ECC71) : const Color(0xFF444444);
    return Container(
      width: 8, height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: active
            ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6, spreadRadius: 1)]
            : null,
      ),
    );
  }
}