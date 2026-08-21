import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';


void main() {
  runApp(const MKKhairulPropertyToolsApp());
}

void openPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 160),
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

class MKKhairulPropertyToolsApp extends StatelessWidget {
  const MKKhairulPropertyToolsApp({super.key});

  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);
  static const ivory = Color(0xFFF8F5EE);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MK KHAIRUL Property Tools',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          secondary: gold,
          surface: ivory,
        ),
      ),
      home: kIsWeb &&
        Uri.base.pathSegments.length >= 2 &&
        Uri.base.pathSegments.first == 'property'
    ? DirectPropertyScreen(
        propertyId: Uri.decodeComponent(
          Uri.base.pathSegments.sublist(1).join('/'),
        ),
      )
    : const HomeScreen(),
    );
  }
}

class DirectPropertyScreen extends StatefulWidget {
  final String propertyId;

  const DirectPropertyScreen({
    super.key,
    required this.propertyId,
  });

  @override
  State<DirectPropertyScreen> createState() =>
      _DirectPropertyScreenState();
}

class _DirectPropertyScreenState
    extends State<DirectPropertyScreen> {
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);

  static const String listingApiUrl =
      'https://script.google.com/macros/s/AKfycbyKKrioq22adrb2wpdad3wj6CedlqhLzEomOCkR-AdXcjU75M9pNTTySz5xYBEqN8gb/exec';

  Map<String, dynamic>? property;
  String? loadError;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  Future<void> _loadProperty() async {
    try {
      final response = await http.get(
        Uri.parse(listingApiUrl),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);

      if (data['success'] != true) {
        throw Exception(
          data['error'] ?? 'Unable to load property.',
        );
      }

      final rawListings = data['listings'] ?? [];

      Map<String, dynamic>? matchedProperty;

      for (final raw in rawListings) {
        if (raw is! Map) continue;

        final item = Map<String, dynamic>.from(raw);

        final itemId =
            (item['ID'] ?? '').toString().trim();

        if (itemId.toLowerCase() ==
            widget.propertyId.trim().toLowerCase()) {
          matchedProperty = item;
          break;
        }
      }

      if (!mounted) return;

      if (matchedProperty == null) {
        setState(() {
          isLoading = false;
          loadError =
              'Property "${widget.propertyId}" was not found.';
        });
        return;
      }

      setState(() {
        property = matchedProperty;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: deepNavy,
        body: Center(
          child: CircularProgressIndicator(
            color: gold,
          ),
        ),
      );
    }

    if (property != null) {
      return PropertyDetailScreen(
        property: property!,
      );
    }

    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'PROPERTY NOT FOUND',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                color: gold,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'Property not found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                loadError ??
                    'This property may no longer be available.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const navy = Color(0xFF0B1F33);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: Center(
        child: Image.asset(
          'assets/splash/splash_logo.png',
          width: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  Future<void> _openUrl(Uri url) async {
    final launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  Future<void> _talkToMKKhairul() async {
    final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

Boleh bantu saya?
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    await _openUrl(whatsappUrl);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
    MediaQuery.sizeOf(context).width;

final bool isWebDesktop =
    kIsWeb && screenWidth >= 900;

    return Scaffold(
      backgroundColor: deepNavy,
      body: SafeArea(
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1200,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          children: [
// BRAND HEADER - 3 MODE
isWebDesktop

    // =========================================
    // WEB DESKTOP
    // =========================================
    ? Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: navy,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x55D4AF37),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Image.asset(
                'assets/splash/splash_logo.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 22),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MK KHAIRUL',
                    style: TextStyle(
                      color: softGold,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    'PROPERTY TOOLS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),

                  SizedBox(height: 7),

                  Text(
                    'SMART TOOLS. BETTER DECISIONS.',
                    style: TextStyle(
                      color: softGold,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: gold.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                    BorderRadius.circular(30),
                border: Border.all(
                  color:
                      const Color(0x55D4AF37),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language_rounded,
                    color: gold,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'WEB VERSION',
                    style: TextStyle(
                      color: softGold,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )

    // =========================================
    // WEB MOBILE
    // =========================================
    : kIsWeb
        ? Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: navy,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color:
                    const Color(0x55D4AF37),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: Image.asset(
                    'assets/splash/splash_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 11),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Text(
                        'MK KHAIRUL',
                        maxLines: 1,
                        style: TextStyle(
                          color: softGold,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w900,
                          letterSpacing: 1.0,
                          height: 1.0,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'PROPERTY TOOLS',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w900,
                          height: 1.0,
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        'SMART TOOLS. BETTER DECISIONS.',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: softGold,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: gold.withValues(
                      alpha: 0.10,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          const Color(0x55D4AF37),
                    ),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    color: gold,
                    size: 17,
                  ),
                ),
              ],
            ),
          )

        // =====================================
        // ANDROID APP - KEKALKAN ASAL
        // =====================================
        : Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/splash/splash_logo.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      'MK KHAIRUL',
                      style: TextStyle(
                        color: softGold,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing: 1.5,
                        height: 1.0,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'PROPERTY TOOLS',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing: 0.5,
                        height: 1.0,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'SMART TOOLS. BETTER DECISIONS.',
                      maxLines: 1,
                      style: TextStyle(
                        color: softGold,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
                        letterSpacing: 0.5,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              const Icon(
                Icons.menu_rounded,
                color: gold,
                size: 28,
              ),
            ],
          ),
const SizedBox(height: 10),

const Divider(
  color: Color(0x55D4AF37),
  thickness: 1,
),

const SizedBox(height: 18),

            // 6 MAIN TOOLS
            GridView.count(
  crossAxisCount:
    isWebDesktop ? 3 : 2,

  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),

  crossAxisSpacing:
    isWebDesktop ? 14 : 12,

mainAxisSpacing:
    isWebDesktop ? 14 : 12,

  childAspectRatio:
    isWebDesktop ? 1.35 : 0.90,
              children: [
  PremiumToolCard(
    icon: Icons.account_balance_wallet_outlined,
    title: 'HOW MUCH\nCAN I BORROW?',
    subtitle: 'Check your loan\neligibility',
    onTap: () {
      openPage(
        context,
        const LoanEligibilityScreen(),
      );
    },
  ),

  PremiumToolCard(
                  icon: Icons.calculate_outlined,
                  title: 'LOAN\nCALCULATOR',
                  subtitle: 'Estimate your\nmonthly instalment',
                  onTap: () {
  openPage(
    context,
    const LoanCalculatorScreen(),
  );
},
                ),

                PremiumToolCard(
                  icon: Icons.trending_up_rounded,
                  title: 'INVESTMENT\nCALCULATOR',
                  subtitle: 'Calculate yield,\ncash flow & ROI',
                  onTap: () {
  openPage(
    context,
    const InvestmentCalculatorScreen(),
  );
},
                ),

                PremiumToolCard(
                  icon: Icons.forum_outlined,
                  title: 'PROPERTY\nENQUIRY',
                  subtitle: 'Tell us what you\nare looking for',
                  onTap: () {
  openPage(
    context,
    const PropertyEnquiryScreen(),
  );
},
                ),

                PremiumToolCard(
                  icon: Icons.menu_book_outlined,
                  title: 'PROPERTY\nGUIDE',
                  subtitle: 'Simple guides for\nsmart buyers',
                  onTap: () {
  openPage(
    context,
    const PropertyGuideScreen(),
  );
},
                ),

                PremiumToolCard(
                  icon: Icons.support_agent_outlined,
                  title: 'TALK TO\nMK KHAIRUL',
                  subtitle: 'Connect directly\nwith me',
                  onTap: _talkToMKKhairul,
                ),
              ],
            ),

            const SizedBox(height: 16),

           const SizedBox(height: 14),
const SizedBox(height: 14),

// PROPERTY LISTING
Material(
  color: navy,
  borderRadius: BorderRadius.circular(18),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: () {
  openPage(
    context,
    const PropertyListingScreen(),
  );
},
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold,
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.real_estate_agent_outlined,
              color: gold,
              size: 45,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROPERTY LISTING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'LATEST PROPERTIES • SALE • RENT',
                  style: TextStyle(
                    color: softGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: gold,
            size: 18,
          ),
        ],
      ),
    ),
  ),
),

const SizedBox(height: 14),

// MK CLIENT
Material(
  color: navy,
  borderRadius: BorderRadius.circular(18),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: () {
  openPage(
    context,
    const MKClientScreen(),
  );
},
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold,
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: gold,
              size: 45,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MK CLIENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'OWNER  •  TENANT  •  BUYER  •  JOIN US',
                  style: TextStyle(
                    color: softGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: gold,
            size: 18,
          ),
        ],
      ),
    ),
  ),
),

const SizedBox(height: 14),
// MK HOME HUB
Material(
  color: navy,
  borderRadius: BorderRadius.circular(18),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: () {
  openPage(
    context,
    const MKHomeHubScreen(),
  );
},
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold,
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.home_work_outlined,
              color: gold,
              size: 45,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MK HOME HUB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'ALL YOUR PROPERTY NEEDS',
                  style: TextStyle(
                    color: softGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: gold,
            size: 18,
          ),
        ],
      ),
    ),
  ),
), // MK CLIENT

const SizedBox(height: 14),

// GOOGLE REVIEW
Material(
  color: navy,
  borderRadius: BorderRadius.circular(18),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: () async {
      final url = Uri.parse(
        'https://g.page/r/CV6gyzzygwmKEAE/review',
      );

      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(
          url,
          mode: LaunchMode.platformDefault,
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold,
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.reviews_outlined,
              color: gold,
              size: 45,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REVIEW MK KHAIRUL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),

                SizedBox(height: 5),

                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: gold,
                      size: 18,
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: gold,
                      size: 18,
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: gold,
                      size: 18,
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: gold,
                      size: 18,
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: gold,
                      size: 18,
                    ),
                  ],
                ),

                SizedBox(height: 5),

                Text(
                  'Share your experience on Google',
                  style: TextStyle(
                    color: softGold,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: gold,
            size: 18,
          ),
        ],
      ),
    ),
  ),
),

          const SizedBox(height: 22),

          const Center(
            child: Text(
              'SIMPLE. SMART. PROPERTY.',
              style: TextStyle(
                color: softGold,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
              ),
            ),
          ),
                            ],
        ),
      ),
    ),
  ),
);
  }
}

class PremiumToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PremiumToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const navy = Color(0xFF071A2C);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

    @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Responsive sizing:
    // Phone = compact
    // Tablet/Web = larger
    final bool isDesktop = screenWidth >= 900;

    final double iconSize = isDesktop ? 72 : 52;
    final double titleSize = isDesktop ? 18 : 15;
    final double subtitleSize = isDesktop ? 14 : 12;
    final double arrowSize = isDesktop ? 22 : 18;

    return Material(
      color: navy,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 20 : 12,
            vertical: isDesktop ? 18 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: gold,
              width: 1.25,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: gold,
                size: iconSize,
              ),

              SizedBox(
                height: isDesktop ? 22 : 14,
              ),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  height: 1.10,
                  fontWeight: FontWeight.w900,
                ),
              ),

              SizedBox(
                height: isDesktop ? 9 : 6,
              ),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: subtitleSize,
                  height: 1.25,
                ),
              ),

              SizedBox(
                height: isDesktop ? 14 : 9,
              ),

              Icon(
                Icons.arrow_forward_rounded,
                color: softGold,
                size: arrowSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MKClientScreen extends StatelessWidget {
  const MKClientScreen({super.key});

  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MK CLIENT',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Choose Your Needs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Select the option that best matches your property needs.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          MKClientCard(
            icon: Icons.home_work_outlined,
            title: 'OWNER',
            subtitle: 'Sell • Rent Out • Market Value',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OwnerFormScreen(),
                ),
              );
            },
          ),

          MKClientCard(
            icon: Icons.key_outlined,
            title: 'TENANT',
            subtitle: 'Rental Application',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TenantFormScreen(),
                ),
              );
            },
          ),

          MKClientCard(
            icon: Icons.person_search_outlined,
            title: 'BUYER',
            subtitle: 'Property Purchase • Loan Eligibility',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BuyerFormScreen(),
                ),
              );
            },
          ),

          MKClientCard(
            icon: Icons.groups_2_outlined,
            title: 'JOIN US',
            subtitle: 'Join MK Khairul Property Team',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const JoinUsFormScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 22),

          const SizedBox(height: 14),

          const Center(
            child: Text(
              'SIMPLE. SMART. PROPERTY.',
              style: TextStyle(
                color: softGold,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class MKClientCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MKClientCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const navy = Color(0xFF071A2C);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: navy,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gold,
                width: 1.3,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: gold,
                    size: 45,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: softGold,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: gold,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class OwnerFormScreen extends StatefulWidget {
  const OwnerFormScreen({super.key});

  @override
  State<OwnerFormScreen> createState() => _OwnerFormScreenState();
}

class _OwnerFormScreenState extends State<OwnerFormScreen> {
  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);

  String purpose = 'Sell';
  String propertyType = 'Terrace';
  String furnishing = 'Unfurnished';

  final priceController = TextEditingController();
  final ownerNameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final builtUpController = TextEditingController();
  final bedroomController = TextEditingController();
  final bathroomController = TextEditingController();
  final carparkController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    ownerNameController.dispose();
    contactController.dispose();
    addressController.dispose();
    builtUpController.dispose();
    bedroomController.dispose();
    bathroomController.dispose();
    carparkController.dispose();
    super.dispose();
  }

  Future<void> _submitToWhatsApp() async {
    final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

MK CLIENT - OWNER

PURPOSE: $purpose
SELLING PRICE / MONTHLY RENTAL: RM ${priceController.text.trim().isEmpty ? '-' : priceController.text.trim()}
OWNER NAME: ${ownerNameController.text.trim().isEmpty ? '-' : ownerNameController.text.trim()}
CONTACT NO: ${contactController.text.trim().isEmpty ? '-' : contactController.text.trim()}
PROPERTY ADDRESS: ${addressController.text.trim().isEmpty ? '-' : addressController.text.trim()}
PROPERTY TYPE: $propertyType
BUILT UP: ${builtUpController.text.trim().isEmpty ? '-' : builtUpController.text.trim()} sqft
BEDROOM: ${bedroomController.text.trim().isEmpty ? '-' : bedroomController.text.trim()}
BATHROOM: ${bathroomController.text.trim().isEmpty ? '-' : bathroomController.text.trim()}
CARPARK: ${carparkController.text.trim().isEmpty ? '-' : carparkController.text.trim()}
FURNISHING: $furnishing

Boleh bantu saya?
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0x66D4AF37)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: gold,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: navy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'OWNER',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Owner Property Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Fill in your property information and continue directly to MK Khairul.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            initialValue: purpose,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Purpose'),
            items: const [
              DropdownMenuItem(
                value: 'Sell',
                child: Text('Sell'),
              ),
              DropdownMenuItem(
                value: 'Rent Out',
                child: Text('Rent Out'),
              ),
              DropdownMenuItem(
                value: 'Check Market Value',
                child: Text('Check Market Value'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  purpose = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Selling Price / Monthly Rental',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: ownerNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Owner Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: contactController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Contact No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: addressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Property Address'),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: propertyType,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Property Type'),
            items: const [
              DropdownMenuItem(
                value: 'Land',
                child: Text('Land'),
              ),
              DropdownMenuItem(
                value: 'Terrace',
                child: Text('Terrace'),
              ),
              DropdownMenuItem(
                value: 'Townhouse',
                child: Text('Townhouse'),
              ),
              DropdownMenuItem(
                value: 'Semi-D',
                child: Text('Semi-D'),
              ),
              DropdownMenuItem(
                value: 'Bungalow',
                child: Text('Bungalow'),
              ),
              DropdownMenuItem(
                value: 'Shoplot',
                child: Text('Shoplot'),
              ),
              DropdownMenuItem(
                value: 'Apartment',
                child: Text('Apartment'),
              ),
              DropdownMenuItem(
                value: 'Condominium',
                child: Text('Condominium'),
              ),
              DropdownMenuItem(
                value: 'Other',
                child: Text('Other'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  propertyType = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: builtUpController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Built Up sqft'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: bedroomController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Bedroom'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: bathroomController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Bathroom'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: carparkController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Carpark'),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: furnishing,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Furnishing'),
            items: const [
              DropdownMenuItem(
                value: 'Fully Furnished',
                child: Text('Fully Furnished'),
              ),
              DropdownMenuItem(
                value: 'Partly Furnished',
                child: Text('Partly Furnished'),
              ),
              DropdownMenuItem(
                value: 'Unfurnished',
                child: Text('Unfurnished'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  furnishing = value;
                });
              }
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: deepNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitToWhatsApp,
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text(
                'CONTINUE TO WHATSAPP',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Please review your information before sending it to MK Khairul.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
class TenantFormScreen extends StatefulWidget {
  const TenantFormScreen({super.key});

  @override
  State<TenantFormScreen> createState() => _TenantFormScreenState();
}

class _TenantFormScreenState extends State<TenantFormScreen> {
  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);

  String maritalStatus = 'Single';
  String tenancyPeriod = '1 Year';
  bool consent = false;

  final nameController = TextEditingController();
  final icController = TextEditingController();
  final phoneController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final raceController = TextEditingController();
  final religionController = TextEditingController();
  final emailController = TextEditingController();
  final employerController = TextEditingController();
  final employerAddressController = TextEditingController();

  final spouseNameController = TextEditingController();
  final spouseIcController = TextEditingController();
  final spousePhoneController = TextEditingController();
  final spouseEmployerController = TextEditingController();
  final spouseEmployerAddressController = TextEditingController();

  final emergencyNameController = TextEditingController();
  final emergencyIcController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final emergencyRelationshipController = TextEditingController();

  final propertyAddressController = TextEditingController();
  final monthlyRentalController = TextEditingController();
  final tenancyStartDateController = TextEditingController();
  final occupantsController = TextEditingController();
  final intendedUseController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    icController.dispose();
    phoneController.dispose();
    permanentAddressController.dispose();
    raceController.dispose();
    religionController.dispose();
    emailController.dispose();
    employerController.dispose();
    employerAddressController.dispose();

    spouseNameController.dispose();
    spouseIcController.dispose();
    spousePhoneController.dispose();
    spouseEmployerController.dispose();
    spouseEmployerAddressController.dispose();

    emergencyNameController.dispose();
    emergencyIcController.dispose();
    emergencyPhoneController.dispose();
    emergencyRelationshipController.dispose();

    propertyAddressController.dispose();
    monthlyRentalController.dispose();
    tenancyStartDateController.dispose();
    occupantsController.dispose();
    intendedUseController.dispose();
    notesController.dispose();

    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0x66D4AF37),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: gold,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: navy,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: gold,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Future<void> _submitToWhatsApp() async {
    if (!consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please confirm your consent before continuing.',
          ),
        ),
      );
      return;
    }

    final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

MK CLIENT - TENANT

TENANT DETAILS
Name: ${nameController.text.trim().isEmpty ? '-' : nameController.text.trim()}
IC / Passport No.: ${icController.text.trim().isEmpty ? '-' : icController.text.trim()}
Phone No.: ${phoneController.text.trim().isEmpty ? '-' : phoneController.text.trim()}
Permanent Address: ${permanentAddressController.text.trim().isEmpty ? '-' : permanentAddressController.text.trim()}
Marital Status: $maritalStatus
Race: ${raceController.text.trim().isEmpty ? '-' : raceController.text.trim()}
Religion: ${religionController.text.trim().isEmpty ? '-' : religionController.text.trim()}
Email: ${emailController.text.trim().isEmpty ? '-' : emailController.text.trim()}
Employer: ${employerController.text.trim().isEmpty ? '-' : employerController.text.trim()}
Employer Address: ${employerAddressController.text.trim().isEmpty ? '-' : employerAddressController.text.trim()}

SPOUSE DETAILS
Name: ${spouseNameController.text.trim().isEmpty ? '-' : spouseNameController.text.trim()}
IC / Passport No.: ${spouseIcController.text.trim().isEmpty ? '-' : spouseIcController.text.trim()}
Phone No.: ${spousePhoneController.text.trim().isEmpty ? '-' : spousePhoneController.text.trim()}
Employer: ${spouseEmployerController.text.trim().isEmpty ? '-' : spouseEmployerController.text.trim()}
Employer Address: ${spouseEmployerAddressController.text.trim().isEmpty ? '-' : spouseEmployerAddressController.text.trim()}

EMERGENCY CONTACT
Name: ${emergencyNameController.text.trim().isEmpty ? '-' : emergencyNameController.text.trim()}
IC / Passport No.: ${emergencyIcController.text.trim().isEmpty ? '-' : emergencyIcController.text.trim()}
Phone No.: ${emergencyPhoneController.text.trim().isEmpty ? '-' : emergencyPhoneController.text.trim()}
Relationship: ${emergencyRelationshipController.text.trim().isEmpty ? '-' : emergencyRelationshipController.text.trim()}

TENANCY DETAILS
Property Address: ${propertyAddressController.text.trim().isEmpty ? '-' : propertyAddressController.text.trim()}
Monthly Rental: RM ${monthlyRentalController.text.trim().isEmpty ? '-' : monthlyRentalController.text.trim()}
Tenancy Start Date: ${tenancyStartDateController.text.trim().isEmpty ? '-' : tenancyStartDateController.text.trim()}
Tenancy Period: $tenancyPeriod
No. of Occupants: ${occupantsController.text.trim().isEmpty ? '-' : occupantsController.text.trim()}
Intended Use: ${intendedUseController.text.trim().isEmpty ? '-' : intendedUseController.text.trim()}
Additional Notes: ${notesController.text.trim().isEmpty ? '-' : notesController.text.trim()}

I consent to providing these details to MK Khairul for tenancy application and tenancy agreement preparation.

Thank you.
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'TENANT',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Tenant & Tenancy Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Complete the details below for rental application and tenancy agreement preparation.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          _sectionTitle('TENANT DETAILS'),

          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Full Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: icController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('IC / Passport No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: permanentAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Permanent Address'),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: maritalStatus,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Marital Status'),
            items: const [
              DropdownMenuItem(
                value: 'Single',
                child: Text('Single'),
              ),
              DropdownMenuItem(
                value: 'Married',
                child: Text('Married'),
              ),
              DropdownMenuItem(
                value: 'Divorced',
                child: Text('Divorced'),
              ),
              DropdownMenuItem(
                value: 'Widowed',
                child: Text('Widowed'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  maritalStatus = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: raceController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Race'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: religionController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Religion'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Email'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: employerController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Employer Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: employerAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Employer Address'),
          ),

          const SizedBox(height: 18),

          _sectionTitle('SPOUSE DETAILS'),

          TextField(
            controller: spouseNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spouseIcController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse IC / Passport No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spousePhoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spouseEmployerController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Employer'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spouseEmployerAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Employer Address'),
          ),

          const SizedBox(height: 18),

          _sectionTitle('EMERGENCY CONTACT'),

          TextField(
            controller: emergencyNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emergencyIcController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('IC / Passport No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emergencyPhoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emergencyRelationshipController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Relationship'),
          ),

          const SizedBox(height: 18),

          _sectionTitle('TENANCY DETAILS'),

          TextField(
            controller: propertyAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Property Address'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: monthlyRentalController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Monthly Rental'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: tenancyStartDateController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Tenancy Start Date',
            ),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: tenancyPeriod,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Tenancy Period'),
            items: const [
              DropdownMenuItem(
                value: '1 Year',
                child: Text('1 Year'),
              ),
              DropdownMenuItem(
                value: '2 Years',
                child: Text('2 Years'),
              ),
              DropdownMenuItem(
                value: '3 Years',
                child: Text('3 Years'),
              ),
              DropdownMenuItem(
                value: 'Other',
                child: Text('Other'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  tenancyPeriod = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: occupantsController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Number of Occupants',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: intendedUseController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Intended Use',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: notesController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Additional Notes',
            ),
          ),

          const SizedBox(height: 18),

          CheckboxListTile(
            value: consent,
            activeColor: gold,
            checkColor: deepNavy,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'I consent to providing these details to MK Khairul for tenancy application and tenancy agreement preparation.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            onChanged: (value) {
              setState(() {
                consent = value ?? false;
              });
            },
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: deepNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitToWhatsApp,
              icon: const Icon(
                Icons.chat_bubble_outline,
              ),
              label: const Text(
                'CONTINUE TO WHATSAPP',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Please review your information carefully before sending.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
class BuyerFormScreen extends StatefulWidget {
  const BuyerFormScreen({super.key});

  @override
  State<BuyerFormScreen> createState() => _BuyerFormScreenState();
}

class _BuyerFormScreenState extends State<BuyerFormScreen> {
  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);

  String maritalStatus = 'Single';
  String applicationType = 'Individual';
  String depositReady = 'No';
  String ccrisCtosConsent = 'No';
  bool privacyConsent = false;

  // APPLICANT
  final nameController = TextEditingController();
  final icController = TextEditingController();
  final phoneController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final currentAddressController = TextEditingController();
  final dependantsController = TextEditingController();
  final raceController = TextEditingController();
  final religionController = TextEditingController();
  final residenceTypeController = TextEditingController();
  final residencePeriodController = TextEditingController();
  final educationController = TextEditingController();
  final emailController = TextEditingController();
  final motherNameController = TextEditingController();

  // SPOUSE
  final spouseNameController = TextEditingController();
  final spouseIcController = TextEditingController();
  final spousePositionController = TextEditingController();
  final spouseEmployerController = TextEditingController();
  final spousePhoneController = TextEditingController();
  final spouseSalaryController = TextEditingController();

  // EMPLOYMENT
  final employerController = TextEditingController();
  final employerAddressController = TextEditingController();
  final positionController = TextEditingController();
  final officePhoneController = TextEditingController();
  final employmentStartController = TextEditingController();

  // CLOSEST RELATIVE
  final relativeNameController = TextEditingController();
  final relativeAddressController = TextEditingController();
  final relativePhoneController = TextEditingController();
  final relativeRelationshipController = TextEditingController();

  // LOAN ELIGIBILITY
  final occupationController = TextEditingController();
  final companyController = TextEditingController();

  final grossSalaryController = TextEditingController();
  final netSalaryController = TextEditingController();
  final otherIncomeController = TextEditingController();
  final epfAccount2Controller = TextEditingController();

  final personalLoanController = TextEditingController();
  final carLoanController = TextEditingController();
  final ptptnController = TextEditingController();
  final housingLoanController = TextEditingController();
  final otherLoanController = TextEditingController();
  final asbLoanController = TextEditingController();
  final creditCardLimitController = TextEditingController();
  final cashOnHandController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    icController.dispose();
    phoneController.dispose();
    permanentAddressController.dispose();
    currentAddressController.dispose();
    dependantsController.dispose();
    raceController.dispose();
    religionController.dispose();
    residenceTypeController.dispose();
    residencePeriodController.dispose();
    educationController.dispose();
    emailController.dispose();
    motherNameController.dispose();

    spouseNameController.dispose();
    spouseIcController.dispose();
    spousePositionController.dispose();
    spouseEmployerController.dispose();
    spousePhoneController.dispose();
    spouseSalaryController.dispose();

    employerController.dispose();
    employerAddressController.dispose();
    positionController.dispose();
    officePhoneController.dispose();
    employmentStartController.dispose();

    relativeNameController.dispose();
    relativeAddressController.dispose();
    relativePhoneController.dispose();
    relativeRelationshipController.dispose();

    occupationController.dispose();
    companyController.dispose();
    grossSalaryController.dispose();
    netSalaryController.dispose();
    otherIncomeController.dispose();
    epfAccount2Controller.dispose();

    personalLoanController.dispose();
    carLoanController.dispose();
    ptptnController.dispose();
    housingLoanController.dispose();
    otherLoanController.dispose();
    asbLoanController.dispose();
    creditCardLimitController.dispose();
    cashOnHandController.dispose();

    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0x66D4AF37),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: gold,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: navy,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: gold,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  String _text(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? '-' : value;
  }

  Future<void> _submitToWhatsApp() async {
    if (!privacyConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please confirm your consent before continuing.',
          ),
        ),
      );
      return;
    }

    final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

MK CLIENT - BUYER

APPLICANT DETAILS
Name: ${_text(nameController)}
IC / Passport No.: ${_text(icController)}
Phone No.: ${_text(phoneController)}
Permanent Address: ${_text(permanentAddressController)}
Current Address: ${_text(currentAddressController)}
No. of Dependants: ${_text(dependantsController)}
Marital Status: $maritalStatus
Race: ${_text(raceController)}
Religion: ${_text(religionController)}
Residence Type: ${_text(residenceTypeController)}
Residence Period: ${_text(residencePeriodController)}
Education Background: ${_text(educationController)}
Email: ${_text(emailController)}
Mother's Name: ${_text(motherNameController)}

SPOUSE DETAILS
Name: ${_text(spouseNameController)}
IC / Passport No.: ${_text(spouseIcController)}
Position: ${_text(spousePositionController)}
Employer: ${_text(spouseEmployerController)}
Phone No.: ${_text(spousePhoneController)}
Salary: RM ${_text(spouseSalaryController)}

EMPLOYMENT DETAILS
Employer: ${_text(employerController)}
Employer Address: ${_text(employerAddressController)}
Position: ${_text(positionController)}
Office Phone: ${_text(officePhoneController)}
Employment Start Date: ${_text(employmentStartController)}

CLOSEST RELATIVE
Name: ${_text(relativeNameController)}
Address: ${_text(relativeAddressController)}
Phone No.: ${_text(relativePhoneController)}
Relationship: ${_text(relativeRelationshipController)}

LOAN ELIGIBILITY DETAILS
Occupation: ${_text(occupationController)}
Company / Employer: ${_text(companyController)}

INCOME
Gross Salary: RM ${_text(grossSalaryController)}
Net Salary: RM ${_text(netSalaryController)}
Other Income / Commission: RM ${_text(otherIncomeController)}
EPF Account 2: RM ${_text(epfAccount2Controller)}

MONTHLY COMMITMENTS
Personal Loan: RM ${_text(personalLoanController)}
Car Loan: RM ${_text(carLoanController)}
PTPTN: RM ${_text(ptptnController)}
Housing Loan: RM ${_text(housingLoanController)}
Other Loan: RM ${_text(otherLoanController)}
ASB Financing: RM ${_text(asbLoanController)}
Credit Card Maximum Limit: RM ${_text(creditCardLimitController)}

Application Type: $applicationType
10% Deposit Ready: $depositReady
Cash on Hand: RM ${_text(cashOnHandController)}

CCRIS / CTOS RECORD CHECK CONSENT: $ccrisCtosConsent

I consent to providing the information above to MK Khairul for property purchase and preliminary financing consultation.

Thank you.
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'BUYER',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Buyer & Loan Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Complete your details to help MK Khairul understand your property and financing needs.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          // APPLICANT
          _sectionTitle('APPLICANT DETAILS'),

          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Full Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: icController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('IC / Passport No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: permanentAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Permanent Address'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: currentAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Current Address'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: dependantsController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('No. of Dependants'),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: maritalStatus,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Marital Status'),
            items: const [
              DropdownMenuItem(
                value: 'Single',
                child: Text('Single'),
              ),
              DropdownMenuItem(
                value: 'Married',
                child: Text('Married'),
              ),
              DropdownMenuItem(
                value: 'Divorced',
                child: Text('Divorced'),
              ),
              DropdownMenuItem(
                value: 'Widowed',
                child: Text('Widowed'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  maritalStatus = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: raceController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Race'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: religionController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Religion'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: residenceTypeController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Residence Type'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: residencePeriodController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Residence Period'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: educationController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Education Background'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Email'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: motherNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration("Mother's Name"),
          ),

          const SizedBox(height: 18),

          // SPOUSE
          _sectionTitle('SPOUSE DETAILS'),

          TextField(
            controller: spouseNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spouseIcController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse IC / Passport No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spousePositionController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Position'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spouseEmployerController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Spouse Employer / Employer Address',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spousePhoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: spouseSalaryController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Spouse Salary'),
          ),

          const SizedBox(height: 18),

          // EMPLOYMENT
          _sectionTitle('APPLICANT EMPLOYMENT'),

          TextField(
            controller: employerController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Employer'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: employerAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Employer Address'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: positionController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Position'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: officePhoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Office Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: employmentStartController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Employment Start Date'),
          ),

          const SizedBox(height: 18),

          // RELATIVE
          _sectionTitle('CLOSEST RELATIVE'),

          TextField(
            controller: relativeNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: relativeAddressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Address'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: relativePhoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: relativeRelationshipController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Relationship'),
          ),

          const SizedBox(height: 18),

          // LOAN
          _sectionTitle('CHECK YOUR LOAN ELIGIBILITY'),

          TextField(
            controller: occupationController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Occupation'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: companyController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Company / Employer'),
          ),

          const SizedBox(height: 18),

          _sectionTitle('INCOME'),

          TextField(
            controller: grossSalaryController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Gross Salary'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: netSalaryController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Net Salary'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: otherIncomeController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Other Income / Commission',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: epfAccount2Controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('EPF Account 2'),
          ),

          const SizedBox(height: 18),

          _sectionTitle('MONTHLY COMMITMENTS'),

          TextField(
            controller: personalLoanController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Personal Loan'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: carLoanController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Car Loan'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: ptptnController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('PTPTN'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: housingLoanController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Housing Loan'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: otherLoanController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Other Loan'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: asbLoanController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('ASB Financing'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: creditCardLimitController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Credit Card Maximum Limit',
            ),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            initialValue: applicationType,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Application Type'),
            items: const [
              DropdownMenuItem(
                value: 'Individual',
                child: Text('Individual'),
              ),
              DropdownMenuItem(
                value: 'Joint',
                child: Text('Joint'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  applicationType = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: depositReady,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              '10% Cash Deposit Ready?',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Yes',
                child: Text('Yes'),
              ),
              DropdownMenuItem(
                value: 'No',
                child: Text('No'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  depositReady = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: cashOnHandController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Cash on Hand'),
          ),

          const SizedBox(height: 18),

          _sectionTitle('CCRIS / CTOS'),

          DropdownButtonFormField<String>(
            initialValue: ccrisCtosConsent,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Consent for CCRIS / CTOS Record Check',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Yes',
                child: Text('Yes'),
              ),
              DropdownMenuItem(
                value: 'No',
                child: Text('No'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  ccrisCtosConsent = value;
                });
              }
            },
          ),

          const SizedBox(height: 18),

          CheckboxListTile(
            value: privacyConsent,
            activeColor: gold,
            checkColor: deepNavy,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'I consent to providing these details to MK Khairul for property purchase and preliminary financing consultation.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            onChanged: (value) {
              setState(() {
                privacyConsent = value ?? false;
              });
            },
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: deepNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitToWhatsApp,
              icon: const Icon(
                Icons.chat_bubble_outline,
              ),
              label: const Text(
                'CONTINUE TO WHATSAPP',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Please review your information carefully before sending. Do not include passwords, OTPs or banking credentials.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
class JoinUsFormScreen extends StatefulWidget {
  const JoinUsFormScreen({super.key});

  @override
  State<JoinUsFormScreen> createState() => _JoinUsFormScreenState();
}

class _JoinUsFormScreenState extends State<JoinUsFormScreen> {
  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);

  String workType = 'Part-Time';
  String propertyExperience = 'No';
  String ownTransport = 'Yes';
  String preferredStart = 'Immediately';

  bool consent = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final currentJobController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    currentJobController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0x66D4AF37),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: gold,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: navy,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: gold,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  String _text(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? '-' : value;
  }

  Future<void> _submitToWhatsApp() async {
    if (!consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please confirm your consent before continuing.',
          ),
        ),
      );
      return;
    }

    final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

MK CLIENT - JOIN US

APPLICANT DETAILS

Full Name: ${_text(nameController)}
Phone No.: ${_text(phoneController)}
Email: ${_text(emailController)}
Location: ${_text(locationController)}
Current Job: ${_text(currentJobController)}

Preferred Work Type: $workType
Property Experience: $propertyExperience
Own Transport: $ownTransport
Preferred Start: $preferredStart

WHY I WANT TO JOIN
${_text(reasonController)}

I consent to providing these details to MK Khairul for property team recruitment purposes.

Thank you.
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'JOIN US',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Join MK Khairul',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Interested in building your property career? Tell us a little about yourself.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          _sectionTitle('PERSONAL DETAILS'),

          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Full Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Phone No.'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Email'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: locationController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Current Location',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: currentJobController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Current Job / Occupation',
            ),
          ),

          const SizedBox(height: 18),

          _sectionTitle('WORK PREFERENCE'),

          DropdownButtonFormField<String>(
            initialValue: workType,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Part-Time / Full-Time',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Part-Time',
                child: Text('Part-Time'),
              ),
              DropdownMenuItem(
                value: 'Full-Time',
                child: Text('Full-Time'),
              ),
              DropdownMenuItem(
                value: 'Open to Both',
                child: Text('Open to Both'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  workType = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: propertyExperience,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Property Experience',
            ),
            items: const [
              DropdownMenuItem(
                value: 'No',
                child: Text('No Experience'),
              ),
              DropdownMenuItem(
                value: 'Yes',
                child: Text('Yes, I Have Experience'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  propertyExperience = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: ownTransport,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Own Transport',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Yes',
                child: Text('Yes'),
              ),
              DropdownMenuItem(
                value: 'No',
                child: Text('No'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  ownTransport = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            initialValue: preferredStart,
            dropdownColor: navy,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Preferred Start',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Immediately',
                child: Text('Immediately'),
              ),
              DropdownMenuItem(
                value: 'This Month',
                child: Text('This Month'),
              ),
              DropdownMenuItem(
                value: 'Later',
                child: Text('Later'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  preferredStart = value;
                });
              }
            },
          ),

          const SizedBox(height: 18),

          _sectionTitle('TELL US ABOUT YOURSELF'),

          TextField(
            controller: reasonController,
            maxLines: 5,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: _fieldDecoration(
              'Why do you want to join?',
            ),
          ),

          const SizedBox(height: 18),

          CheckboxListTile(
            value: consent,
            activeColor: gold,
            checkColor: deepNavy,
            contentPadding: EdgeInsets.zero,
            controlAffinity:
                ListTileControlAffinity.leading,
            title: const Text(
              'I consent to providing these details to MK Khairul for property team recruitment purposes.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            onChanged: (value) {
              setState(() {
                consent = value ?? false;
              });
            },
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: deepNavy,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitToWhatsApp,
              icon: const Icon(
                Icons.chat_bubble_outline,
              ),
              label: const Text(
                'CONTINUE TO WHATSAPP',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Please review your information before sending.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
class PropertyListingScreen extends StatefulWidget {
  const PropertyListingScreen({super.key});

  @override
  State<PropertyListingScreen> createState() =>
      _PropertyListingScreenState();
}

class _PropertyListingScreenState
    extends State<PropertyListingScreen> {
  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  final searchController = TextEditingController();
  final String listingApiUrl =
    'https://script.google.com/macros/s/AKfycbyKKrioq22adrb2wpdad3wj6CedlqhLzEomOCkR-AdXcjU75M9pNTTySz5xYBEqN8gb/exec';

List<dynamic> listings = [];

bool isLoading = true;

String? loadError;

String selectedPurpose = 'BUY';

String selectedLocation = 'All Malaysia';

String selectedPropertyType = 'All Property Types';

final List<String> locations = const [
  'All Malaysia',
  'Kuala Lumpur',
  'Putrajaya',
  'Selangor',
  'Perak',
  'Johor',
  'Kedah',
  'Kelantan',
  'Melaka',
  'Negeri Sembilan',
  'Pahang',
  'Penang',
  'Perlis',
  'Terengganu',
  'Sabah',
  'Sarawak',
  'Labuan',
];

final List<String> propertyTypes = const [
  'All Property Types',
  'Residential',
  'Factory',
  'Commercial',
  'Land',
  'Shoplot',
];

@override
void initState() {
  super.initState();
  _loadListings();
}

Future<void> _loadListings() async {
  try {
    setState(() {
      isLoading = true;
      loadError = null;
    });

    final response = await http.get(
      Uri.parse(listingApiUrl),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Server error: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(
        data['error'] ?? 'Unable to load listings.',
      );
    }

    setState(() {
      listings = data['listings'] ?? [];
      isLoading = false;
    });

    debugPrint(
      'PROPERTY LISTINGS LOADED: ${listings.length}',
    );
  } catch (e) {
    setState(() {
      loadError = e.toString();
      isLoading = false;
    });

    debugPrint(
      'PROPERTY LISTING ERROR: $e',
    );
  }
}

String _field(
  Map<String, dynamic> item,
  String key,
) {
  final value = item[key];

  if (value == null) return '';

  return value.toString().trim();
}

double _number(dynamic value) {
  if (value == null) return 0;

  if (value is num) {
    return value.toDouble();
  }

  final cleaned = value
      .toString()
      .replaceAll('RM', '')
      .replaceAll(',', '')
      .trim();

  return double.tryParse(cleaned) ?? 0;
}

String _formatMoney(dynamic value) {
  final number = _number(value).round();

  final text = number.toString();

  return text.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},',
  );
}

String _publicListingPrice(
  Map<String, dynamic> item,
) {
  final raw = _field(item, 'Listing Price');

  if (raw.isNotEmpty) {
    final compact = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    final numericMatch = RegExp(
      r'^RM\s*([0-9,]+(?:\.[0-9]+)?)$',
      caseSensitive: false,
    ).firstMatch(compact);

    if (numericMatch != null) {
      final numericValue = double.tryParse(
        numericMatch.group(1)!.replaceAll(',', ''),
      );

      if (numericValue != null) {
        return 'RM ${_formatMoney(numericValue)}';
      }
    }

    return compact;
  }

  final currentPrice = _number(item['Current Price']);

  if (currentPrice > 0) {
    return 'RM ${_formatMoney(currentPrice)}';
  }

  return 'PRICE ON REQUEST';
}

bool _usesMaskedPublicPrice(
  Map<String, dynamic> item,
) {
  final category =
      _field(item, 'Listing Category').toUpperCase();
  final publicPrice =
      _field(item, 'Listing Price').toUpperCase();

  return category.startsWith('NEW') ||
      publicPrice.contains('XX') ||
      publicPrice.contains('FROM');
}

List<Map<String, dynamic>> get filteredListings {
  final query =
      searchController.text.trim().toLowerCase();

  final result = <Map<String, dynamic>>[];

  for (final raw in listings) {
    if (raw is! Map) continue;

    final item =
        Map<String, dynamic>.from(raw);

    final purpose =
        _field(item, 'Purpose').toUpperCase();

    final state =
        _field(item, 'State');

    final propertyType =
        _field(item, 'Property Type');

    if (purpose != selectedPurpose) {
      continue;
    }

    if (selectedLocation != 'All Malaysia' &&
        state.toLowerCase() !=
            selectedLocation.toLowerCase()) {
      continue;
    }

    if (selectedPropertyType !=
            'All Property Types' &&
        propertyType.toLowerCase() !=
            selectedPropertyType.toLowerCase()) {
      continue;
    }

    if (query.isNotEmpty) {
      final searchableText = [
        _field(item, 'ID'),
        _field(item, 'Title'),
        _field(item, 'State'),
        _field(item, 'Location'),
        _field(item, 'Property Type'),
        _field(item, 'Description'),
      ].join(' ').toLowerCase();

      if (!searchableText.contains(query)) {
        continue;
      }
    }

    result.add(item);
  }

  return result;
}

Widget _buildListingCard(
  Map<String, dynamic> item,
) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final bool isDesktop = screenWidth >= 900;

  final title = _field(item, 'Title');
  final location = _field(item, 'Location');
  final state = _field(item, 'State');
  final propertyType =
      _field(item, 'Property Type');

  final status =
      _field(item, 'Status').toUpperCase();

  final priceTag =
      _field(item, 'Price Tag').toUpperCase();

  final imageUrl =
      _field(item, 'Image1');

  final originalPrice =
      _number(item['Original Price']);

  final currentPrice =
      _number(item['Current Price']);

  final displayPrice =
      _publicListingPrice(item);

  final usesMaskedPublicPrice =
      _usesMaskedPublicPrice(item);

  final hasReduction =
      !usesMaskedPublicPrice &&
      originalPrice > currentPrice &&
      currentPrice > 0;

  final saving = hasReduction
      ? originalPrice - currentPrice
      : 0;

  return Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: BorderRadius.circular(
      isDesktop ? 20 : 16,
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PropertyDetailScreen(
            property: item,
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
      color: navy,
      borderRadius: BorderRadius.circular(
        isDesktop ? 20 : 16,
      ),
      border: Border.all(
        color: const Color(0x66D4AF37),
        width: 1.2,
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PROPERTY IMAGE
        AspectRatio(
          aspectRatio: isDesktop ? 16 / 10 : 4 / 3,
          child: PropertyImageWithWatermark(
            imageUrl: imageUrl,
            watermarkFontSize:
                isDesktop ? 12 : 8,
          ),
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(
              isDesktop ? 18 : 10,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // STATUS
                Wrap(
                  spacing: isDesktop ? 8 : 5,
                  runSpacing: 5,
                  children: [
                    if (status.isNotEmpty)
                      Container(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal:
                              isDesktop ? 10 : 7,
                          vertical:
                              isDesktop ? 6 : 4,
                        ),
                        decoration:
                            BoxDecoration(
                          color: gold.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          border: Border.all(
                            color: gold,
                          ),
                        ),
                        child: Text(
                          status,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: softGold,
                            fontSize:
                                isDesktop ? 11 : 8,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),

                    if (priceTag.isNotEmpty)
                      Container(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal:
                              isDesktop ? 10 : 7,
                          vertical:
                              isDesktop ? 6 : 4,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white10,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Text(
                          priceTag,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                isDesktop ? 11 : 8,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(
                  height: isDesktop ? 12 : 7,
                ),

                if (hasReduction)
                  Text(
                    'RM ${_formatMoney(originalPrice)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize:
                          isDesktop ? 15 : 10,
                      decoration:
                          TextDecoration.lineThrough,
                      decorationColor:
                          Colors.white54,
                    ),
                  ),

                if (hasReduction)
                  const SizedBox(height: 2),

                // PRICE
                Text(
                  displayPrice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: softGold,
                    fontSize:
                        isDesktop ? 24 : 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                if (hasReduction) ...[
                  SizedBox(
                    height: isDesktop ? 5 : 2,
                  ),
                  Text(
                    'SAVE RM ${_formatMoney(saving)}',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          isDesktop ? 12 : 8,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],

                SizedBox(
                  height: isDesktop ? 12 : 7,
                ),

                // TITLE
                Text(
                  title.isEmpty
                      ? 'PROPERTY'
                      : title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        isDesktop ? 18 : 12,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),

                SizedBox(
                  height: isDesktop ? 8 : 5,
                ),

                // LOCATION
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: gold,
                      size: isDesktop ? 18 : 13,
                    ),

                    SizedBox(
                      width: isDesktop ? 6 : 3,
                    ),

                    Expanded(
                      child: Text(
                        [
                          location,
                          state,
                        ]
                            .where(
                              (value) =>
                                  value.isNotEmpty,
                            )
                            .join(', '),
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize:
                              isDesktop ? 13 : 9,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),

                if (propertyType.isNotEmpty) ...[
                  SizedBox(
                    height: isDesktop ? 8 : 5,
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        color: gold,
                        size:
                            isDesktop ? 18 : 13,
                      ),

                      SizedBox(
                        width:
                            isDesktop ? 6 : 3,
                      ),

                      Expanded(
                        child: Text(
                          propertyType,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                Colors.white70,
                            fontSize:
                                isDesktop
                                    ? 13
                                    : 9,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),
);
}

@override
void dispose() {
  searchController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'PROPERTY LISTING',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: RefreshIndicator(
  color: gold,
  backgroundColor: navy,
  onRefresh: _loadListings,
  child: ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(20),
    children: [
          const Text(
            'Find Your Property',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
  'Browse properties for sale and rent.',
  style: TextStyle(
    color: Colors.white60,
    fontSize: 14,
  ),
),

const SizedBox(height: 22),

// BUY / RENT
Row(
  children: [
    Expanded(
      child: ChoiceChip(
        label: const SizedBox(
          width: double.infinity,
          child: Text(
            'BUY',
            textAlign: TextAlign.center,
          ),
        ),
        selected: selectedPurpose == 'BUY',
        onSelected: (_) {
          setState(() {
            selectedPurpose = 'BUY';
          });
        },
        backgroundColor: navy,
        selectedColor: gold,
        side: BorderSide(
          color: selectedPurpose == 'BUY'
              ? gold
              : const Color(0x66D4AF37),
        ),
        labelStyle: TextStyle(
          color: selectedPurpose == 'BUY'
              ? deepNavy
              : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: ChoiceChip(
        label: const SizedBox(
          width: double.infinity,
          child: Text(
            'RENT',
            textAlign: TextAlign.center,
          ),
        ),
        selected: selectedPurpose == 'RENT',
        onSelected: (_) {
          setState(() {
            selectedPurpose = 'RENT';
          });
        },
        backgroundColor: navy,
        selectedColor: gold,
        side: BorderSide(
          color: selectedPurpose == 'RENT'
              ? gold
              : const Color(0x66D4AF37),
        ),
        labelStyle: TextStyle(
          color: selectedPurpose == 'RENT'
              ? deepNavy
              : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 16),

// SEARCH
TextField(
  controller: searchController,
  style: const TextStyle(
    color: Colors.white,
  ),
  onChanged: (_) {
    setState(() {});
  },
  decoration: InputDecoration(
    hintText:
        'Search Location, Property or Keyword...',
    hintStyle: const TextStyle(
      color: Colors.white38,
    ),
    prefixIcon: const Icon(
      Icons.search_rounded,
      color: gold,
      size: 28,
    ),
    suffixIcon: searchController.text.isNotEmpty
        ? IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white54,
            ),
          )
        : null,
    filled: true,
    fillColor: navy,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0x66D4AF37),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: gold,
        width: 1.5,
      ),
    ),
  ),
),

const SizedBox(height: 16),

// LOCATION + PROPERTY TYPE
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: DropdownButtonFormField<String>(
        initialValue: selectedLocation,
        dropdownColor: navy,
        isExpanded: true,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: 'LOCATION',
          labelStyle: const TextStyle(
            color: softGold,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: gold,
          ),
          filled: true,
          fillColor: navy,
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0x66D4AF37),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: gold,
              width: 1.5,
            ),
          ),
        ),
        items: locations.map((location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(
              location,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedLocation = value;
            });
          }
        },
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: DropdownButtonFormField<String>(
        initialValue: selectedPropertyType,
        dropdownColor: navy,
        isExpanded: true,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: 'PROPERTY TYPE',
          labelStyle: const TextStyle(
            color: softGold,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          prefixIcon: const Icon(
            Icons.home_work_outlined,
            color: gold,
          ),
          filled: true,
          fillColor: navy,
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0x66D4AF37),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: gold,
              width: 1.5,
            ),
          ),
        ),
        items: propertyTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(
              type,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedPropertyType = value;
            });
          }
        },
      ),
    ),
  ],
),

const SizedBox(height: 28),

if (isLoading)
  Container(
    padding: const EdgeInsets.symmetric(
      vertical: 45,
    ),
    child: const Column(
      children: [
        CircularProgressIndicator(
          color: gold,
        ),
        SizedBox(height: 16),
        Text(
          'Loading latest properties...',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13,
          ),
        ),
      ],
    ),
  )
else if (loadError != null)
  Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: navy,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color(0x66D4AF37),
      ),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.wifi_off_rounded,
          color: gold,
          size: 50,
        ),

        const SizedBox(height: 14),

        const Text(
          'Unable to load properties',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 14),

        OutlinedButton.icon(
          onPressed: _loadListings,
          icon: const Icon(
            Icons.refresh_rounded,
          ),
          label: const Text('TRY AGAIN'),
        ),
      ],
    ),
  )
