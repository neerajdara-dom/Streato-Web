import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/streato_points_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = CartService.items;
    final isEmpty = items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Your Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isEmpty
            ? const Center(
          child: Text(
            "No items in cart 🛒",
            style: TextStyle(fontSize: 22),
          ),
        )
            : Row(
          children: [
            // ================= LEFT: ITEMS =================
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i].key;
                  final qty = items[i].value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text("₹${item.price} x $qty"),
                      trailing: Text("₹${item.price * qty}"),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 20),

            // ================= RIGHT: SUMMARY =================
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300), // 🟡 AMBER PANEL
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _priceRow("Subtotal", CartService.subtotal),
                    _priceRow("Platform Fee", CartService.platformFee),
                    _priceRow("Delivery Fee", CartService.deliveryFee),
                    _priceRow("GST (5%)", CartService.gst),
                    const Divider(),
                    _priceRow("TOTAL", CartService.grandTotal, bold: true),

                    const Spacer(),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () async {
                          await _placeOrder(context);
                        },
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 18 : 14,
            ),
          ),
          Text(
            "₹$value",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ORDER LOGIC =================

  Future<void> _placeOrder(BuildContext context) async {
    final total = CartService.grandTotal;

    // 🎁 5 points per ₹1
    final pointsToAdd = total * 5;
    StreatoPointsService.addPoints(pointsToAdd);

    // ✅ Show success tick (DO NOT await)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB300),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 80, color: Colors.black),
                ),
              );
            },
          ),
        );
      },
    );
    // ⏱ Wait 2 seconds
    await Future.delayed(const Duration(seconds: 1));

    // ❌ Close dialog
    Navigator.of(context, rootNavigator: true).pop();

    // 🧹 Clear cart
    CartService.clear();

    // ⬅️ Go back to Home
    Navigator.pop(context);
  }
}
