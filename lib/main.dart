import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:streato_app/pages/ai_assistant_page.dart';
import 'package:streato_app/pages/cart_page.dart';
import 'package:streato_app/pages/map_page.dart';
import 'package:streato_app/pages/social_feed_page.dart';
import 'package:streato_app/pages/vendor_stories_page.dart';
import 'package:streato_app/widgets/chronicles_bar.dart';
import 'package:streato_app/widgets/story_video_card.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_gate.dart';
import 'pages/leaderboard_page.dart';
import 'signup_screen.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/vendor.dart';
import 'services/vendor_service.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../utils/distance_utils.dart';
import '../services/cart_service.dart';
import 'services/gemini_service.dart';
import '../widgets/hero_video.dart';
import 'dart:ui';
import 'pages/map_page.dart';
import '../services/streato_points_service.dart';





class _RealSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const _RealSearchBar({
    required this.controller,
    required this.onSearch,
  });

  @override
  State<_RealSearchBar> createState() => _RealSearchBarState();
}

class _RealSearchBarState extends State<_RealSearchBar> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB300), // amber
            Color(0xFFFF8F00), // deep amber
          ],
        ),
        boxShadow: isFocused
            ? [
          BoxShadow(
            color: const Color(0xFFFFB300).withOpacity(0.6),
            blurRadius: 25,
            spreadRadius: 2,
          )
        ]
            : [],
      ),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 10),

            Expanded(
              child: Focus(
                onFocusChange: (f) {
                  setState(() => isFocused = f);
                },
                child: TextField(
                  controller: widget.controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    widget.onSearch(value);
                  },
                  decoration: const InputDecoration(
                    hintText: "Search street food, stalls...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class FilteredStallsPage extends StatelessWidget {
  final List<Vendor> vendors;
  final Function(Vendor) onOpenStall;

  const FilteredStallsPage({
    super.key,
    required this.vendors,
    required this.onOpenStall,
  });

  @override
  Widget build(BuildContext context) {
    if (vendors.isEmpty) {
      return const Center(child: Text("No stalls found"));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: filteredVendors.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) {
          final vendor = filteredVendors[index];

          return _StallCard(
            name: vendor.name,
            image: vendor.image,
            rating: vendor.rating,
            distance: 0, // optional
            onTap: () {
              onOpenStall(vendor);
            },
          );
        },
      ),
    );
  }
}*/


