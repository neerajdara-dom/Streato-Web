import 'package:flutter/material.dart';
const LinearGradient streatoGradient = LinearGradient(
  colors: [
    Color(0xFFFF8F00), // Deep Orange
    Color(0xFFFFCA28), // Amber
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);


void main() {
  runApp(const StreatoApp());
}

class StreatoApp extends StatelessWidget {
  const StreatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streato',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFFBF00), // Amber Yellow
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFBF00),
        ),
      ),
      home: const SplashScreen(),
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
                color: Colors.white70,
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
                    backgroundColor: const Color(0xFFFFBF00),
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
            color: isHovered ? Colors.transparent : Colors.white,
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


class _HomeScreenState extends State<HomeScreen> {
  int streatoPoints = 0; // 🔥 USER POINTS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Row(
          children: [
            // LEFT MINIMAL NAV BAR
            Container(
              width: 90,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  // ICON COLUMN
                  SizedBox(
                    width: 70,
                    child: Column(
                      children: [
                        // LOGO
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
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

                        _NavIcon(icon: Icons.home, isActive: true),
                        const SizedBox(height: 28),
                        _NavIcon(icon: Icons.storefront),
                        const SizedBox(height: 28),
                        _NavIcon(icon: Icons.menu_book),
                        const SizedBox(height: 28),
                        _NavIcon(icon: Icons.star),
                        const SizedBox(height: 28),
                        _NavIcon(icon: Icons.map),
                      ],
                    ),
                  ),

                  // VERTICAL DIVIDER LINE
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.amber.withOpacity(0.6),
                  ),
                ],
              ),
            ),
            // MAIN CONTENT
            Expanded(
              child: Column(
                children: [
                  // TOP BAR
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // 🔍 SEARCH BAR (50% WIDTH + HOVER EFFECT)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: const HoverSearchBar(),
                        ),

                        const Spacer(),

                        // 🔥 STREATO POINTS
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.orange),
                              const SizedBox(width: 6),
                              Text(
                                streatoPoints.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 🛒 CART
                        const Icon(Icons.shopping_cart_outlined, size: 26),

                        const SizedBox(width: 16),

                        // 👤 PROFILE
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFFFBF00),
                          child: Icon(Icons.person, color: Colors.black),
                        )
                      ],
                    ),
                  ),

                  // HORIZONTAL DIVIDER
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.amber.withOpacity(0.6),
                  ),

                  // HERO + CONTENT (SCROLLABLE)
                  Expanded(
                    child: Row(
                      children: [
                        // LEFT CONTENT AREA
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // HERO CARD
                                Container(
                                  height: 350,
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.black,
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        "https://plus.unsplash.com/premium_photo-1695297516142-398762d80f66?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDF8fHN0cmVldCUyMGZvb2R8ZW58MHx8MHx8fDA%3D",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Discover the stories\nbehind street food ❤️",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // FEATURE CARDS GRID
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: GridView.builder(
                                    shrinkWrap: true, // 👈 VERY IMPORTANT
                                    physics: const NeverScrollableScrollPhysics(), // 👈 VERY IMPORTANT
                                    itemCount: 6,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 1.6,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 12,
                                            )
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Feature Card",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 40), // bottom space
                              ],
                            ),
                          ),
                        ),

                        // RIGHT FLOATING MAP BUTTON (STAYS FIXED)
                        SizedBox(
                          width: 80,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: streatoGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 12,
                                      )
                                    ],
                                  ),
                                  child: const Icon(Icons.map, size: 28),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
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
class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavIcon({
    required this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFBF00) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.black54,
        size: 24,
      ),
    );
  }
}

