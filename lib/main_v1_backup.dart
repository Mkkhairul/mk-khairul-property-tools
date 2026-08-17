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

  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
              decoration: const BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MK KHAIRUL',
                    style: TextStyle(
                      color: gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Property Tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Simple. Smart. Property.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'What can we help you with?',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),

                  FeatureCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'How Much Can I Borrow?',
                    subtitle:
                        'Check your estimated housing loan eligibility.',
                    onTap: () {
                      debugPrint('LOAN CARD TAPPED');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoanEligibilityScreen(),
                        ),
                      );
                    },
                  ),

                 FeatureCard(
  icon: Icons.calculate_outlined,
  title: 'Calculate My Loan',
  subtitle:
      'Estimate your monthly home loan payment.',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoanCalculatorScreen(),
      ),
    );
  },
),

                  FeatureCard(
                    icon: Icons.home_work_outlined,
                    title: 'Property Enquiry',
                    subtitle:
                        'Sell, rent out, buy or rent a property.',
                 onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const PropertyEnquiryScreen(),
    ),
  );
},
                  ),

                  FeatureCard(
                    icon: Icons.trending_up_outlined,
                    title: 'Investment Calculator',
                    subtitle:
                        'Check rental yield, ROI and cash flow.',
                   onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const InvestmentCalculatorScreen(),
    ),
  );
},
                  ),

                  FeatureCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Property Guide',
                    subtitle:
                        'Simple property answers without the jargon.',
                  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const PropertyGuideScreen(),
    ),
  );
},
                  ),

                  FeatureCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Talk to MK Khairul',
                    subtitle:
                        'Get property help directly via WhatsApp.',
                onTap: () async {
  final message = '''
Hi MK Khairul,

Saya dari MK KHAIRUL Property Tools.

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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Column(
    children: [
      const Text(
        'MK KHAIRUL',
        style: TextStyle(
          color: navy,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),

      const SizedBox(height: 4),

      const Text(
        'Your Property Partner',
        style: TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
      ),

      const SizedBox(height: 18),

      Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          TextButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://wa.me/601153599092',
              );
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('WhatsApp'),
          ),

          const Text('•'),

          TextButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://www.facebook.com/share/1BFSn5rTag/',
              );
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('Facebook'),
          ),

          const Text('•'),

          TextButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://www.tiktok.com/@mk_nrul',
              );
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('TikTok'),
          ),

          const Text('•'),

          TextButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://www.google.com/search?q=mk+Khairul',
              );
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('Google'),
          ),
        ],
      ),

      const SizedBox(height: 14),

      const Divider(),

      const SizedBox(height: 10),

      const Text(
        'Property tools are for estimation & educational purposes only.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          height: 1.4,
          color: Colors.black45,
        ),
      ),
    ],
  ),
),

const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const navy = Color(0xFF0B1F33);
  static const gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
return Container(
  margin: const EdgeInsets.only(bottom: 14),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: gold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: gold,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: navy,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            height: 1.35,
          ),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: gold,
      ),
        onTap: onTap,
    ),
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

  double dsrLimit = 70;
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
