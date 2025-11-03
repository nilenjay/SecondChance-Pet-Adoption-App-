import 'package:flutter/material.dart';

class AdoptedScreen extends StatelessWidget {
  const AdoptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adopted Pets")),
      body: const Center(
        child: Text("Your adopted pets will appear here 🐾"),
      ),
    );
  }
}
