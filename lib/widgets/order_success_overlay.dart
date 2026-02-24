import 'package:flutter/material.dart';

class OrderSuccessOverlay extends StatefulWidget {
  const OrderSuccessOverlay({super.key});

  @override
  State<OrderSuccessOverlay> createState() => _OrderSuccessOverlayState();
}

class _OrderSuccessOverlayState extends State<OrderSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
          child: Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB300),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 80,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
