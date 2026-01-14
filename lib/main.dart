import 'package:flutter/material.dart';
import 'dart:math';

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 50,
        transform: isHovered
            ? (Matrix4.identity()..scale(1.03))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: isHovered ? streatoGradient : null,
          color: isHovered ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isHovered ? Colors.transparent : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text("Search street food, stalls, stories..."),
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
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(child: Text("Feature Card")),
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

class StallsPageContent extends StatelessWidget {
  StallsPageContent({super.key});

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
          return Container(
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
          );
        },
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int streatoPoints = 0;
  int selectedPage = 0; // 0 = Home, 1 = Stalls

  @override
  Widget build(BuildContext context) {
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
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Column(
                                children: [
                                  // LOGO
                                  Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        "assets/images/streato.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 40),

                                  _NavIcon(
                                    icon: Icons.home,
                                    isActive: selectedPage == 0,
                                    onTap: () => setState(() => selectedPage = 0),
                                  ),
                                  const SizedBox(height: 28),
                                  _NavIcon(
                                    icon: Icons.storefront,
                                    isActive: selectedPage == 1,
                                    onTap: () => setState(() => selectedPage = 1),
                                  ),
                                  const SizedBox(height: 28),
                                  _NavIcon(icon: Icons.menu_book),
                                  const SizedBox(height: 28),
                                  _NavIcon(icon: Icons.star),
                                  const SizedBox(height: 28),
                                  _NavIcon(icon: Icons.map),
                                ],
                              ),
                            ),

                            // DIVIDER
                            Container(
                              width: 0.8,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: Colors.amber.withOpacity(0.6),
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
                                  child: selectedPage == 0
                                      ? HomePageContent()
                                      : StallsPageContent(),
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
                // 🍪 BITTEN CIRCLE BACKGROUND
                if (highlight)
                  ClipPath(
                    clipper: _BiteClipper(),
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFBF00),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFBF00).withOpacity(0.6),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),

                // ICON
                Icon(
                  widget.icon,
                  size: 24,
                  color: highlight
                      ? Colors.black
                      : (isDark ? Colors.white70 : Colors.black54),
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

    final Path bite = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * 0.85, size.height * 0.15), // top-right
          radius: size.width * 0.22, // bite size
        ),
      );

    return Path.combine(PathOperation.difference, main, bite);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}




