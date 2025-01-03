import 'package:flutter/material.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Historico'),
      ),
    );
  }
}