else if (filteredListings.isEmpty)
  Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 40,
    ),
    decoration: BoxDecoration(
      color: navy,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color(0x55D4AF37),
      ),
    ),
    child: const Column(
      children: [
        Icon(
          Icons.search_off_rounded,
          color: gold,
          size: 60,
        ),

        SizedBox(height: 16),

        Text(
          'NO PROPERTY FOUND',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),

        SizedBox(height: 8),

        Text(
          'Try another location or property type.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13,
          ),
        ),
      ],
    ),
  )
else ...[
  Text(
    '${filteredListings.length} PROPERTIES FOUND',
    style: const TextStyle(
      color: softGold,
      fontSize: 13,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.7,
    ),
  ),

  const SizedBox(height: 14),

  LayoutBuilder(
  builder: (context, constraints) {
    final double width = constraints.maxWidth;

    // PHONE = 2 cards
// WEB / DESKTOP = 5 cards
final int columns = width >= 900 ? 5 : 2;

final double spacing = width >= 900 ? 14 : 10;

return GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: filteredListings.length,

  gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: spacing,

    // Taller card for property information
    childAspectRatio: width >= 900 ? 0.58 : 0.62,
  ),

      itemBuilder: (context, index) {
        final listing = filteredListings[index];

        return _buildListingCard(listing);
      },
    );
  },
),
],

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'SIMPLE. SMART. PROPERTY.',
              style: TextStyle(
                color: softGold,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
             ],
    ),
  ),
);
}
  }