class StaticDoodleBackground extends StatelessWidget {
  const StaticDoodleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: StaticDoodlePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}



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
  final Vendor vendor;
  const FoodStallDetailsContent({super.key, required this.vendor});

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🏷️ NAME + OPEN/CLOSED
                      Row(
                        children: [
                          Text(
                            vendor.name,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: vendor.isOpen ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              vendor.isOpen ? "OPEN" : "CLOSED",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ❤️ ⭐ 📍 ROW
                      Row(
                        children: [
                          // ❤️ Likes
                          const Icon(Icons.favorite, color: Colors.red, size: 18),
                          const SizedBox(width: 4),
                          Text("${vendor.likesPercent}%"),

                          const SizedBox(width: 16),

                          // ⭐ Rating
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(vendor.rating.toString()),

                          const SizedBox(width: 16),

                          // 📍 Location
                          const Icon(Icons.location_on, size: 18),
                          const SizedBox(width: 4),
                          Text(vendor.locationName),
                        ],
                      ),
                    ],
                  ),


                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      vendor.image,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 30),
                  // 🔥 POPULAR DISHES
                  const Text(
                    "🔥 Popular Dishes",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  Container(
                    height: 2,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4, bottom: 16),
                    color: Colors.amber,
                  ),

                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: vendor.menu.take(5).map((item) {
                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.black.withOpacity(0.08),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              Text(
                                "₹${item.price}",
                                style: const TextStyle(
                                  color: Color(0xFFFFB300),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 📋 MENU
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

                  const SizedBox(height: 20),

                  // 🍔 FOOD ITEMS FROM FIRESTORE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6, // ✅ 60% WIDTH
                      child: Column(
                        children: vendor.menu.map((item) {
                          return _foodItem(context, item);
                        }).toList(),
                      ),
                    ),
                  ),


                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FIXED: context passed + price is int
  Widget _foodItem(BuildContext context, MenuItem item) {
    final qty = CartService.getQty(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // slightly smaller height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text("₹${item.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          const Spacer(),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (qty > 0)
                IconButton(
                  icon: const Icon(Icons.remove, color: Color(0xFFFFB300)),
                  onPressed: () {
                    CartService.remove(item);
                    (context as Element).markNeedsBuild(); // 🔥 forces rebuild
                  },
                ),

              if (qty > 0)
                Text(
                  qty.toString(),
                  style: const TextStyle(
                    color: Color(0xFFFFB300),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFFFFB300)),
                onPressed: () {
                  CartService.add(item);
                  (context as Element).markNeedsBuild(); // 🔥 forces rebuild
                },
              ),
            ],
          ),
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


class StaticDoodlePainter extends CustomPainter {
  final Random r = Random(12345); // fixed seed = SAME PATTERN ALWAYS

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.035) // VERY subtle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const double spacing = 38; // 👈 VERY CLOSE like WhatsApp

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final dx = x + r.nextDouble() * 6;
        final dy = y + r.nextDouble() * 6;
        final s = 8 + r.nextDouble() * 6; // 👈 VERY SMALL

        switch (r.nextInt(6)) {
          case 0: // bowl
            canvas.drawArc(
              Rect.fromCenter(center: Offset(dx, dy), width: s, height: s),
              0,
              pi,
              false,
              paint,
            );
            break;

          case 1: // flame
            final path = Path()
              ..moveTo(dx, dy)
              ..quadraticBezierTo(dx + s * 0.3, dy - s, dx, dy - s * 1.1)
              ..quadraticBezierTo(dx - s * 0.3, dy - s, dx, dy);
            canvas.drawPath(path, paint);
            break;

          case 2: // spoon
            canvas.drawCircle(Offset(dx, dy), s * 0.25, paint);
            canvas.drawLine(
              Offset(dx, dy + s * 0.25),
              Offset(dx, dy + s),
              paint,
            );
            break;

          case 3: // pan
            canvas.drawCircle(Offset(dx, dy), s * 0.35, paint);
            canvas.drawLine(
              Offset(dx + s * 0.35, dy),
              Offset(dx + s, dy),
              paint,
            );
            break;

          case 4: // star
            canvas.drawLine(Offset(dx - s * 0.6, dy), Offset(dx + s * 0.6, dy), paint);
            canvas.drawLine(Offset(dx, dy - s * 0.6), Offset(dx, dy + s * 0.6), paint);
            break;

          case 5: // squiggle
            final path = Path()
              ..moveTo(dx - s * 0.6, dy)
              ..quadraticBezierTo(dx, dy - s * 0.6, dx + s * 0.6, dy)
              ..quadraticBezierTo(dx + s, dy + s * 0.4, dx + s * 1.2, dy);
            canvas.drawPath(path, paint);
            break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // 🔥 NEVER REPAINT
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
  bool isDark = true;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

          themeAnimationDuration: const Duration(milliseconds: 400), // ✅ THIS
          themeAnimationCurve: Curves.easeInOutCubic,                 // ✅ THIS

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
            scaffoldBackgroundColor: const Color(0xFF1C1C1C),
            cardColor: const Color(0xFF252525),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFFBF00),
              brightness: Brightness.dark,
            ),
          ),

          home: const AuthGate(),
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  bool loading = false;

  Future<void> login() async {
    try {
      setState(() => loading = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ SUCCESS: AuthGate will automatically redirect to HomeScreen

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }
  Future<void> signup() async {
    try {
      setState(() => loading = true);

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "name": emailController.text.split("@")[0], // temp name
        "streatoPoints": 0,
        "photoUrl": "",
      });

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    } finally {
      setState(() => loading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌄 BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/sky.png",
              fit: BoxFit.cover,
            ),
          ),

          // 🌫 DARK OVERLAY (for contrast)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: Text(
              "Streato",
              style: TextStyle(
                fontFamily: "Blackbones",
                fontSize: 42,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),


          // 🧊 CENTER GLASS CARD
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🏷 LOGO
                      const Icon(Icons.fastfood, size: 48, color: Colors.white),
                      const SizedBox(height: 12),

                      Text(isLogin ? "Sign in with email" : "Create account",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Your ticket to a flavor-filled heaven and street food paradise.\nWelcome to Streato",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 24),

                      // 📧 EMAIL
                      _glassField(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 16),

                      // 🔒 PASSWORD
                      _glassField(
                        controller: passwordController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      //LOGIN BUTTON
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: loading
                              ? null
                              : () {
                            if (isLogin) {
                              login();
                            } else {
                              signup();
                            }
                          },
                          child: loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(isLogin ? "Login" : "Sign Up"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔁 🔥 ADD THIS EXACT BLOCK
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Don't have an account? Create one"
                              : "Already have an account? Login",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 16),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
class PremiumSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const PremiumSearchBar({super.key, required this.onSearch});

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🌑 OUTER PILL (always dark glass)
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
              ),
            ),
          ),

          // 🔍 SEARCH ICON (sits in outer area)
          Positioned(
            left: 22,
            child: Icon(
              Icons.search,
              size: 22,
              color: isDark ? const Color(0xFFFFB300) : Colors.black,
            ),
          ),

          // ☁️ INNER PILL
          Positioned(
            left: 58, // 👈 pushes inner pill right (so icon stays outside)
            right: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  height: 44,
                  alignment: Alignment.center, // ✅ vertical centering
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.5),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      height: 1.0, // ✅ perfect vertical centering
                    ),
                    decoration: InputDecoration(
                      hintText: "Search Streat Food, Stalls..",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : Colors.black.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      isCollapsed: true, // ✅ fixes vertical misalignment
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        widget.onSearch(value.trim());
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
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
  final VoidCallback onTrending;
  final VoidCallback onHighlyRated;
  final VoidCallback onMostLoved;
  final VoidCallback onNearby;
  final Function(String) onMoodSelected;

  const HomePageContent({
    super.key,
    required this.onTrending,
    required this.onHighlyRated,
    required this.onMostLoved,
    required this.onNearby,
    required this.onMoodSelected,
  });



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
// HERO
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: const HeroVideo(),   // 👈 VIDEO HERE
              ),
            ),
          ),


          const SizedBox(height: 20),
          /// ================= CHRONICLES =================
          const SizedBox(height: 18),

          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,   // 🔥 SAME AS HERO & DISCOVER
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 CENTERED HEADING (LIKE DISCOVER)
                  const Center(
                    child: Text(
                      "Chronicles",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 STORIES ROW (LEFT ALIGNED WITH HERO)
                  SizedBox(
                    height: 95,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chronicles")
                          .orderBy("createdAt", descending: true)
                          .limit(7)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final docs = snapshot.data!.docs;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;

                            return Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFFB300),
                                          Color(0xFFFF8F00),
                                        ],
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundImage: (data["userPhoto"] != null &&
                                          data["userPhoto"].toString().isNotEmpty)
                                          ? NetworkImage(data["userPhoto"])
                                          : null,
                                      child: (data["userPhoto"] == null ||
                                          data["userPhoto"].toString().isEmpty)
                                          ? const Icon(Icons.person, color: Colors.white)
                                          : null,
                                    )
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    data["userName"] ?? "User",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
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
                      "title": "SPICY KICK",
                      "image": "assets/images/spicykick.jpg",
                      "type": "spicy",
                      //"image": "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800"
                    },
                    {
                      "title": "SWEET ESCAPE",
                      "image": "assets/images/sweetescape.jpg",
                      "type": "sweet",
                      //"image": "https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=800"
                    },
                    {
                      "title": "LUXURY STREET",
                      "image":"assets/images/luxurystreat.png",
                      "type": "luxury",
                      //"image": "https://images.unsplash.com/photo-1544025162-d76694265947?w=800"
                    },
                    {
                      "title": "FOR YOU",
                      "image": "assets/images/foryou.jpg",
                      "type": "all",
                      //"image": "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800"
                    },
                  ];

                  final item = items[index];

                  return FeatureCategoryCard(
                    title: item["title"]!,
                    image: item["image"]!,
                    onTap: () {
                      final mood = item["type"]!;

                      if (mood == "spicy") {
                        onMoodSelected("spicy");
                      }
                      else if (mood == "sweet") {
                        onMoodSelected("sweet");
                      }
                      else if (mood == "luxury") {
                        onMoodSelected("luxury");
                      }
                      else {
                        onMoodSelected("all");
                      }
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("vendor_stories").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No stories found"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: StoryVideoCard(
                          videoUrl: data["videoUrl"],
                          stallName: data["stallName"],
                          vendorName: data["vendorName"], storyId: '',
                        ),
                      );
                    },
                  ),

                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
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
        onTap: (){
          widget.onTap();
        },
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
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 🌫 GRADIENT
                      // 🌫 MODERN TEXT-ONLY OVERLAY
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 70, // only bottom area
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.55),
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
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 6,
                              ),
                            ],
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



