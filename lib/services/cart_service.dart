import '../models/menu_item.dart';
import '../models/vendor.dart';

class CartService {
  // key = item name, value = quantity
  static final Map<String, int> _items = {};

  // key = item name, value = MenuItem object
  static final Map<String, MenuItem> _itemDetails = {};

  static void add(MenuItem item) {
    final key = item.name;

    _items[key] = (_items[key] ?? 0) + 1;
    _itemDetails[key] = item;
  }

  static void remove(MenuItem item) {
    final key = item.name;

    if (!_items.containsKey(key)) return;

    if (_items[key]! <= 1) {
      _items.remove(key);
      _itemDetails.remove(key);
    } else {
      _items[key] = _items[key]! - 1;
    }
  }

  static int getQty(MenuItem item) {
    return _items[item.name] ?? 0;
  }

  static int get totalItems {
    return _items.values.fold(0, (a, b) => a + b);
  }

  static double get totalPrice {
    double sum = 0;
    _items.forEach((key, qty) {
      sum += _itemDetails[key]!.price * qty;
    });
    return sum;
  }

  static List<MapEntry<MenuItem, int>> get items {
    return _items.entries.map((e) {
      return MapEntry(_itemDetails[e.key]!, e.value);
    }).toList();
  }
  // 🧮 SUBTOTAL (from items)
  static int get subtotal {
    int total = 0;
    _items.forEach((key, qty) {
      final item = _itemDetails[key]!;
      total += item.price * qty; // ✅ price is int
    });
    return total;
  }


// 🧾 FIXED CHARGES
  static int get platformFee => 10;
  static int get deliveryFee => 20;

// 🧾 GST = 5%
  static int get gst => (subtotal * 0.05).round();

// 💰 FINAL TOTAL
  static int get grandTotal => subtotal + platformFee + deliveryFee + gst;
  static void clear() {
    _items.clear();
    _itemDetails.clear();
  }





}
