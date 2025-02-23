import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Match with splash screen duration
    );

    // Show progress indicator after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showProgress = true;
      });
      // Start the progress animation
      _progressController.forward();
    });

    // Navigate to home page after animation completes
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'P&M Electronics')),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
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
              if (_showProgress) ...[
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressController.value,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      );
                    },
                  ),
                ),
              ],
            ],
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
  String searchQuery = '';
  List<String> recentBrands = [];  // เพิ่มตัวแปรเก็บประวัติ
  
  // Default colors
  final Color _defaultCardColor = const Color(0xFFE0E0E0);
  final Color _defaultAppColor = Colors.white;
  final Color _defaultAppBarColor = Colors.blue;
  
  // Current colors
  late Color cardBackgroundColor;
  late Color appBackgroundColor;
  late Color appBarColor;

  List<Map<String, String>> brands = [
    {'name': 'SAMSUNG', 'image': 'assets/images/list-samsung.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'PANASONIC', 'image': 'assets/images/list-panasonic.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'TOSHIBA', 'image': 'assets/images/list-toshiba.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'HITACHI', 'image': 'assets/images/list-hitachi.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'LG', 'image': 'assets/images/list-lg.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'CARRIER', 'image': 'assets/images/list-carrier.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'DAIKIN', 'image': 'assets/images/list-daikin.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'ELECTROLUX', 'image': 'assets/images/list-electrolux.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'GREE', 'image': 'assets/images/list-gree.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'HAIER', 'image': 'assets/images/list-haier.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'HISENSE', 'image': 'assets/images/list-hisense.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'MITSUBISHI', 'image': 'assets/images/list-mitsubishi.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'TCL', 'image': 'assets/images/list-tcl.svg', 'subtitle': 'Air Conditioner'},
    {'name': 'MIDEA', 'image': 'assets/images/list-midea.svg', 'subtitle': 'Air Conditioner'}
  ];

  List<Map<String, String>> get filteredBrands {
    return brands.where((brand) => 
      brand['name']!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    loadSavedColors();
    loadRecentBrands();  
  }

  Future<void> loadSavedColors() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cardBackgroundColor = Color(prefs.getInt('cardColor') ?? _defaultCardColor.value);
      appBackgroundColor = Color(prefs.getInt('appColor') ?? _defaultAppColor.value);
      appBarColor = Color(prefs.getInt('appBarColor') ?? _defaultAppBarColor.value);
    });
  }

  Future<void> saveColors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cardColor', cardBackgroundColor.value);
    await prefs.setInt('appColor', appBackgroundColor.value);
    await prefs.setInt('appBarColor', appBarColor.value);
  }

  void resetColors() {
    setState(() {
      cardBackgroundColor = _defaultCardColor;
      appBackgroundColor = _defaultAppColor;
      appBarColor = _defaultAppBarColor;
    });
    saveColors(); 
  }

  Future<void> loadRecentBrands() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentBrands = prefs.getStringList('recentBrands') ?? [];
    });
  }

  Future<void> saveRecentBrand(String brand) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {  // เพิ่ม setState เพื่ออัพเดทหน้าจอทันที
      recentBrands.remove(brand);  // ลบรายการเดิมถ้ามี
      recentBrands.insert(0, brand);  // เพิ่มรายการใหม่ไว้ด้านบนสุด
      if (recentBrands.length > 3) {  // เปลี่ยนจาก 2 เป็น 3
        recentBrands = recentBrands.sublist(0, 3);  // เก็บแค่ 3 รายการล่าสุด
      }
    });
    await prefs.setStringList('recentBrands', recentBrands);
  }

  void _showColorPickerDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(type == 'card' ? 'เลือกสีพื้นหลัง Card' : 'เลือกสี AppBar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Ocean Breeze'),
                tileColor: const Color(0xFF2193B0),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFF6DD5ED);
                    } else {
                      appBarColor = const Color(0xFF6DD5ED);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sunset Vibes'),
                tileColor: const Color(0xFFFF416C),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFFFF4B2B);
                    } else {
                      appBarColor = const Color(0xFFFF4B2B);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Purple Dream'),
                tileColor: const Color(0xFF8E2DE2),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFF4A00E0);
                    } else {
                      appBarColor = const Color(0xFF4A00E0);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Fresh Mint'),
                tileColor: const Color(0xFF00B09B),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFF96C93D);
                    } else {
                      appBarColor = const Color(0xFF96C93D);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Golden Hour'),
                tileColor: const Color(0xFFF7971E),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFFFFD200);
                    } else {
                      appBarColor = const Color(0xFFFFD200);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Berry Bliss'),
                tileColor: const Color(0xFFE94057),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFF8A2387);
                    } else {
                      appBarColor = const Color(0xFF8A2387);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sky Blue'),
                tileColor: const Color(0xFF00C6FB),
                onTap: () {
                  setState(() {
                    if (type == 'card') {
                      cardBackgroundColor = const Color(0xFF005BEA);
                    } else {
                      appBarColor = const Color(0xFF005BEA);
                    }
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        toolbarHeight: 160,
        title: Column(
          children: [
            Text(widget.title),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหาแบรนด์...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ตั้งค่าสี'),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            resetColors();
                            Navigator.pop(context);
                          },
                          tooltip: 'รีเซ็ตสีทั้งหมด',
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('เปลี่ยนสีแถบด้านบน'),
                          onTap: () {
                            Navigator.pop(context);
                            _showColorPickerDialog('appbar');
                          },
                        ),
                        ListTile(
                          title: const Text('เปลี่ยนสีพื้นหลัง เมนู'),
                          onTap: () {
                            Navigator.pop(context);
                            _showColorPickerDialog('card');
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: appBackgroundColor,
          ),
          child: SingleChildScrollView(
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
                    children: filteredBrands.map((brand) => 
                      BrandCard(
                        brand: brand['name']!,
                        subtitle: brand['subtitle']!,
                        image: brand['image']!,
                        isSvg: true,
                        backgroundColor: cardBackgroundColor,
                      ),
                    ).toList(),
                  ),
                ),
                if (recentBrands.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'เข้าชมล่าสุด',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(  // เปลี่ยนจาก SingleChildScrollView เป็น Column
                    children: recentBrands.map((brandName) {
                      final brand = brands.firstWhere(
                        (b) => b['name'] == brandName,
                        orElse: () => brands[0],
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: double.infinity,  // ให้กว้างเต็มหน้าจอ
                          decoration: BoxDecoration(
                            color: cardBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: SvgPicture.asset(
                                brand['image']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            title: Text(
                              brand['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(brand['subtitle']!),
                            onTap: () async {  // เพิ่ม async
                              // บันทึกประวัติก่อนนำทางไปหน้ารายละเอียด
                              if (context.findAncestorStateOfType<_MyHomePageState>() != null) {
                                await context  // รอให้บันทึกเสร็จก่อนนำทางไปหน้าถัดไป
                                    .findAncestorStateOfType<_MyHomePageState>()!
                                    .saveRecentBrand(brand['name']!);
                              }
                              if (context.mounted) {  // ตรวจสอบว่า context ยังใช้งานได้
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BrandDetailScreen(
                                      brand: brand['name']!,
                                      image: brand['image']!,
                                      isSvg: true,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
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
  final Color backgroundColor;

  const BrandCard({
    super.key,
    required this.brand,
    required this.subtitle,
    required this.image,
    required this.isSvg,
    this.backgroundColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'brand-$brand',
      child: Material(
        child: GestureDetector(
          onTap: () async {  // เพิ่ม async
            // บันทึกประวัติก่อนนำทางไปหน้ารายละเอียด
            if (context.findAncestorStateOfType<_MyHomePageState>() != null) {
              await context  // รอให้บันทึกเสร็จก่อนนำทางไปหน้าถัดไป
                  .findAncestorStateOfType<_MyHomePageState>()!
                  .saveRecentBrand(brand);
            }
            if (context.mounted) {  // ตรวจสอบว่า context ยังใช้งานได้
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BrandDetailScreen(
                    brand: brand,
                    image: image,
                    isSvg: isSvg,
                  ),
                ),
              );
            }
          },
          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
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
    'SAMSUNG': 'แบรนด์ระดับโลกที่โดดเด่นด้านนวัตกรรม AI และเทคโนโลยีสมาร์ทโฮม มีระบบ SmartThings ควบคุมผ่านสมาร์ทโฟน ฟีเจอร์ AI Auto Cooling ปรับการทำงานอัตโนมัติตามการใช้งานและสภาพห้อง พร้อมระบบฟอกอากาศและประหยัดพลังงาน',

    'PANASONIC': 'แบรนด์ญี่ปุ่นที่มีประวัติยาวนานในการผลิตเครื่องใช้ไฟฟ้า โดดเด่นด้านเทคโนโลยี Inverter ที่ให้พลังงานคงที่ในระดับกลางและต่ำ มีระบบฟอกอากาศและควบคุมความชื้นอัตโนมัติ การออกแบบที่ทันสมัยและประหยัดพลังงาน',

    'TOSHIBA': 'แบรนด์ญี่ปุ่นที่มีความเชี่ยวชาญด้านเทคโนโลยีและนวัตกรรม มีระบบ Self-Cleaning ป้องกันเชื้อราและแบคทีเรีย เทคโนโลยี Twin-Cooling พร้อมเซ็นเซอร์ 13 จุดเพื่อประสิทธิภาพการทำความเย็นสูงสุด',

    'HITACHI': 'แบรนด์ญี่ปุ่นที่มีนวัตกรรม Frost Wash ทำความสะอาดตัวเองด้วยการแช่แข็งและละลายน้ำแข็ง ระบบ Stainless Clean ป้องกันแบคทีเรียและฝุ่น มาพร้อมเทคโนโลยี IoT ควบคุมผ่านแอปพลิเคชัน',

    'LG': 'แบรนด์เกาหลีที่โดดเด่นด้านดีไซน์และเทคโนโลยี AI มีระบบ Dual Inverter Compressor ประหยัดพลังงานและลดเสียงรบกวน ฟังก์ชัน ThinQ ควบคุมแอร์ผ่านสมาร์ทโฟน มีระบบฟอกอากาศและฆ่าเชื้อแบคทีเรีย',

    'CARRIER': 'แบรนด์อเมริกันที่เป็นผู้นำด้านระบบปรับอากาศ มีเทคโนโลยี Smart Auto Mode ปรับความเร็วพัดลมอัตโนมัติตามคุณภาพอากาศ ระบบกรองอากาศประสิทธิภาพสูง และการควบคุมอุณหภูมิที่แม่นยำ',

    'DAIKIN': 'แบรนด์ญี่ปุ่นที่มีชื่อเสียงด้านเทคโนโลยีระบบปรับอากาศระดับโลก มีระบบ Streamer Discharge ที่ช่วยฟอกอากาศและฆ่าเชื้อโรค เทคโนโลยี Inverter ประหยัดพลังงานสูง คอมเพรสเซอร์ทนทาน และระบบควบคุมอุณหภูมิแม่นยำ',

    'ELECTROLUX': 'แบรนด์สวีเดนที่ขึ้นชื่อเรื่องดีไซน์และคุณภาพ เทคโนโลยี Air Purification ช่วยฟอกอากาศให้บริสุทธิ์ ระบบ I-Feel ปรับอุณหภูมิให้เหมาะสมอัตโนมัติ ดีไซน์ทันสมัยและเสียงเงียบ',

    'GREE': 'แบรนด์จีนที่เป็นหนึ่งในผู้ผลิตแอร์รายใหญ่ของโลก มีเทคโนโลยี Cold Plasma ฆ่าเชื้อโรคและฟอกอากาศ ระบบ Self-Cleaning ลดการสะสมของฝุ่นและเชื้อรา ใช้คอมเพรสเซอร์ที่ทนทานและเงียบ',

    'HAIER': 'แบรนด์จีนที่มีความเชี่ยวชาญด้านอุปกรณ์เครื่องใช้ไฟฟ้า เทคโนโลยี Self-Cleaning ป้องกันเชื้อราและแบคทีเรีย ระบบ Hyper PCB ทำให้ทำงานได้เสถียรแม้ไฟตก คอมเพรสเซอร์ทนทานและประหยัดพลังงาน',

    'HISENSE': 'แบรนด์จีนที่มีความเชี่ยวชาญด้านเทคโนโลยีดิจิทัล ระบบ Hi-Nano กำจัดเชื้อแบคทีเรียและไวรัส โหมด I Feel ปรับอุณหภูมิตามตำแหน่งของรีโมท คอมเพรสเซอร์ทนทาน และมีโหมดประหยัดพลังงาน',

    'MITSUBISHI': 'แบรนด์ญี่ปุ่นที่ขึ้นชื่อเรื่องความทนทานและประหยัดพลังงาน ระบบ Fast Cooling ทำให้เย็นเร็วทันใจ เทคโนโลยี Dual Barrier Coating ลดการสะสมของฝุ่นและคราบน้ำมัน ใช้น้ำยาทำความเย็น R32 ที่เป็นมิตรต่อสิ่งแวดล้อม',

    'TCL': 'แบรนด์จีนที่ให้ความคุ้มค่าราคาประหยัด ระบบ Gentle Breeze กระจายลมได้อย่างนุ่มนวล คอมเพรสเซอร์ Inverter ช่วยประหยัดไฟ ดีไซน์ทันสมัย รองรับการควบคุมผ่านแอป',

    'MIDEA': 'แบรนด์จีนที่เป็นผู้ผลิตเครื่องปรับอากาศรายใหญ่ระดับโลก มีระบบ Flash Cooling ทำให้เย็นเร็ว เทคโนโลยี i-Clean ช่วยทำความสะอาดตัวเอง รองรับการควบคุมผ่านแอปสมาร์ทโฟน'
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(brand),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'brand-$brand',  // Matching tag from BrandCard
              child: Container(
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
                      icon: const Icon(Icons.error_outline, color: Colors.red),
                      label: const Text(
                        'รหัสข้อผิดพลาด',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red),
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
          'code': '4C/4E',
          'problem': 'ปัญหาระบบน้ำ',
          'solution': '1. ตรวจสอบวาล์วน้ำ\n2. ตรวจสอบท่อน้ำ\n3. ตรวจสอบตัวกรองที่อุดตัน'
        },
        {
          'code': '5C/5E',
          'problem': 'ปัญหาการระบายน้ำ',
          'solution': '1. ตรวจสอบท่อระบายน้ำไม่ให้อุดตัน\n2. ทำความสะอาดตัวกรองน้ำทิ้ง'
        },
        {
          'code': '3C/3E',
          'problem': 'มอเตอร์ผิดปกติหรือทำงานหนักเกินไป',
          'solution': '1. ลดปริมาณการใช้งาน\n2. รีสตาร์ทเครื่อง'
        }
      ],
      'PANASONIC': [
        {
          'code': 'E01',
          'problem': 'ประตูไม่ล็อค',
          'solution': '1. ตรวจสอบการจัดตำแหน่งประตู\n2. ตรวจสอบการปิดประตูให้สนิท'
        },
        {
          'code': 'E02',
          'problem': 'ปัญหาการจ่ายน้ำ',
          'solution': '1. ตรวจสอบวาล์วน้ำเข้า\n2. ตรวจสอบแหล่งจ่ายน้ำ'
        },
        {
          'code': 'E03',
          'problem': 'ปั๊มทำงานผิดปกติ',
          'solution': '1. ตรวจสอบปั๊ม\n2. ทำความสะอาดตัวกรอง\n3. ติดต่อช่างซ่อม'
        }
      ],
      'TOSHIBA': [
        {
          'code': 'E1',
          'problem': 'ปัญหาการระบายน้ำ',
          'solution': '1. ตรวจสอบการเชื่อมต่อท่อระบายน้ำ\n2. กำจัดสิ่งอุดตัน\n3. ตรวจสอบความสูงของท่อระบายน้ำ'
        },
        {
          'code': 'E2',
          'problem': 'ฝาปิดมีปัญหา',
          'solution': '1. ปิดฝาให้สนิท\n2. นำสิ่งแปลกปลอมออก\n3. ตรวจสอบกลไกฝาปิด'
        },
        {
          'code': 'E3',
          'problem': 'น้ำหนักไม่สมดุล',
          'solution': '1. จัดเรียงเสื้อผ้าใหม่ให้กระจายตัว\n2. ปรับระดับเครื่อง'
        }
      ],
      'HITACHI': [
        {
          'code': 'E01',
          'problem': 'ล็อคประตูมีปัญหา',
          'solution': '1. ตรวจสอบกลไกล็อคประตู\n2. ตรวจสอบการปิดประตูให้สนิท'
        },
        {
          'code': 'E02',
          'problem': 'ปัญหาน้ำเข้า',
          'solution': '1. ตรวจสอบแหล่งจ่ายน้ำ\n2. ตรวจสอบวาล์วน้ำเข้า\n3. กำจัดสิ่งอุดตัน'
        },
        {
          'code': 'E03',
          'problem': 'ปัญหาการระบายน้ำ',
          'solution': '1. ตรวจสอบปั๊มระบายน้ำ\n2. ทำความสะอาดท่อที่อุดตัน\n3. ทำความสะอาดตัวกรอง'
        }
      ],
      'LG': [
        {
          'code': 'UE',
          'problem': 'น้ำหนักไม่สมดุล',
          'solution': '1. จัดเรียงของให้สมดุล\n2. ตรวจสอบระดับเครื่อง\n3. ลดปริมาณของ'
        },
        {
          'code': 'OE',
          'problem': 'ปัญหาการระบายน้ำ',
          'solution': '1. ตรวจสอบตัวกรองน้ำทิ้ง\n2. ตรวจสอบท่อระบายน้ำ\n3. ตรวจสอบปั๊ม'
        }
      ],
      'CARRIER': [
        {
          'code': 'E1',
          'problem': 'มอเตอร์พัดลมภายในผิดปกติ',
          'solution': '1. ตรวจสอบการเชื่อมต่อมอเตอร์พัดลม\n2. เปลี่ยนมอเตอร์พัดลมถ้าเสีย\n3. ตรวจสอบแผงควบคุม'
        },
        {
          'code': 'E2',
          'problem': 'เซ็นเซอร์อุณหภูมิผิดปกติ',
          'solution': '1. ตรวจสอบการเชื่อมต่อเซ็นเซอร์\n2. เปลี่ยนเซ็นเซอร์ที่เสีย\n3. ตรวจสอบแผงควบคุม'
        },
        {
          'code': 'E3',
          'problem': 'การสื่อสารผิดพลาด',
          'solution': '1. ตรวจสอบสายไฟระหว่างชุด\n2. รีเซ็ตไฟ\n3. ตรวจสอบแผงควบคุม'
        }
      ],
      'DAIKIN': [
        {
          'code': 'A1',
          'problem': 'แผงวงจรมีปัญหา',
          'solution': '1. ตรวจสอบการเชื่อมต่อแผงวงจร\n2. รีเซ็ตไฟ\n3. เปลี่ยนแผงวงจรถ้าจำเป็น'
        },
        {
          'code': 'A5',
          'problem': 'ระบบป้องกันน้ำแข็ง/ความร้อนเกิน',
          'solution': '1. ทำความสะอาดแผ่นกรองอากาศ\n2. ตรวจสอบน้ำยา\n3. ตรวจสอบสิ่งกีดขวาง'
        },
        {
          'code': 'E7',
          'problem': 'มอเตอร์พัดลมทำงานผิดปกติ',
          'solution': '1. ตรวจสอบมอเตอร์พัดลม\n2. กำจัดสิ่งกีดขวาง\n3. เปลี่ยนถ้าชำรุด'
        }
      ],
      'GREE': [
        {
          'code': 'E1',
          'problem': 'ระบบป้องกันความดันสูง',
          'solution': '1. ตรวจสอบระดับน้ำยา\n2. ทำความสะอาดคอนเดนเซอร์\n3. ตรวจสอบพัดลมคอยล์ร้อน'
        },
        {
          'code': 'E2',
          'problem': 'ระบบป้องกันน้ำแข็ง',
          'solution': '1. ทำความสะอาดแผ่นกรอง\n2. ตรวจสอบน้ำยา\n3. ตรวจสอบพัดลมคอยล์เย็น'
        },
        {
          'code': 'E6',
          'problem': 'การสื่อสารผิดพลาด',
          'solution': '1. ตรวจสอบสายสัญญาณ\n2. ตรวจสอบแรงดันไฟฟ้า\n3. ตรวจสอบแผงวงจร'
        }
      ],
      'HAIER': [
        {
          'code': 'E1',
          'problem': 'เซ็นเซอร์อุณหภูมิห้องผิดปกติ',
          'solution': '1. ตรวจสอบการเชื่อมต่อเซ็นเซอร์\n2. เปลี่ยนเซ็นเซอร์\n3. ตรวจสอบแผงวงจร'
        },
        {
          'code': 'E2',
          'problem': 'เซ็นเซอร์อุณหภูมิภายนอกผิดปกติ',
          'solution': '1. ตรวจสอบการเชื่อมต่อเซ็นเซอร์\n2. เปลี่ยนถ้าเสีย\n3. ตรวจสอบสายไฟ'
        },
        {
          'code': 'F1',
          'problem': 'คอมเพรสเซอร์ทำงานหนักเกินไป',
          'solution': '1. ตรวจสอบน้ำยา\n2. ทำความสะอาดระบบ\n3. ตรวจสอบคอมเพรสเซอร์'
        }
      ],
      'HISENSE': [
        {
          'code': 'E1',
          'problem': 'คอยล์เย็นผิดปกติ',
          'solution': '1. ตรวจสอบคอยล์เย็น\n2. ตรวจสอบการเชื่อมต่อ\n3. รีเซ็ตไฟ'
        },
        {
          'code': 'F0',
          'problem': 'น้ำยารั่ว',
          'solution': '1. ตรวจหารอยรั่ว\n2. ซ่อมรอยรั่ว\n3. เติมน้ำยา'
        },
        {
          'code': 'H6',
          'problem': 'มอเตอร์พัดลมผิดปกติ',
          'solution': '1. ตรวจสอบมอเตอร์พัดลม\n2. กำจัดสิ่งกีดขวาง\n3. เปลี่ยนถ้าจำเป็น'
        }
      ],
      'MITSUBISHI': [
        {
          'code': 'E1',
          'problem': 'เซ็นเซอร์อุณหภูมิผิดปกติ',
          'solution': '1. ตรวจสอบการเชื่อมต่อเซ็นเซอร์\n2. เปลี่ยนเซ็นเซอร์\n3. ตรวจสอบแผงวงจร'
        },
        {
          'code': 'E6',
          'problem': 'มอเตอร์พัดลมคอยล์เย็นผิดปกติ',
          'solution': '1. ตรวจสอบมอเตอร์\n2. กำจัดสิ่งกีดขวาง\n3. เปลี่ยนถ้าเสีย'
        },
        {
          'code': 'E9',
          'problem': 'ปั๊มระบายน้ำผิดปกติ',
          'solution': '1. ตรวจสอบปั๊มระบายน้ำ\n2. ทำความสะอาดท่อระบายน้ำ\n3. ตรวจสอบลูกลอยน้ำ'
        }
      ],
      'TCL': [
        {
          'code': 'E1',
          'problem': 'เซ็นเซอร์อุณหภูมิห้องเสีย',
          'solution': '1. ตรวจสอบเซ็นเซอร์\n2. เปลี่ยนถ้าชำรุด\n3. ตรวจสอบการเชื่อมต่อ'
        },
        {
          'code': 'E2',
          'problem': 'เซ็นเซอร์ท่อทำความเย็นเสีย',
          'solution': '1. ตรวจสอบเซ็นเซอร์\n2. ตรวจสอบสายไฟ\n3. เปลี่ยนเซ็นเซอร์'
        },
        {
          'code': 'E4',
          'problem': 'มอเตอร์พัดลมผิดปกติ',
          'solution': '1. ตรวจสอบมอเตอร์พัดลม\n2. กำจัดสิ่งกีดขวาง\n3. เปลี่ยนมอเตอร์'
        }
      ],
      'MIDEA': [
        {
          'code': 'E1',
          'problem': 'เซ็นเซอร์อุณหภูมิห้องเสีย',
          'solution': '1. ตรวจสอบการเชื่อมต่อเซ็นเซอร์\n2. เปลี่ยนเซ็นเซอร์\n3. ตรวจสอบแผงวงจร'
        },
        {
          'code': 'F0',
          'problem': 'โหมดกู้คืนน้ำยา',
          'solution': '1. ตรวจสอบระดับน้ำยา\n2. ตรวจหารอยรั่ว\n3. ต้องการการซ่อมบำรุง'
        },
        {
          'code': 'E6',
          'problem': 'การสื่อสารผิดพลาด',
          'solution': '1. ตรวจสอบสายไฟ\n2. รีเซ็ตไฟ\n3. ตรวจสอบแผงควบคุม'
        }
      ]
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
                      Row(
                        children: [
                          const Text(
                            'วิธีแก้ไข:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.build,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