class StallsPageContent extends StatefulWidget {
  final String? filterType;
  final Function(Vendor vendor) onOpenStall;


  const StallsPageContent({super.key, required this.onOpenStall,this.filterType});

  @override
  State<StallsPageContent> createState() => _StallsPageContentState();
}

class _StallsPageContentState extends State<StallsPageContent> {
  Position? userPosition;
  bool showFilters = false;
  String selectedCategory = "All";
  String selectedMood="all";
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final pos = await LocationService.getCurrentLocation();
    setState(() => userPosition = pos);
  }

  @override
  Widget build(BuildContext context) {
    if (userPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("vendors").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No stalls found"));
        }

        // 🧠 Map + calculate distance
        final vendors = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Vendor.fromFirestore(doc.id, data);
        }).toList();
        List<Vendor> filteredVendors = vendors;
        /// ================= MOOD FILTER =================
        if (widget.filterType != null) {
          final mood = widget.filterType!.toLowerCase();

          if (mood == "spicy" || mood == "sweet" || mood == "luxury") {
            filteredVendors = filteredVendors.where((v) {
              return v.category.toLowerCase().contains(mood);
            }).toList();
          }
        }
        /// ================= CATEGORY FILTER =================
        if (selectedCategory != "All") {
          filteredVendors = filteredVendors.where((vendor) {

            final category = vendor.category.toLowerCase();

            if (selectedCategory == "Indian") {
              return category.contains("indian");
            }

            if (selectedCategory == "Chinese") {
              return category.contains("chinese");
            }

            if (selectedCategory == "Fusion") {
              return category.contains("fusion");
            }

            if (selectedCategory == "Street Snacks") {
              return category.contains("snack") ||
                  category.contains("street");
            }

            return true;
          }).toList();
        }

