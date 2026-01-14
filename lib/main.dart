import 'package:flutter/material.dart';
import 'dart:math';
class Stall {
  final String name;
  final double rating;

  Stall({required this.name, required this.rating});
}
class _StallImagesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Row(
        children: [
          // BIG IMAGE
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.unsplash.com/photo-1601050690597-df0568f70950",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // SMALL GRID
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (index == 3) {
                  return Stack(
                    children: [
                      _smallImage(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Center(
                          child: Text(
                            "+12",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return _smallImage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        "https://images.unsplash.com/photo-1601050690597-df0568f70950",
        fit: BoxFit.cover,
      ),
    );
  }
}

class FoodStallDetailsContent extends StatelessWidget {
  const FoodStallDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ TITLE + RATING
                  Row(
                    children: [
                      const Text(
                        "Spicy Corner",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "⭐ 4.2",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🖼️ IMAGE GRID
                  _StallImagesGrid(),

                  const SizedBox(height: 30),

                  // 📋 MENU SECTION
                  const Text(
                    "Menu",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 2,
                    width: 60,
                    margin: const EdgeInsets.only(top: 4, bottom: 16),
                    color: Colors.amber,
                  ),

                  // 🔍 SEARCH
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 8),
                        Text("Search in menu..."),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🍔 FOOD ITEMS
                  _FoodItem("Samosa", 20),
                  _FoodItem("Pav Bhaji", 60),
                  _FoodItem("Dosa", 50),
                  _FoodItem("Noodles", 70),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _FoodItem(String name, int price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Text(name, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text("₹$price", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
class AnimatedMeshBackground extends StatefulWidget {
  const AnimatedMeshBackground({super.key});

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}
class DoodleOverlay extends StatelessWidget {
  DoodleOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IgnorePointer(
      child: CustomPaint(
        painter: _DoodlePainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DoodlePainter extends CustomPainter {
  final bool isDark;
  final Random r = Random(65); // fixed seed = no movement

  _DoodlePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2   // 👈 THICKER
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 45; i++) {
      final x = r.nextDouble() * size.width;
      final y = r.nextDouble() * size.height;
      final s = r.nextDouble() * 0.03+0.01;

      switch (r.nextInt(6)) {
        case 0:
        // bowl
          canvas.drawArc(
            Rect.fromCenter(center: Offset(x, y), width: s, height: s),
            0,
            pi,
            false,
            paint,
          );
          break;

        case 1:
        // flame
          final path = Path()
            ..moveTo(x, y)
            ..quadraticBezierTo(x + s * 0.3, y - s, x, y - s * 1.2)
            ..quadraticBezierTo(x - s * 0.3, y - s, x, y);
          canvas.drawPath(path, paint);
          break;

        case 2:
        // spoon
          canvas.drawCircle(Offset(x, y), s * 0.18, paint);
          canvas.drawLine(
            Offset(x, y + s * 0.18),
            Offset(x, y + s),
            paint,
          );
          break;

        case 3:
        // pan
          canvas.drawCircle(Offset(x, y), s * 0.32, paint);
          canvas.drawLine(
            Offset(x + s * 0.32, y),
            Offset(x + s * 0.8, y),
            paint,
          );
          break;

        case 4:
        // star
          canvas.drawLine(Offset(x - s, y), Offset(x + s, y), paint);
          canvas.drawLine(Offset(x, y - s), Offset(x, y + s), paint);
          break;

        case 5:
        // squiggle
          final path = Path()
            ..moveTo(x - s, y)
            ..quadraticBezierTo(x, y - s, x + s, y)
            ..quadraticBezierTo(x + s * 1.5, y + s, x + s * 2, y);
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random random = Random();

  late List<_Blob> blobs;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    blobs = List.generate(15, (_) => _Blob.random(random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _MeshPainter(
            blobs: blobs,
            isDark: isDark,
          ),

          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _Blob {
  Offset pos;
  Offset velocity;
  double radius;

  _Blob(this.pos, this.velocity, this.radius);

  factory _Blob.random(Random r) {
    return _Blob(
      Offset(r.nextDouble(), r.nextDouble()),
      Offset(
        (r.nextDouble() - 0.5) * 0.0006,
        (r.nextDouble() - 0.5) * 0.0006,
      ),
      r.nextDouble() * 0.25 + 0.12,
    );
  }
}

class _MeshPainter extends CustomPainter {
  final List<_Blob> blobs;
  final bool isDark;

  _MeshPainter({
    required this.blobs,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.plus;

    for (final blob in blobs) {
      // 🌊 Move blob continuously
      blob.pos += blob.velocity;

      // 🔁 Soft wrap around screen
      if (blob.pos.dx < -0.2) blob.pos = Offset(1.2, blob.pos.dy);
      if (blob.pos.dx > 1.2) blob.pos = Offset(-0.2, blob.pos.dy);
      if (blob.pos.dy < -0.2) blob.pos = Offset(blob.pos.dx, 1.2);
      if (blob.pos.dy > 1.2) blob.pos = Offset(blob.pos.dx, -0.2);

      final center = Offset(
        blob.pos.dx * size.width,
        blob.pos.dy * size.height,
      );

      final radius = blob.radius * min(size.width, size.height);

      final gradient = RadialGradient(
        colors: isDark
            ? [
          const Color(0xFFFFB300).withOpacity(0.45),
          Colors.transparent,
        ]
            : [
          const Color(0xFFFFC107).withOpacity(0.65),
          Colors.transparent,
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class ThemeProvider extends InheritedNotifier<ThemeController> {
  const ThemeProvider({
    super.key,
    required ThemeController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static ThemeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!.notifier!;
  }
}

const LinearGradient streatoGradient = LinearGradient(
  colors: [
    Color(0xFFFF8F00), // Deep Orange
    Color(0xFFFFCA28), // Amber
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class ThemeController extends ChangeNotifier {
  bool isDark = false;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

void main() {
  final themeController = ThemeController();

  runApp(
    ThemeProvider(
      controller: themeController,
      child: StreatoApp(controller: themeController),
    ),
  );
}


class StreatoApp extends StatelessWidget {
  final ThemeController controller;

  const StreatoApp({super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          themeMode: controller.isDark ? ThemeMode.dark : ThemeMode.light,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF7F7F7),
            cardColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFFBF00),
              brightness: Brightness.light,
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1C1C1C), // 👈 YOUR REQUIRED COLOR
            cardColor: const Color(0xFF252525),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFFBF00),
              brightness: Brightness.dark,
            ),
          ),

          home: const SplashScreen(),
        );


      },
    );
  }

}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFBF00),
              Color(0xFFFFA000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.storefront,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              "STREATO",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Discover Street Food Stories",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome to Streato 👋",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Discover local street food like never before.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Create new account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class HoverSearchBar extends StatefulWidget {
  const HoverSearchBar({super.key});

  @override
  State<HoverSearchBar> createState() => _HoverSearchBarState();
}

class _HoverSearchBarState extends State<HoverSearchBar> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.amber.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text("Search street food, stalls.."),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // HERO
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8, // 80% width
              child: Container(
                height: 320,
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://plus.unsplash.com/premium_photo-1695297516142-398762d80f66?w=600&auto=format&fit=crop&q=60",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              "Discover By Mood",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),


          // FEATURE GRID
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, index) {
                  final items = [
                    {
                      "title": "TRENDING 🔥",
                      "image": "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
                    },
                    {
                      "title": "HIGHLY RATED ⭐",
                      "image": "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
                    },
                    {
                      "title": "MOST LOVED 💛",
                      "image": "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38",
                    },
                    {
                      "title": "NEARBY 📍",
                      "image": "https://images.unsplash.com/photo-1601050690597-df0568f70950",
                    },
                  ];

                  final item = items[index];

                  return FeatureCategoryCard(
                    title: item["title"]!,
                    image: item["image"]!,
                    onTap: () {
                      // TODO: open filtered stalls page later
                      debugPrint("Clicked: ${item["title"]}");
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
class VendorStoriesPageContent extends StatelessWidget {
  const VendorStoriesPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // MAIN CONTAINER (same width as hero & features)
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vendor Stories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (context, index) {
                        return _VendorStoryCard();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
class _VendorStoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // later: open story
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  "https://images.unsplash.com/photo-1601050690597-df0568f70950",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // TEXT
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Spicy Corner",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "By Ramesh",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCategoryCard extends StatefulWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const FeatureCategoryCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  State<FeatureCategoryCard> createState() => _FeatureCategoryCardState();
}

class _FeatureCategoryCardState extends State<FeatureCategoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          scale: isHovered ? 1.05 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  splashColor: Colors.amber.withOpacity(0.25),
                  highlightColor: Colors.amber.withOpacity(0.1),
                  child: Stack(
                    children: [
                      // 🖼 IMAGE
                      Positioned.fill(
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 🌫 GRADIENT
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 🏷 TEXT
                      Positioned(
                        left: 16,
                        bottom: 14,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class StallsPageContent extends StatelessWidget {
  final VoidCallback onOpenStall;

  const StallsPageContent({super.key, required this.onOpenStall});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 stalls per row
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) {
          return InkWell(
              borderRadius: BorderRadius.circular(20),
            onTap: onOpenStall,
            child: Container(

              decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // IMAGE
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1601050690597-df0568f70950",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // INFO
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Spicy Corner",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text("4.3"),
                          Spacer(),
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 2),
                          Text("1.2 km"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
              ),
          );
        },
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int streatoPoints = 0;
  int selectedPage = 0;
// 0 = Home
// 1 = Stalls
// 2 = Stall Details


  @override
  Widget build(BuildContext context) {
    debugPrint("CURRENT PAGE = $selectedPage");
    return AnimatedBuilder(
      animation: ThemeProvider.of(context),
      builder: (context, _) {
        return Scaffold(
          body: Stack(
            children: [
              // 🌋 BACKGROUND
              const AnimatedMeshBackground(),
              DoodleOverlay(),

              // 🧱 FOREGROUND UI
              SafeArea(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.18),
                  child: Row(
                    children: [
                      // LEFT NAV BAR
                      Container(
                        width: 64, // 👈 reduced ~20%
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            // LOGO (NO BACKGROUND)
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/streato.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // 🟡 YELLOW STRIP ONLY FOR ICONS
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB300),
                                borderRadius: BorderRadius.circular(10), // 👈 as you asked
                              ),
                              child: Column(
                                children: [
                                  _NavIcon(
                                    icon: Icons.home,
                                    isActive: selectedPage == 0,
                                    onTap: () => setState(() => selectedPage = 0),
                                  ),
                                  const SizedBox(height: 20),
                                  _NavIcon(
                                    icon: Icons.storefront,
                                    isActive: selectedPage == 1,
                                    onTap: () => setState(() => selectedPage = 1),
                                  ),
                                  const SizedBox(height: 20),
                                  _NavIcon(
                                    icon: Icons.menu_book,
                                    isActive: selectedPage == 2,
                                    onTap: () => setState(() => selectedPage = 2), // Vendor Stories
                                  ),

                                  const SizedBox(height: 20),
                                  _NavIcon(icon: Icons.star),
                                  const SizedBox(height: 20),
                                  _NavIcon(icon: Icons.map),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // MAIN CONTENT
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: Column(
                              children: [
                                // TOP BAR
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 520,
                                        child: HoverSearchBar(),
                                      ),
                                      const Spacer(),

                                      // THEME BUTTON
                                      GestureDetector(
                                        onTap: () {
                                          ThemeProvider.of(context).toggleTheme();
                                        },
                                        child: Icon(
                                          ThemeProvider.of(context).isDark
                                              ? Icons.dark_mode
                                              : Icons.light_mode,
                                          size: 26,
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      // POINTS
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.local_fire_department,
                                                color: Colors.orange),
                                            const SizedBox(width: 6),
                                            Text(streatoPoints.toString()),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 16),
                                      const Icon(Icons.shopping_cart_outlined, size: 26),
                                      const SizedBox(width: 16),
                                      const CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Color(0xFFFFBF00),
                                        child: Icon(Icons.person, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                // PAGE CONTENT
                                Expanded(
                                  child: () {
                                    if (selectedPage == 0) {
                                      return const HomePageContent();
                                    }

                                    if (selectedPage == 1) {
                                      return StallsPageContent(
                                        onOpenStall: () {
                                          setState(() => selectedPage = 3); // ✅ OPEN STALL DETAILS
                                        },
                                      );
                                    }

                                    if (selectedPage == 2) {
                                      return const VendorStoriesPageContent(); // ✅ VENDOR STORIES
                                    }

                                    if (selectedPage == 3) {
                                      return const FoodStallDetailsContent(); // ✅ STALL DETAILS
                                    }

                                    return const HomePageContent(); // fallback safety
                                  }(),
                                ),


                              ],
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
        );
      },
    );
  }

}

class _NavIcon extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavIcon({
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<_NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<_NavIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool highlight = widget.isActive || isHovered;

    final Color highlightBg = isDark
        ? const Color(0xFF1C1C1C)  // 🌙 dark mode
        : Colors.white;           // ☀️ light mode

    final Color iconColor = highlight
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? Colors.black87 : Colors.black87);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: highlight ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            height: 46,
            width: 46,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (highlight)
                  ClipPath(
                    clipper: _BiteClipper(),
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: highlightBg,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                Icon(
                  widget.icon,
                  size: 24,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
class _BiteClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path main = Path()
      ..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

    final double r = size.width * 0.12;

    // Three small bites near top-right
    final Path bite1 = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.78, size.height * 0.18),
        radius: r,
      ));

    final Path bite2 = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.78, size.height * 0.28),
        radius: r,
      ));

    final Path bite3 = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.78, size.height * 0.38),
        radius: r,
      ));

    Path result = Path.combine(PathOperation.difference, main, bite1);
    result = Path.combine(PathOperation.difference, result, bite2);
    result = Path.combine(PathOperation.difference, result, bite3);

    return result;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}