class PropertyImageWithWatermark extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double watermarkFontSize;

  const PropertyImageWithWatermark({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.watermarkFontSize = 13,
  });

  static const gold = Color(0xFFD4AF37);
  static const deepNavy = Color(0xFF03111E);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // PROPERTY IMAGE
        imageUrl.trim().isNotEmpty
            ? Image.network(
                imageUrl.trim(),
                fit: fit,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: deepNavy,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: gold,
                        size: 55,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: deepNavy,
                child: const Center(
                  child: Icon(
                    Icons.real_estate_agent_outlined,
                    color: gold,
                    size: 60,
                  ),
                ),
              ),

        // WATERMARK
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.45,
              ),
              borderRadius: BorderRadius.circular(
                8,
              ),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
            child: Text(
              'MK KHAIRUL',
              style: TextStyle(
                color: Colors.white.withValues(
                  alpha: 0.88,
                ),
                fontSize: watermarkFontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                shadows: const [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  String _field(String key) {
    final value = property[key];

    if (value == null) return '';

    return value.toString().trim();
  }

  double _number(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    final cleaned = value
        .toString()
        .replaceAll('RM', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(cleaned) ?? 0;
  }

  String _formatMoney(dynamic value) {
    final number = _number(value).round();

    final text = number.toString();

    return text.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  String _publicListingPrice() {
    final raw = _field('Listing Price');

    if (raw.isNotEmpty) {
      final compact = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
      final numericMatch = RegExp(
        r'^RM\s*([0-9,]+(?:\.[0-9]+)?)$',
        caseSensitive: false,
      ).firstMatch(compact);

      if (numericMatch != null) {
        final numericValue = double.tryParse(
          numericMatch.group(1)!.replaceAll(',', ''),
        );

        if (numericValue != null) {
          return 'RM ${_formatMoney(numericValue)}';
        }
      }

      return compact;
    }

    final currentPrice =
        _number(property['Current Price']);

    if (currentPrice > 0) {
      return 'RM ${_formatMoney(currentPrice)}';
    }

    return 'PRICE ON REQUEST';
  }

  bool _usesMaskedPublicPrice() {
    final category =
        _field('Listing Category').toUpperCase();
    final publicPrice =
        _field('Listing Price').toUpperCase();

    return category.startsWith('NEW') ||
        publicPrice.contains('XX') ||
        publicPrice.contains('FROM');
  }

  List<String> get images {
    final result = <String>[];

    for (int i = 1; i <= 10; i++) {
      final url = _field('Image$i');

      if (url.isNotEmpty) {
        result.add(url);
      }
    }

    return result;
  }

  Widget _detailRow(
  BuildContext context,
  String label,
  String value,
) {
  if (value.trim().isEmpty ||
      value.trim() == '-') {
    return const SizedBox.shrink();
  }

  final double screenWidth =
      MediaQuery.sizeOf(context).width;

  final bool isWebDesktop =
      kIsWeb && screenWidth >= 900;

  final bool isWebMobile =
      kIsWeb && screenWidth < 900;

  // =====================================
  // WEB DESKTOP
  // =====================================
  if (isWebDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 165,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 18),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // WEB MOBILE
  // =====================================
  if (isWebMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // ANDROID APP - KEKALKAN ASAL
  // =====================================
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 7,
    ),
    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
}

  Future<void> _contactMKKhairul() async {
    final id = _field('ID');
    final title = _field('Title');
    final location = _field('Location');

    final sheetMessage =
        _field('WhatsApp Message');

    final message = sheetMessage.isNotEmpty
        ? sheetMessage
        : '''
Hi MK Khairul,

Saya berminat dengan property ini:

PROPERTY ID: ${id.isEmpty ? '-' : id}
PROPERTY: ${title.isEmpty ? '-' : title}
LOCATION: ${location.isEmpty ? '-' : location}

Boleh bantu saya?
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );
    }
  }

Future<void> _shareProperty(
  BuildContext context,
) async {
  final id = _field('ID');
  final title = _field('Title');
  final location = _field('Location');
  final state = _field('State');

  final displayPrice =
      _publicListingPrice();

  const whatsappLink =
      'https://wa.me/601153599092';

  const appDownloadLink =
      'https://github.com/Mkkhairul/mk-khairul-property-tools/releases/download/v1.0.0-beta/MK-Khairul-property-Tools.apk';
  
  final propertyLink =
    'https://mk-khairul-property-tools.pages.dev/property/${Uri.encodeComponent(id)}';

  final message = '''
🏡 ${title.isEmpty ? 'PROPERTY FOR SALE / RENT' : title}

💰 $displayPrice
📍 ${[
    location,
    state,
  ].where((value) => value.isNotEmpty).join(', ')}
🆔 Property ID: ${id.isEmpty ? '-' : id}

📲 WhatsApp MK Khairul:
$whatsappLink

📱 Download MK KHAIRUL Property Tools:
$appDownloadLink

🔗 VIEW PROPERTY:
$propertyLink

MK KHAIRUL
SIMPLE. SMART. PROPERTY.
''';

  if (kIsWeb) {
  await Clipboard.setData(
    ClipboardData(text: message),
  );

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Property details copied! You can now paste and share it.',
      ),
    ),
  );

  return;
}

final box =
    context.findRenderObject() as RenderBox?;

await SharePlus.instance.share(
  ShareParams(
    text: message,
    subject: title.isEmpty
        ? 'MK KHAIRUL Property'
        : title,
    sharePositionOrigin:
        box == null
            ? null
            : box.localToGlobal(
                  Offset.zero,
                ) &
                box.size,
  ),
);
}

  @override
  Widget build(BuildContext context) {
    final title = _field('Title');
    final id = _field('ID');
    final status = _field('Status');
    final priceTag = _field('Price Tag');

    final location = _field('Location');
    final state = _field('State');
    final propertyType =
        _field('Property Type');

    final originalPrice =
        _number(property['Original Price']);

    final currentPrice =
        _number(property['Current Price']);

    final displayPrice =
        _publicListingPrice();

    final usesMaskedPublicPrice =
        _usesMaskedPublicPrice();

    final hasReduction =
        !usesMaskedPublicPrice &&
        originalPrice > currentPrice &&
        currentPrice > 0;

    final saving = hasReduction
        ? originalPrice - currentPrice
        : 0;

    final description =
        _field('Description');

    final imageList = images;

    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
  backgroundColor: deepNavy,
  foregroundColor: Colors.white,
  elevation: 0,

  leading: IconButton(
    tooltip: 'Back',
    icon: const Icon(
      Icons.arrow_back_rounded,
      color: Colors.white,
    ),
    onPressed: () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    },
  ),

  title: const Text(
    'VIEW PROPERTY',
    style: TextStyle(
      fontWeight: FontWeight.w900,
      letterSpacing: 1,
    ),
  ),
  actions: [
    IconButton(
  tooltip: 'View More Listings',
  icon: const Icon(
    Icons.real_estate_agent_outlined,
    color: gold,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PropertyListingScreen(),
      ),
    );
  },
),
    IconButton(
      tooltip: 'Home',
      icon: const Icon(
        Icons.home_rounded,
        color: gold,
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
          (route) => false,
        );
      },
    ),
    const SizedBox(width: 8),
  ],
),
      body: Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: 1400,
    ),
    child: ListView(
      padding: const EdgeInsets.only(
        bottom: 30,
      ),
      children: [
          // IMAGE GALLERY
if (imageList.isNotEmpty)
  LayoutBuilder(
    builder: (context, constraints) {
      

      // PHONE
      if (!kIsWeb) {
        return SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: PropertyImageWithWatermark(
                    imageUrl: imageList[index],
                    fit: BoxFit.contain,
                    watermarkFontSize: 12,
                  ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: 0.55,
                        ),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${index + 1} / ${imageList.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      // WEB RESPONSIVE GALLERY
final bool isWebDesktop =
    constraints.maxWidth >= 900;

final controller = PageController(
  viewportFraction:
      isWebDesktop ? 0.333 : 1.0,
);

return Padding(
  padding: EdgeInsets.symmetric(
    horizontal: isWebDesktop ? 18 : 12,
    vertical: isWebDesktop ? 16 : 10,
  ),
  child: SizedBox(
    height: isWebDesktop ? 300 : 320,
    child: ScrollConfiguration(
      behavior:
          const MaterialScrollBehavior()
              .copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: PageView.builder(
        controller: controller,
        padEnds: false,
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isWebDesktop ? 6 : 0,
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child:
                        PropertyImageWithWatermark(
                      imageUrl:
                          imageList[index],

                      // WEB:
                      // tunjuk gambar penuh
                      fit: BoxFit.contain,

                      watermarkFontSize:
                          isWebDesktop
                              ? 11
                              : 12,
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.black
                            .withValues(
                          alpha: 0.55,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        '${index + 1} / ${imageList.length}',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  ),
);
    },
  )
          else
            const SizedBox(
              height: 250,
              child: PropertyImageWithWatermark(
                imageUrl: '',
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // STATUS
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (status.isNotEmpty)
                      _badge(status),

                    if (priceTag.isNotEmpty)
                      _badge(priceTag),
                  ],
                ),

                const SizedBox(height: 16),

                // PRICE
                if (hasReduction)
                  Text(
                    'RM ${_formatMoney(originalPrice)}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                      decoration:
                          TextDecoration
                              .lineThrough,
                    ),
                  ),

                if (hasReduction)
                  const SizedBox(height: 4),

                Text(
                  displayPrice,
                  style: const TextStyle(
                    color: softGold,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                if (hasReduction) ...[
                  const SizedBox(height: 5),
                  Text(
                    'SAVE RM ${_formatMoney(saving)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                Text(
                  title.isEmpty
                      ? 'PROPERTY'
                      : title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w900,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                if (id.isNotEmpty)
                  Text(
                    'Property ID: $id',
                    style: const TextStyle(
                      color: softGold,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: gold,
                      size: 20,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        [
                          location,
                          state,
                        ]
                            .where(
                              (value) =>
                                  value.isNotEmpty,
                            )
                            .join(', '),
                        style:
                            const TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                const Divider(
                  color: Color(0x44D4AF37),
                ),

                const SizedBox(height: 12),

                const Text(
                  'PROPERTY DETAILS',
                  style: TextStyle(
                    color: softGold,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 10),

                _detailRow(
  context,
  'Property Type',
  propertyType,
),

_detailRow(
  context,
  'Bedroom',
  _field('Bedroom'),
),

_detailRow(
  context,
  'Bathroom',
  _field('Bathroom'),
),

_detailRow(
  context,
  'Built Up',
  _field('Built Up (sq ft)'),
),

_detailRow(
  context,
  'Land Size',
  _field('Land Size'),
),

_detailRow(
  context,
  'Tenure',
  _field('Tenure'),
),

_detailRow(
  context,
  'Land Type',
  _field('Land Type'),
),

_detailRow(
  context,
  'Title Type',
  _field('Title Type'),
),

_detailRow(
  context,
  'Bumi Lot',
  _field('Bumi Lot'),
),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 20),

                  const Divider(
                    color: Color(0x44D4AF37),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      color: softGold,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    style:
                        FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor:
                          deepNavy,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                    onPressed:
                        _contactMKKhairul,
                    icon: const Icon(
                      Icons
                          .chat_bubble_outline,
                    ),
                    label: const Text(
                      'ENQUIRE ON WHATSAPP',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  height: 56,
  child: OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      foregroundColor: gold,
      side: const BorderSide(
        color: gold,
        width: 1.3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),
    ),
    onPressed: () {
      _shareProperty(context);
    },
    icon: const Icon(
      Icons.share_outlined,
    ),
    label: const Text(
      'SHARE PROPERTY',
      style: TextStyle(
        fontWeight: FontWeight.w900,
      ),
    ),
  ),
),

const SizedBox(height: 22),

                const Center(
                  child: Text(
                    'SIMPLE. SMART. PROPERTY.',
                    style: TextStyle(
                      color: softGold,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        ), // ConstrainedBox
  ), // Center
); // Scaffold
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: gold.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: gold,
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: softGold,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class MKHomeHubScreen extends StatelessWidget {
  const MKHomeHubScreen({super.key});

  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  void _openRequestForm(
    BuildContext context,
    String service,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MKHomeHubRequestForm(
          service: service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MK HOME HUB',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'All Your Property Needs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'From property management to renovation, utilities, licensing and more.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          MKHomeHubCard(
            icon: Icons.apartment_outlined,
            title: 'PROPERTY MANAGEMENT',
            subtitle:
                'Rental • Investment • Homestay • Sale • Maintenance',
            onTap: () {
              _openRequestForm(
                context,
                'Property Management',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.chair_outlined,
            title: 'INTERIOR DESIGN',
            subtitle:
                'Residential • Commercial • Office • Furnishing',
            onTap: () {
              _openRequestForm(
                context,
                'Interior Design',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.construction_outlined,
            title: 'RENOVATION & CONSTRUCTION',
            subtitle:
                'Land • Residential • Commercial • Factory',
            onTap: () {
              _openRequestForm(
                context,
                'Renovation & Construction',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.electrical_services_outlined,
            title: 'UTILITIES SETUP',
            subtitle:
                'WiFi • Electricity • Water • New Registration',
            onTap: () {
              _openRequestForm(
                context,
                'Utilities Setup',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.carpenter_outlined,
            title: 'CARPENTER & HOME SUPPLIES',
            subtitle:
                'Cabinet • Wardrobe • Sofa • Mattress • Custom Work',
            onTap: () {
              _openRequestForm(
                context,
                'Carpenter & Home Supplies',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.support_agent_outlined,
            title: 'PROPERTY CONSULTATION',
            subtitle:
                'Land • Conversion • Planning • Build • Fully Furnished',
            onTap: () {
              _openRequestForm(
                context,
                'Property Consultation',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.assignment_outlined,
            title: 'LICENSE & PERMIT',
            subtitle:
                'Business License • Renovation Permit • Other Applications',
            onTap: () {
              _openRequestForm(
                context,
                'License & Permit',
              );
            },
          ),

          MKHomeHubCard(
            icon: Icons.campaign_outlined,
            title: 'SIGNBOARD & ADVERTISING',
            subtitle:
                'Banner • Bunting • Light Box • LED • Signage',
            onTap: () {
              _openRequestForm(
                context,
                'Signboard & Advertising',
              );
            },
          ),

          const SizedBox(height: 22),

          const Center(
            child: Text(
              'SIMPLE. SMART. PROPERTY.',
              style: TextStyle(
                color: softGold,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MKHomeHubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MKHomeHubCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const navy = Color(0xFF071A2C);
  static const gold = Color(0xFFD4AF37);
  static const softGold = Color(0xFFF2D675);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: navy,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gold,
                width: 1.3,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: gold,
                    size: 38,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: softGold,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: gold,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class MKHomeHubRequestForm extends StatefulWidget {
  final String service;

  const MKHomeHubRequestForm({
    super.key,
    required this.service,
  });

  @override
  State<MKHomeHubRequestForm> createState() =>
      _MKHomeHubRequestFormState();
}

class _MKHomeHubRequestFormState
    extends State<MKHomeHubRequestForm> {
  static const navy = Color(0xFF071A2C);
  static const deepNavy = Color(0xFF03111E);
  static const gold = Color(0xFFD4AF37);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final workController = TextEditingController();
  final preferredDateController = TextEditingController();
  final budgetController = TextEditingController();
  final notesController = TextEditingController();

  bool consent = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    workController.dispose();
    preferredDateController.dispose();
    budgetController.dispose();
    notesController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0x66D4AF37),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: gold,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: navy,
    );
  }

  String _text(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? '-' : value;
  }

  Future<void> _submitToWhatsApp() async {
    if (!consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please confirm your consent before continuing.',
          ),
        ),
      );
      return;
    }

    final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

MK HOME HUB REQUEST

SERVICE: ${widget.service}

CLIENT DETAILS
Name: ${_text(nameController)}
Phone No.: ${_text(phoneController)}

PROJECT / PROPERTY ADDRESS
${_text(addressController)}

WHAT I WANT TO DO
${_text(workController)}

PREFERRED DATE / WHEN TO START
${_text(preferredDateController)}

ESTIMATED BUDGET
RM ${_text(budgetController)}

ADDITIONAL NOTES
${_text(notesController)}

I consent to providing these details to MK Khairul for service enquiry and consultation purposes.

Thank you.
''';

    final whatsappUrl = Uri.parse(
      'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
    );

    final launched = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepNavy,
      appBar: AppBar(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        title: const Text(
          'MK HOME HUB',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.service,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Tell us what you need and MK Khairul will assist with the next step.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: gold,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: gold,
                  size: 24,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    widget.service,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Full Name'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration('Phone Number'),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: addressController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Property / Project Address',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: workController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'What would you like to do?',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: preferredDateController,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'When would you like to start?',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: budgetController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Estimated Budget',
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: notesController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: _fieldDecoration(
              'Additional Notes',
            ),
          ),

          const SizedBox(height: 18),

          CheckboxListTile(
            value: consent,
            activeColor: gold,
            checkColor: deepNavy,
            contentPadding: EdgeInsets.zero,
            controlAffinity:
                ListTileControlAffinity.leading,
            title: const Text(
              'I consent to providing these details to MK Khairul for service enquiry and consultation purposes.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            onChanged: (value) {
              setState(() {
                consent = value ?? false;
              });
            },
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: deepNavy,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              onPressed: _submitToWhatsApp,
              icon: const Icon(
                Icons.chat_bubble_outline,
              ),
              label: const Text(
                'CONTINUE TO WHATSAPP',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Please review your information carefully before sending.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanEligibilityScreen extends StatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  State<LoanEligibilityScreen> createState() =>
      _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState
    extends State<LoanEligibilityScreen> {
  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  final incomeController = TextEditingController();
  final commitmentController = TextEditingController();

  double dsrLimit = 60;
  double interestRate = 4.0;
  double maxLoan = 0;
  double availablePayment = 0;
  bool calculated = false;

  int tenure = 35;

  void calculateEligibility() {
    final income =
        double.tryParse(incomeController.text.replaceAll(',', '')) ?? 0;

    final commitments =
        double.tryParse(commitmentController.text.replaceAll(',', '')) ?? 0;

    if (income <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your monthly income.'),
        ),
      );
      return;
    }

    final maxDebt = income * (dsrLimit / 100);
    final payment = max(0.0, maxDebt - commitments);

    final monthlyRate = (interestRate / 100) / 12;
    final months = tenure * 12;

    double loan = 0;

    if (payment > 0) {
      if (monthlyRate == 0) {
        loan = payment * months;
      } else {
        loan = payment *
            (1 - pow(1 + monthlyRate, -months)) /
            monthlyRate;
      }
    }

    setState(() {
      availablePayment = payment;
      maxLoan = loan;
      calculated = true;
    });
  }

  String money(double value) {
    return 'RM ${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        )}';
  }

  @override
  void dispose() {
    incomeController.dispose();
    commitmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Loan Eligibility'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text(
            'How Much Can I Borrow?',
            style: TextStyle(
              color: navy,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Get a quick estimate of your housing loan eligibility.',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 28),

          _MoneyField(
            controller: incomeController,
            label: 'Monthly Income',
            hint: 'Example: 5,000',
          ),

          const SizedBox(height: 16),

          _MoneyField(
            controller: commitmentController,
            label: 'Monthly Commitments',
            hint: 'Car, personal loan, credit card, etc.',
          ),

          const SizedBox(height: 24),

          Text(
            'Estimated DSR Limit: ${dsrLimit.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: navy,
            ),
          ),

          Slider(
            value: dsrLimit,
            min: 40,
            max: 80,
            divisions: 8,
            activeColor: gold,
            label: '${dsrLimit.toStringAsFixed(0)}%',
            onChanged: (value) {
              setState(() {
                dsrLimit = value;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            initialValue: tenure,
            decoration: const InputDecoration(
              labelText: 'Loan Tenure',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 20, child: Text('20 years')),
              DropdownMenuItem(value: 25, child: Text('25 years')),
              DropdownMenuItem(value: 30, child: Text('30 years')),
              DropdownMenuItem(value: 35, child: Text('35 years')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  tenure = value;
                });
              }
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            initialValue: interestRate.toStringAsFixed(1),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Estimated Interest Rate (%)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              interestRate =
                  double.tryParse(value) ?? 4.0;
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: calculateEligibility,
              child: const Text(
                'CHECK MY ELIGIBILITY',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

         if (calculated) ...[
  const SizedBox(height: 28),

  Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: navy,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        const Text(
          'ESTIMATED HOUSING LOAN',
          style: TextStyle(
            color: gold,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          money(maxLoan),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 22),

        _ResultRow(
          label: 'Estimated Property Price',
          value: money(maxLoan / 0.90),
        ),

        _ResultRow(
          label: 'Available Monthly Instalment',
          value: money(availablePayment),
        ),

        _ResultRow(
          label: 'DSR Limit Used',
          value: '${dsrLimit.toStringAsFixed(0)}%',
        ),

        _ResultRow(
          label: 'Loan Tenure',
          value: '$tenure years',
        ),

        _ResultRow(
          label: 'Estimated Interest Rate',
          value: '${interestRate.toStringAsFixed(2)}%',
        ),
      ],
    ),
  ),

  const SizedBox(height: 18),

  SizedBox(
    height: 56,
    child: FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: navy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
 onPressed: () {
  final estimatedPropertyPrice = maxLoan / 0.90;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PropertyEnquiryScreen(
        initialPurpose: 'Buy',
        initialBudget: estimatedPropertyPrice,
      ),
    ),
  );
},
      icon: const Icon(Icons.search_rounded),
      label: const Text(
        'FIND A PROPERTY WITHIN MY BUDGET',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  ),

  const SizedBox(height: 18),

  Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.black12,
      ),
    ),
    child: const Text(
      'Important: This calculator provides an estimate only. '
      'Actual financing eligibility and property financing margin '
      'depend on the bank, income profile, age, CCRIS/CTOS, existing '
      'commitments, property type and the bank’s current credit policy.',
      style: TextStyle(
        fontSize: 12,
        height: 1.5,
        color: Colors.black54,
      ),
    ),
  ),
],
        ],
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _MoneyField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        prefixText: 'RM ',
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
class PropertyEnquiryScreen extends StatefulWidget {
  final String initialPurpose;
  final double? initialBudget;

  const PropertyEnquiryScreen({
    super.key,
    this.initialPurpose = 'Buy',
    this.initialBudget,
  });

  @override
  State<PropertyEnquiryScreen> createState() =>
      _PropertyEnquiryScreenState();
}

class _PropertyEnquiryScreenState
    extends State<PropertyEnquiryScreen> {
  static const navy = Color(0xFF0B1F33);
 

  late String purpose;

  final budgetController = TextEditingController();
  final locationController = TextEditingController();
  final propertyTypeController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    purpose = widget.initialPurpose;

    if (widget.initialBudget != null) {
      budgetController.text =
          widget.initialBudget!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    budgetController.dispose();
    locationController.dispose();
    propertyTypeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Property Enquiry'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text(
            'Tell us what you’re looking for',
            style: TextStyle(
              color: navy,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We’ll make the enquiry simple and easy.',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            initialValue: purpose,
            decoration: const InputDecoration(
              labelText: 'I want to',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Buy',
                child: Text('Buy a Property'),
              ),
              DropdownMenuItem(
                value: 'Rent',
                child: Text('Rent a Property'),
              ),
              DropdownMenuItem(
                value: 'Sell',
                child: Text('Sell a Property'),
              ),
              DropdownMenuItem(
                value: 'Rent Out',
                child: Text('Rent Out My Property'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  purpose = value;
                });
              }
            },
          ),

          const SizedBox(height: 16),

          TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: 'RM ',
              labelText: 'Budget / Asking Price',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Preferred Location',
              hintText: 'Example: Shah Alam, Klang, KL',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: propertyTypeController,
            decoration: const InputDecoration(
              labelText: 'Property Type',
              hintText: 'Condo, Terrace, Land, Commercial...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Additional Notes',
              hintText: 'Bedrooms, size, requirements, etc.',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

         SizedBox(
  height: 56,
  child: FilledButton.icon(
    style: FilledButton.styleFrom(
      backgroundColor: navy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    onPressed: () async {
      final budget = budgetController.text.trim();
      final location = locationController.text.trim();
      final propertyType = propertyTypeController.text.trim();
      final notes = notesController.text.trim();

      final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

ENQUIRY: $purpose
BUDGET / ASKING PRICE: RM ${budget.isEmpty ? '-' : budget}
LOCATION: ${location.isEmpty ? '-' : location}
PROPERTY TYPE: ${propertyType.isEmpty ? '-' : propertyType}
NOTES: ${notes.isEmpty ? '-' : notes}

Boleh bantu saya?
''';

      final whatsappUrl = Uri.parse(
        'https://wa.me/601153599092?text=${Uri.encodeComponent(message)}',
      );

final launched = await launchUrl(
  whatsappUrl,
  mode: LaunchMode.externalApplication,
);

if (!launched) {
  await launchUrl(
    whatsappUrl,
    mode: LaunchMode.platformDefault,
  );
}
    },
    icon: const Icon(
      Icons.chat_bubble_outline,
    ),
    label: const Text(
      'CONTINUE TO WHATSAPP',
      style: TextStyle(
        fontWeight: FontWeight.w800,
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  State<LoanCalculatorScreen> createState() =>
      _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState
    extends State<LoanCalculatorScreen> {
  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  final propertyPriceController = TextEditingController();
  final downPaymentController =
      TextEditingController(text: '10');
  final interestRateController =
      TextEditingController(text: '4.0');

  int tenure = 35;

  double loanAmount = 0;
  double monthlyPayment = 0;
  double downPaymentAmount = 0;

  bool calculated = false;

  void calculateLoan() {
    final propertyPrice =
        double.tryParse(propertyPriceController.text) ?? 0;

    final downPaymentPercent =
        double.tryParse(downPaymentController.text) ?? 0;

    final annualInterest =
        double.tryParse(interestRateController.text) ?? 0;

    if (propertyPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the property price.'),
        ),
      );
      return;
    }

    downPaymentAmount =
        propertyPrice * (downPaymentPercent / 100);

    loanAmount = propertyPrice - downPaymentAmount;

    final monthlyRate =
        (annualInterest / 100) / 12;

    final numberOfPayments = tenure * 12;

    if (monthlyRate == 0) {
      monthlyPayment =
          loanAmount / numberOfPayments;
    } else {
      final factor =
          _power(1 + monthlyRate, numberOfPayments);

      monthlyPayment =
          loanAmount *
              monthlyRate *
              factor /
              (factor - 1);
    }

    setState(() {
      calculated = true;
    });
  }

  double _power(double base, int exponent) {
    double result = 1;

    for (int i = 0; i < exponent; i++) {
      result *= base;
    }

    return result;
  }

  String money(double value) {
    return 'RM ${value.toStringAsFixed(0)}';
  }

  @override
  void dispose() {
    propertyPriceController.dispose();
    downPaymentController.dispose();
    interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Loan Calculator'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text(
            'Calculate My Loan',
            style: TextStyle(
              color: navy,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Estimate your monthly housing loan payment.',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: propertyPriceController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              prefixText: 'RM ',
              labelText: 'Property Price',
              hintText: 'Example: 500000',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: downPaymentController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              suffixText: '%',
              labelText: 'Downpayment',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: interestRateController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              suffixText: '%',
              labelText: 'Estimated Interest Rate',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<int>(
            initialValue: tenure,
            decoration: const InputDecoration(
              labelText: 'Loan Tenure',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 10,
                child: Text('10 years'),
              ),
              DropdownMenuItem(
                value: 15,
                child: Text('15 years'),
              ),
              DropdownMenuItem(
                value: 20,
                child: Text('20 years'),
              ),
              DropdownMenuItem(
                value: 25,
                child: Text('25 years'),
              ),
              DropdownMenuItem(
                value: 30,
                child: Text('30 years'),
              ),
              DropdownMenuItem(
                value: 35,
                child: Text('35 years'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  tenure = value;
                });
              }
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              onPressed: calculateLoan,
              child: const Text(
                'CALCULATE MY LOAN',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          if (calculated) ...[
            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: navy,
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'ESTIMATED MONTHLY INSTALMENT',
                    style: TextStyle(
                      color: gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    money(monthlyPayment),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _ResultRow(
                    label: 'Property Price',
                    value: money(
                      double.tryParse(
                            propertyPriceController.text,
                          ) ??
                          0,
                    ),
                  ),

                  _ResultRow(
                    label: 'Downpayment',
                    value: money(downPaymentAmount),
                  ),

                  _ResultRow(
                    label: 'Estimated Loan Amount',
                    value: money(loanAmount),
                  ),

                  _ResultRow(
                    label: 'Interest Rate',
                    value:
                        '${interestRateController.text}%',
                  ),

                  _ResultRow(
                    label: 'Loan Tenure',
                    value: '$tenure years',
                  ),
                ],
              ),
            ),

                        const SizedBox(height: 18),

            SizedBox(
              height: 56,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  final propertyPrice =
                      double.tryParse(propertyPriceController.text) ?? 0;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PropertyEnquiryScreen(
                        initialPurpose: 'Buy',
                        initialBudget: propertyPrice,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.home_work_outlined),
                label: const Text(
                  'FIND A PROPERTY WITH THIS BUDGET',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Important: This calculator provides an estimate only. '
              'Actual monthly instalment may vary depending on the bank, '
              'approved financing amount, interest/profit rate and financing terms.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InvestmentCalculatorScreen extends StatefulWidget {
  const InvestmentCalculatorScreen({super.key});

  @override
  State<InvestmentCalculatorScreen> createState() =>
      _InvestmentCalculatorScreenState();
}

class _InvestmentCalculatorScreenState
   extends State<InvestmentCalculatorScreen> {
  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  final propertyPriceController = TextEditingController();
  final monthlyRentalController = TextEditingController();
  final monthlyLoanController = TextEditingController();
  final maintenanceController = TextEditingController();
  final otherCostController = TextEditingController();

  double grossRentalYield = 0;
  double monthlyCashFlow = 0;
  double annualCashFlow = 0;
  double simpleROI = 0;

  bool calculated = false;

  void calculateInvestment() {
    final propertyPrice = double.tryParse(
          propertyPriceController.text.replaceAll(',', ''),
        ) ??
        0;

    final monthlyRental = double.tryParse(
          monthlyRentalController.text.replaceAll(',', ''),
        ) ??
        0;

    final monthlyLoan = double.tryParse(
          monthlyLoanController.text.replaceAll(',', ''),
        ) ??
        0;

    final maintenance = double.tryParse(
          maintenanceController.text.replaceAll(',', ''),
        ) ??
        0;

    final otherCost = double.tryParse(
          otherCostController.text.replaceAll(',', ''),
        ) ??
        0;

    if (propertyPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the property price.'),
        ),
      );
      return;
    }

    final annualRental = monthlyRental * 12;

    final cashFlow =
        monthlyRental - monthlyLoan - maintenance - otherCost;

    final annualCF = cashFlow * 12;

    final estimatedInitialCash = propertyPrice * 0.10;

    setState(() {
      grossRentalYield =
          (annualRental / propertyPrice) * 100;

      monthlyCashFlow = cashFlow;
      annualCashFlow = annualCF;

      simpleROI = estimatedInitialCash > 0
          ? (annualCF / estimatedInitialCash) * 100
          : 0;

      calculated = true;
    });
  }

  String money(double value) {
    return 'RM ${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        )}';
  }

  @override
  void dispose() {
    propertyPriceController.dispose();
    monthlyRentalController.dispose();
    monthlyLoanController.dispose();
    maintenanceController.dispose();
    otherCostController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: navy,
      foregroundColor: Colors.white,
      title: const Text('Investment Calculator'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          'Investment Calculator',
          style: TextStyle(
            color: navy,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Estimate rental yield, cash flow and simple ROI.',
          style: TextStyle(
            fontSize: 15,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        _MoneyField(
          controller: propertyPriceController,
          label: 'Property Price',
          hint: 'Example: 500,000',
        ),

        const SizedBox(height: 16),

        _MoneyField(
          controller: monthlyRentalController,
          label: 'Monthly Rental',
          hint: 'Example: 2,500',
        ),

        const SizedBox(height: 16),

        _MoneyField(
          controller: monthlyLoanController,
          label: 'Monthly Loan Instalment',
          hint: 'Example: 1,900',
        ),

        const SizedBox(height: 16),

        _MoneyField(
          controller: maintenanceController,
          label: 'Monthly Maintenance',
          hint: 'Example: 250',
        ),

        const SizedBox(height: 16),

        _MoneyField(
          controller: otherCostController,
          label: 'Other Monthly Costs',
          hint: 'Example: 100',
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 56,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: navy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: calculateInvestment,
            child: const Text(
              'CALCULATE INVESTMENT',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        if (calculated) ...[
          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  'INVESTMENT SUMMARY',
                  style: TextStyle(
                    color: gold,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 20),

                _ResultRow(
                  label: 'Gross Rental Yield',
                  value: '${grossRentalYield.toStringAsFixed(2)}%',
                ),

                _ResultRow(
                  label: 'Monthly Cash Flow',
                  value: money(monthlyCashFlow),
                ),

                _ResultRow(
                  label: 'Annual Cash Flow',
                  value: money(annualCashFlow),
                ),

                _ResultRow(
                  label: 'Simple ROI',
                  value: '${simpleROI.toStringAsFixed(2)}%',
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: navy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                final propertyPrice = double.tryParse(
                      propertyPriceController.text.replaceAll(',', ''),
                    ) ??
                    0;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropertyEnquiryScreen(
                      initialPurpose: 'Buy',
                      initialBudget: propertyPrice,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.trending_up_outlined),
              label: const Text(
                'FIND AN INVESTMENT PROPERTY',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Important: This calculator provides a simple estimate only. '
            'Actual investment returns may vary due to vacancy, repairs, '
            'taxes, insurance, legal costs, financing changes and other expenses.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ],
    ),
  );
}
     

  }

  class PropertyGuideScreen extends StatelessWidget {
  const PropertyGuideScreen({super.key});

  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Property Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: const [
          Text(
            'Property Guide',
            style: TextStyle(
              color: navy,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Simple property answers without the jargon.',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),

          SizedBox(height: 24),

          _GuideCard(
            title: 'What is DSR?',
            answer:
                'DSR means Debt Service Ratio. Banks use it to compare your monthly debt commitments against your income.',
          ),

          _GuideCard(
            title: 'What are CCRIS & CTOS?',
            answer:
                'They help lenders assess your credit profile and repayment history. A clean profile may improve your financing chances.',
          ),

          _GuideCard(
            title: 'Freehold vs Leasehold',
            answer:
                'Freehold ownership has no fixed lease expiry. Leasehold properties are held for a fixed lease period and may require consent for certain transactions.',
          ),

          _GuideCard(
            title: 'What is a Booking Fee?',
            answer:
                'A booking fee is an initial payment to reserve a property. Always verify the agent, agency and payment instructions before transferring money.',
          ),

          _GuideCard(
            title: 'What is MOT?',
            answer:
                'MOT means Memorandum of Transfer. It is the legal instrument used to transfer property ownership to the buyer.',
          ),

          _GuideCard(
            title: 'What is RPGT?',
            answer:
                'RPGT means Real Property Gains Tax. It may apply when a property is sold at a gain, depending on current rules and circumstances.',
          ),

          _GuideCard(
            title: 'What is Strata?',
            answer:
                'Strata ownership usually applies to properties such as condominiums and apartments, where owners share common facilities and pay maintenance charges.',
          ),

          _GuideCard(
            title: 'Why can a housing loan be rejected?',
            answer:
                'Common factors include high commitments, weak credit history, insufficient income, unstable income profile, property issues or bank credit policy.',
          ),

          SizedBox(height: 10),

          Text(
            'Important: This guide is for general education only. Property, financing, legal and tax requirements may vary.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String title;
  final String answer;

  const _GuideCard({
    required this.title,
    required this.answer,
  });

  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: ExpansionTile(
          iconColor: gold,
          collapsedIconColor: gold,
          title: Text(
            title,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          childrenPadding:
              const EdgeInsets.fromLTRB(18, 0, 18, 18),
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