// 🔥 APPLY FILTER IF TRENDING
        if (widget.filterType == "trending") {
          filteredVendors = vendors.where((v) {
            return v.rating >= 4.5 && v.likesPercent >= 90;
          }).toList();
        }

        if (widget.filterType == "highly") {
          filteredVendors = vendors.where((v) => v.rating >= 4.5).toList();
        }

        if (widget.filterType == "loved") {
          filteredVendors = vendors.where((v) => v.likesPercent >= 90).toList();
        }

        if (widget.filterType == "nearby") {
          filteredVendors = vendors.where((v) {
            final d = distanceInKm(
              userPosition!.latitude,
              userPosition!.longitude,
              v.lat,
              v.lng,
            );
            return d <= 3;
          }).toList();
        }
        // 🔥 Sort by nearest
        filteredVendors.sort((a, b) {
          final da = distanceInKm(
            userPosition!.latitude,
            userPosition!.longitude,
            a.lat,
            a.lng,
          );
          final db = distanceInKm(
            userPosition!.latitude,
            userPosition!.longitude,
            b.lat,
            b.lng,
          );
          return da.compareTo(db);
        });
        return Column(
          children: [

            /// ================= FILTER BUTTON =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [

                  /// FILTER BUTTON
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade400),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                            )
                          ]
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.tune, size: 18),
                          SizedBox(width: 6),
                          Text("Filters"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// 🔥 MAP TOGGLE BUTTON
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showMap = !showMap;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade400),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                            )
                          ]
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.map,
                            size: 18,
                            color: showMap ? Colors.black : null,
                          ),
                          const SizedBox(width: 6),
                          const Text("Map Toggle"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ================= CATEGORY CHIPS =================
            if (showFilters)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Wrap(
                  spacing: 10,
                  children: [
                    _chip("All"),
                    _chip("Indian"),
                    _chip("Chinese"),
                    _chip("Fusion"),
                    _chip("Street Snacks"),
                  ],
                ),
              ),

            /// ================= STALL GRID =================
            Expanded(
              child: showMap
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: StreatoMapPage(
                  userLat: userPosition!.latitude,
                  userLon: userPosition!.longitude,
                  onOpenStall: (vendor) {
                    widget.onOpenStall(vendor);
                  },
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: filteredVendors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final vendor = filteredVendors[index];

                    final dist = distanceInKm(
                      userPosition!.latitude,
                      userPosition!.longitude,
                      vendor.lat,
                      vendor.lng,
                    );

                    return _StallCard(
                      name: vendor.name,
                      image: vendor.image,
                      rating: vendor.rating,
                      distance: dist,
                      onTap: () {
                        widget.onOpenStall(vendor);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );

      },
    );
  }
  Widget _chip(String label) {
    final bool isActive = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFB300) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: [
            BoxShadow(
              color:
                Colors.black.withOpacity(0.06),
              blurRadius:6,
            )
          ]
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : null,
            color: isActive ? Colors.black : null,
          ),
        ),
      ),
    );
  }
}
class _StallCard extends StatefulWidget {
  final String name;
  final String image;
  final double rating;
  final double distance;
  final VoidCallback onTap;

