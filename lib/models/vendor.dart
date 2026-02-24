class MenuItem {
  final String name;
  final int price;
  final List<String> tags;


  MenuItem({
    required this.name,
    required this.price,
    required this.tags,
  });

  factory MenuItem.fromMap(Map<String, dynamic> data) {
    return MenuItem(
      name: data["name"] ?? "",
      price: (data["price"] ?? 0).toInt(),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}

class Vendor {
  final String id;
  final String name;
  final String image;
  final double rating;
  final double lat;
  final double lng;
  final List<MenuItem> menu;
  final double likesPercent;
  final bool isOpen;
  final String locationName;
  final List<String> popular;
  final String category;


  Vendor({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.lat,
    required this.lng,
    required this.menu,
    required this.likesPercent,
    required this.isOpen,
    required this.locationName,
    required this.popular,
    required this.category
  });

  factory Vendor.fromFirestore(String id, Map<String, dynamic> data) {
    final rawMenu = (data["menu"] as List?) ?? [];

    return Vendor(
      id: id,
      name: data["name"] ?? "",
      image: data["image"] ?? "",
      rating: (data["rating"] ?? 0).toDouble(),
      lat: (data["lat"] ?? 0).toDouble(),
      lng: (data["lng"] ?? 0).toDouble(),
      likesPercent: (data["likesPercent"] ?? 0).toDouble(),
      isOpen: data["isOpen"] == true,
      locationName: data["locationName"] ?? "Unknown",
      popular: List<String>.from(data["popular"] ?? []),
      menu: rawMenu.map((e) => MenuItem.fromMap(e)).toList(),
      category: data["category"] ?? "Other",
    );
  }
}
