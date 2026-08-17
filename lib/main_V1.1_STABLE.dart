import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MKKhairulPropertyToolsApp());
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
  static const navy = Color(0xFF0B1F33);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
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
    return Scaffold(
      backgroundColor: deepNavy,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          children: [
// BRAND HEADER
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MK KHAIRUL',
            style: TextStyle(
              color: softGold,
              fontSize: 20,
              fontWeight: FontWeight.w900,
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
              fontWeight: FontWeight.w900,
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
              fontWeight: FontWeight.w800,
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
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.90,
              children: [
                PremiumToolCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'HOW MUCH\nCAN I BORROW?',
                  subtitle: 'Check your loan\neligibility',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoanEligibilityScreen(),
                      ),
                    );
                  },
                ),

                PremiumToolCard(
                  icon: Icons.calculate_outlined,
                  title: 'LOAN\nCALCULATOR',
                  subtitle: 'Estimate your\nmonthly instalment',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoanCalculatorScreen(),
                      ),
                    );
                  },
                ),

                PremiumToolCard(
                  icon: Icons.trending_up_rounded,
                  title: 'INVESTMENT\nCALCULATOR',
                  subtitle: 'Calculate yield,\ncash flow & ROI',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const InvestmentCalculatorScreen(),
                      ),
                    );
                  },
                ),

                PremiumToolCard(
                  icon: Icons.forum_outlined,
                  title: 'PROPERTY\nENQUIRY',
                  subtitle: 'Tell us what you\nare looking for',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PropertyEnquiryScreen(),
                      ),
                    );
                  },
                ),

                PremiumToolCard(
                  icon: Icons.menu_book_outlined,
                  title: 'PROPERTY\nGUIDE',
                  subtitle: 'Simple guides for\nsmart buyers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PropertyGuideScreen(),
                      ),
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

            // MK CLIENT
            Material(
              color: navy,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const MKClientScreen(),
    ),
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
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: gold.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.people_alt_outlined,
                          color: gold,
                          size: 28,
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

            const SizedBox(height: 22),

            const Center(
              child: Text(
                'SIMPLE. SMART. PROPERTY.',
                style: TextStyle(
                  color: softGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              children: [
                TextButton(
                  onPressed: () {
                    _openUrl(
                      Uri.parse('https://wa.me/601153599092'),
                    );
                  },
                  child: const Text(
                    'WhatsApp',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    _openUrl(
                      Uri.parse(
                        'https://www.facebook.com/share/1BFSn5rTag/',
                      ),
                    );
                  },
                  child: const Text(
                    'Facebook',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    _openUrl(
                      Uri.parse('https://www.tiktok.com/@mk_nrul'),
                    );
                  },
                  child: const Text(
                    'TikTok',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    _openUrl(
                      Uri.parse(
                        'https://www.google.com/search?q=mk+Khairul',
                      ),
                    );
                  },
                  child: const Text(
                    'Google',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Property tools are for estimation & educational purposes only.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ],
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
    return Material(
      color: navy,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: gold,
              width: 1.25,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 4),

              Icon(
                icon,
                color: gold,
                size: 60,
              ),

              const Spacer(),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 9),

              const Icon(
                Icons.arrow_forward_rounded,
                color: softGold,
                size: 18,
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