  const _StallCard({
    required this.name,
    required this.image,
    required this.rating,
    required this.distance,
    required this.onTap,
  });

  @override
  State<_StallCard> createState() => _StallCardState();
}

class _StallCardState extends State<_StallCard> {
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
          scale: isHovered ? 1.05 : 1.0,   // ✅ ZOOM EFFECT
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        widget.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(widget.rating.toStringAsFixed(1)),
                            const Spacer(),
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 2),
                            Text("${widget.distance.toStringAsFixed(2)} km"),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final VoidCallback onTap;

  const VendorCard({super.key, required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                vendor.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vendor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(vendor.rating.toString()),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
        ),
    );
  }
}
class _HomeScreenState extends State<HomeScreen> {
  String? stallFilterType;

  final TextEditingController searchController = TextEditingController();
  List<Vendor> filteredVendors = [];
  Position? userPosition;
  Future<void> openHighlyRated() async {
    print("Highly rated clicked");

    setState(() {
      stallFilterType = "highly"; // or "loved", "nearby", "trending"
      selectedPage = 1; // 👈 ALWAYS go to stalls page
    });

  }

  Future<void> openMostLoved() async {
    print("most loved clicked");

    setState(() {
      stallFilterType = "loved"; // or "loved", "nearby", "trending"
      selectedPage = 1; // 👈 ALWAYS go to stalls page
    });

  }

