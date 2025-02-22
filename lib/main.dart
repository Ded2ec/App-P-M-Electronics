import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P&M Electronics',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'P&M Electronics')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SvgPicture.asset(
                'assets/images/output.svg',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
                allowDrawingOutsideViewBox: true,
                placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'แบรนด์',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BrandCard(
                    brand: 'LG',
                    subtitle: 'Electronics',
                    image: 'assets/images/list-lg.svg',
                    isSvg: true,
                  ),
                  BrandCard(
                    brand: 'TOSHIBA',
                    subtitle: 'Electronics',
                     image: 'assets/images/list-toshiba.svg',
                    isSvg: true,
                  ),
                  BrandCard(
                    brand: 'SAMSUNG',
                    subtitle: 'Electronics',
                    image: 'assets/images/list-samsung.svg',
                    isSvg: true,
                  ),
                  BrandCard(
                    brand: 'HITACHI',
                    subtitle: 'Electronics',
                    image: 'assets/images/list-hitachi.svg',
                    isSvg: true,
                  ),
                  BrandCard(
                    brand: 'PANASONIC',
                    subtitle: 'Electronics',
                    image: 'assets/images/list-panasonic.svg',
                    isSvg: true,
                  ),
                  BrandCard(
                    brand: 'Carrier',
                    subtitle: 'Electronics',
                    image: 'assets/images/list-carrier.svg',
                    isSvg: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ปัญหาการใช้งาน',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ProblemCard(
              title: 'Headline',
              description: 'Description duis aute irure dolor in reprehenderit in voluptate velit.',
              time: 'Today • 23 min',
            ),
            const SizedBox(height: 12),
            ProblemCard(
              title: 'Headline',
              description: 'Description duis aute irure dolor in reprehenderit in voluptate velit.',
              time: 'Today • 23 min',
            ),
          ],
        ),
      ),
    );
  }
}

class BrandCard extends StatelessWidget {
  final String brand;
  final String subtitle;
  final String image;
  final bool isSvg;

  const BrandCard({
    super.key,
    required this.brand,
    required this.subtitle,
    required this.image,
    required this.isSvg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandDetailScreen(
              brand: brand,
              image: image,
              isSvg: isSvg,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 120,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: isSvg
                    ? SvgPicture.asset(
                        image,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
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

class BrandDetailScreen extends StatelessWidget {
  final String brand;
  final String image;
  final bool isSvg;

  const BrandDetailScreen({
    required this.brand,
    required this.image,
    this.isSvg = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> brandDescriptions = {
      'SAMSUNG': 'Samsung Electronics is a global leader in home appliances, offering innovative washing machines, refrigerators, and other household devices.',
      'LG': 'LG Electronics provides smart home solutions with advanced technology in their appliances range.',
      'PANASONIC': 'Panasonic offers reliable home appliances with innovative features and durability.',
      'TOSHIBA': 'Toshiba brings quality and innovation to home appliances with their advanced technology.',
      'HITACHI': 'Hitachi provides high-quality home appliances with Japanese engineering excellence.',
      'Carrier': 'Carrier provides high-quality HVAC solutions with American engineering excellence.',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(brand),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: isSvg
                  ? SvgPicture.asset(
                      image,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลเครื่องปรับอากาศ $brand',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    brandDescriptions[brand] ?? 'Brand description not available.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ErrorCodeScreen(brand: brand),
                          ),
                        );
                      },
                      icon: const Icon(Icons.error_outline),
                      label: const Text('View Error Codes'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
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

class ErrorCodeScreen extends StatelessWidget {
  final String brand;

  const ErrorCodeScreen({required this.brand, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> errorCodes = {
      'SAMSUNG': [
        {
          'code': '4C',
          'problem': 'Water Supply Issue',
          'solution': '1. Check water supply\n2. Check inlet hose\n3. Clean inlet filter',
        },
        {
          'code': '5C',
          'problem': 'Drainage Problem',
          'solution': '1. Check drain hose\n2. Clean drain filter\n3. Ensure proper installation',
        },
        // เพิ่ม error codes อื่นๆ
      ],
        'LG': [
        {
          'code': '4C',
          'problem': 'Water Supply Issue',
          'solution': '1. Check water supply\n2. Check inlet hose\n3. Clean inlet filter',
        },
        {
          'code': '5C',
          'problem': 'Drainage Problem',
          'solution': '1. Check drain hose\n2. Clean drain filter\n3. Ensure proper installation',
        },   
        ],     
        'Carrier': [
        {
          'code': '4C',
          'problem': 'Water Supply Issue',
          'solution': '1. Check water supply\n2. Check inlet hose\n3. Clean inlet filter',
        },
        {
          'code': '5C',
          'problem': 'Drainage Problem',
          'solution': '1. Check drain hose\n2. Clean drain filter\n3. Ensure proper installation',
        },
        
        // เพิ่ม error codes อื่นๆ
      ],
      // เพิ่มข้อมูลแบรนด์อื่นๆ
    };

    final brandCodes = errorCodes[brand] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$brand Error Codes'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: brandCodes.length,
        itemBuilder: (context, index) {
          final error = brandCodes[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text(
                'Error ${error['code']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(error['problem'] ?? ''),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How to fix:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(error['solution'] ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProblemCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const ProblemCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_outlined),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.play_arrow),
        ],
      ),
    );
  }
}
