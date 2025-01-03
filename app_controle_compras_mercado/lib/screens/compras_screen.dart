import 'package:flutter/material.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  _ComprasScreenState createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Compras'),
      ),
    );
  }
}