  Future<void> openNearby() async {
    print("nearby clicked");

    setState(() {
      stallFilterType = "nearby"; // or "loved", "nearby", "trending"
      selectedPage = 1; // 👈 ALWAYS go to stalls page
    });

  }
  Future<void> openTrending() async {
    print("trending clicked");

    setState(() {
      selectedPage = 1;
      stallFilterType="trending";
    });
  }
  Future<void> openMood(String mood) async {
    print("Mood clicked: $mood");

    setState(() {
      selectedPage = 1;        // opens stalls page
      stallFilterType = mood;  // applies filter
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }


  Future<void> _loadLocation() async {
    final pos = await LocationService.getCurrentLocation();
    setState(() => userPosition = pos);
  }

  int selectedPage = 0;
  Vendor? selectedVendor;
  List<Vendor> searchResults = [];
  bool isSearching = false;
  Future<void> onSearch(String text) async {
    setState(() {
      isSearching = true;
    });

    print("SEARCH TEXT = $text");

    final aiFilter = await GeminiService.parseQuery(text);
    final vendors = await VendorService.getAllVendors();

    // 🛟 FALLBACK IF GEMINI FAILS
    if (aiFilter.isEmpty) {
      print("⚠️ Gemini failed, using strict menu search");

      final raw = text.toLowerCase().trim();

      final results = vendors.where((v) {
        for (final item in v.menu) {
          final itemName = item.name.toLowerCase().trim();
          if (itemName.contains(raw)) {
            return true;
          }
        }
        return false;
      }).toList();


      setState(() {
        searchResults = results;
        selectedPage = 4;
        isSearching = false;
      });

      return;
    }




    print("AI FILTER = $aiFilter");

    String? food = aiFilter["food"]?.toString().toLowerCase();

    if (food != null) {
      food = food
          .replaceAll("under", "")
          .replaceAll("below", "")
          .replaceAll("rs", "")
          .replaceAll("₹", "")
          .trim();
    }

    if (food == null || food.isEmpty) {
      setState(() {
        searchResults = [];
        selectedPage = 4;
        isSearching = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please search like: dosa, idli, paneer, etc")),
      );

      return; // ⛔ STOP SEARCH COMPLETELY
    }



    final maxPrice = aiFilter["max_price"] == null
        ? null
        : double.tryParse(aiFilter["max_price"].toString());

    print("FOOD = $food");
    print("MAX PRICE = $maxPrice");

    print("TOTAL VENDORS FROM FIRESTORE = ${vendors.length}");

    for (final v in vendors) {
      print("VENDOR = ${v.name}");
      for (final item in v.menu) {
        print("  ITEM = ${item.name}  PRICE = ${item.price}");
      }
    }

    final results = vendors.where((v) {
      bool foundValidItem = false;

      for (final item in v.menu) {
        print("CHECKING ITEM: ${item.name} PRICE: ${item.price}");
        print("FOOD QUERY: $food  MAX PRICE: $maxPrice");

        final itemName = item.name.toLowerCase().trim();

        // 🔹 FOOD MATCH (SMART)
        if (food != null && food.isNotEmpty) {
          if (!itemName.contains(food)) {
            continue; // not matching this food
          }
        }

        // 🔹 PRICE MATCH
        if (maxPrice != null) {
          if (item.price > maxPrice) {
            continue; // too expensive
          }
        }

        // ✅ MATCH FOUND
        foundValidItem = true;
        break;
      }

      return foundValidItem;
    }).toList();









    print("RESULT COUNT = ${results.length}");

    setState(() {
      searchResults = results;
      selectedPage = 4;
      isSearching = false;
    });
    print("TOTAL VENDORS = ${vendors.length}");

    for (var v in vendors) {
      print("VENDOR: ${v.name}  MENU COUNT = ${v.menu.length}");
    }


  }






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
              Builder(
                builder: (context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;

                  if (isDark) {
                    // 🌙 KEEP YOUR OLD ANIMATED BLOBS
                    return const AnimatedMeshBackground();
                  } else {
                    // ☀️ LIGHT MODE → DOODLES
                    return Container(color: Colors.white);
                  }
                },
              ),


              // 🧱 FOREGROUND UI
              SafeArea(
                child: Container(
                  color: Colors.transparent,
                  child: userPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                    children: [
                  // your UI
                      // LEFT NAV BAR
                      Container(
                        width: 100, // 👈 reduced ~20%
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            // 🏷 STREATO WORDMARK
                            Padding(
                              padding: const EdgeInsets.only(left: 24), // 👈 moves ~7% right from edge
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 180, // enough for the word in one line
                                  child: Text(
                                    "Streato",
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      fontFamily: "Blackbones",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400,
                                      height: 1.0, // 👈 prevents vertical misalignment
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFFFFB300)
                                          : Colors.black,
                                    ),
                                  ),
                                ),

                              ),
                            ),
                            const SizedBox(height: 28),
                            // 🟡 YELLOW STRIP ONLY FOR ICONS
                            Padding(
                              padding: const EdgeInsets.only(left: 24), // ✅ SAME AS STREATO
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB300),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  children: [
                                    _NavIcon(
                                      icon: LucideIcons.home,
                                      isActive: selectedPage == 0,
                                      onTap: () => setState(() => selectedPage = 0),
                                    ),
                                    const SizedBox(height: 20),
                                    _NavIcon(
                                      icon: LucideIcons.croissant,
                                      isActive: selectedPage == 1,
                                      onTap: () => setState(() => selectedPage = 1),
                                    ),
                                    const SizedBox(height: 20),
                                    _NavIcon(
                                      icon: LucideIcons.messageSquare,
                                      isActive: selectedPage == 2,
                                      onTap: () => setState(() => selectedPage = 2),
                                    ),
                                    const SizedBox(height: 20),
                                    _NavIcon(
                                      icon: LucideIcons.trophy,
                                      isActive: selectedPage == 6,   // leaderboard page index
                                      onTap: () => setState(() => selectedPage = 6),
                                    ),
                                    const SizedBox(height: 20),
                                    _NavIcon(
                                      icon: LucideIcons.donut,
                                      isActive: selectedPage == 7,
                                      onTap: ()=>setState(()=>selectedPage=7),
                                    ),
                                  ],
                                ),
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
                                  child: Center(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.8, // SAME AS HERO
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // 🔍 SEARCH BAR
                                          SizedBox(
                                            width: 420,
                                            child: PremiumSearchBar(
                                              onSearch: (text) {
                                                onSearch(text); // YOUR EXISTING SEARCH FUNCTION
                                              },
                                            ),
                                          ),




                                          const Spacer(),

                                          // 🌙 THEME BUTTON
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

                                          // 🔥 POINTS
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.local_fire_department, color: Colors.orange),
                                                const SizedBox(width: 6),
                                                FutureBuilder<int>(
                                                  future: StreatoPointsService.getPoints(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const Text("0");
                                                    }
                                                    return Text(
                                                      snapshot.data.toString(),
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 16),

                                          // 🛒 CART
                                          Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => const CartPage()),
                                                  );
                                                },

                                                child: Stack(
                                                  children: [
                                                    const Icon(Icons.shopping_cart_outlined, size: 26),

                                                    if (CartService.totalItems > 0)
                                                      Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xFFFFB300),
                                                            shape: BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),

                                              if (CartService.totalItems > 0)
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFFFFB300),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),

                                            ],
                                          ),

                                          const SizedBox(width: 16),

                                          const CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Color(0xFFFFBF00),
                                            child: Icon(Icons.person, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),


                                // PAGE CONTENT
                                Expanded(
                                  child: () {
                                    if (selectedPage == 0) {
                                      return HomePageContent(
                                        onTrending: openTrending,
                                        onHighlyRated: openHighlyRated,
                                        onMostLoved: openMostLoved,
                                        onNearby: openNearby,
                                        onMoodSelected: openMood,
                                      );

                                    }

                                    if (selectedPage == 1) {
                                      return StallsPageContent(
                                        filterType: stallFilterType,
                                        onOpenStall: (vendor) {
                                          setState(() {
                                            selectedVendor = vendor;
                                            selectedPage = 3;
                                          });
                                        },
                                      );
                                    }



                                    if (selectedPage == 2) {
                                      return const SocialFeedPage(); // ✅ VENDOR STORIES
                                    }

                                    if (selectedPage == 3) {
                                      return FoodStallDetailsContent(vendor: selectedVendor!);
                                      // ✅ STALL DETAILS
                                    }
                                    if (selectedPage == 4) {
                                      return SearchResultsPage(
                                        results: searchResults,
                                        onOpenStall: (vendor) {
                                          setState(() {
                                            selectedVendor = vendor;
                                            selectedPage = 3; // open details page
                                          });
                                        },
                                      );
                                    }
                                    if (selectedPage == 5) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: StreatoMapPage(
                                          userLat: userPosition!.latitude,
                                          userLon: userPosition!.longitude,
                                          onOpenStall: (vendor) {
                                            setState(() {
                                              selectedVendor = vendor;
                                              selectedPage = 3; // open stall details page
                                            });
                                          },
                                        ),
                                      );
                                    }
                                    if(selectedPage==6){
                                      return const LeaderboardPage();
                                    }
                                    if(selectedPage==7){
                                      return const AIAssistantPage();
                                    }
                                    return HomePageContent(
                                      onTrending: () {  },onHighlyRated: () {  }, onMostLoved: () {  }, onNearby: () {  },onMoodSelected: openMood,); // fallback safety
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
class SearchResultsPage extends StatelessWidget {
  final List<Vendor> results;
  final Function(Vendor) onOpenStall;

  const SearchResultsPage({
    super.key,
    required this.results,
    required this.onOpenStall,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(child: Text("No stalls match your search"));
    }


    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: results.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) {
          final vendor = results[index];

          return _StallCard(
            name: vendor.name,
            image: vendor.image,
            rating: vendor.rating,
            distance: 0, // you can compute later
            onTap: () {
              onOpenStall(vendor); // 🔥 OPEN DETAILS PAGE
            },
          );
        },
      ),
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
                  size: 26,
                  color: iconColor,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                    )
                  ],
                )
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







