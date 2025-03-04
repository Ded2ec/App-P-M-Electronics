import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const MyApp());
}

// ====== Main App Configuration ======
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P&M Electronics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}

// ====== Splash Screen Page ======
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _showProgress = false;
  bool _showText = true;
  late Animation<double> _textOpacity;
  late Animation<double> _imageOpacity;
  late Animation<double> _progressOpacity;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _textOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _imageOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _progressOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _showProgress = true;
      });
      _progressController.forward();
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
        context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              const MyHomePage(title: 'P&M Electronics'),
            transitionDuration: const Duration(milliseconds: 1500), 
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation( 
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              );
            },
          ),
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
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _textOpacity,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacity.value,
                    child: Container( 
                      height: 50, 
                      alignment: Alignment.center, 
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false, 
                          animatedTexts: [
                            RotateAnimatedText(
                              'Air Tech',
                              textStyle: const TextStyle(
                                fontSize: 38.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              rotateOut: false, 
                              duration: const Duration(milliseconds: 1500),
                            ),
                          ],
                          totalRepeatCount: 1,
                          displayFullTextOnTap: false,
                          stopPauseOnTap: false,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _imageOpacity,
                child: Container(  
                  width: 350,
                  height: 350,
                  alignment: Alignment.center, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
          child: SvgPicture.asset(
            'assets/images/output.svg',
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
              if (_showProgress) ...[
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _progressOpacity,
                  child: Padding(
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
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ====== Home Page ======
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Color appBackgroundColor;
  static Color textColor = Colors.black;
  static Color brandTextColor = Colors.black;
  final searchController = TextEditingController();
  String searchQuery = '';
  List<String> recentBrands = [];

  final Color _defaultCardColor = const Color(0xFFE0E0E0);
  final Color _defaultAppColor = Colors.white;
  final Color _defaultAppBarColor = Colors.blue;
  static Color appBarColor = Colors.blue;
  static Color cardBackgroundColor = const Color(0xFFE0E0E0);

  final List<Color> textColorOptions = [
    Colors.black,      // Default
    Colors.blue,       // Blue
    Colors.red,       // Red
    Colors.green,     // Green
    Colors.purple,    // Purple
    Colors.orange,    // Orange
    Colors.teal,      // Teal
    Colors.indigo,    // Indigo
  ];

  // Add color name mapping
  final Map<Color, String> colorNames = {
    Colors.black: 'สีดำ',
    Colors.blue: 'สีน้ำเงิน',
    Colors.red: 'สีแดง',
    Colors.green: 'สีเขียว',
    Colors.purple: 'สีม่วง',
    Colors.orange: 'สีส้ม',
    Colors.teal: 'สีเขียวมิ้นท์',
    Colors.indigo: 'สีน้ำเงินเข้ม',
  };

  List<Map<String, dynamic>> brands = [
    {'name': 'PANASONIC', 'image': 'assets/images/list-panasonic.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'LG', 'image': 'assets/images/list-lg.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'CARRIER', 'image': 'assets/images/list-carrier.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'DAIKIN', 'image': 'assets/images/list-daikin.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'HAIER', 'image': 'assets/images/list-haier.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': true},
    {'name': 'MITSUBISHI', 'image': 'assets/images/list-mitsubishi.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'TCL', 'image': 'assets/images/list-tcl.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
  ];

  List<Map<String, dynamic>> getFilteredBrands() {
    if (searchQuery.isEmpty) {
      return brands;
    }
    return brands.where((brand) =>
      brand['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
      brand['subtitle']!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadColors();
    _loadRecentBrands();
  }

  Future<void> _loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      appBackgroundColor = Color(prefs.getInt('backgroundColor') ?? Colors.white.value);
      cardBackgroundColor = Color(prefs.getInt('cardColor') ?? _defaultCardColor.value);
      appBarColor = Color(prefs.getInt('appBarColor') ?? _defaultAppBarColor.value);
      textColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
      brandTextColor = textColor;
    });
  }

  Future<void> saveColors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cardColor', cardBackgroundColor.value);
    await prefs.setInt('appColor', appBackgroundColor.value);
    await prefs.setInt('appBarColor', appBarColor.value);
    await prefs.setInt('textColor', textColor.value);
  }

  void resetColors() {
    setState(() {
      cardBackgroundColor = _defaultCardColor;
      appBackgroundColor = _defaultAppColor;
      appBarColor = _defaultAppBarColor;
      textColor = Colors.black;
      brandTextColor = Colors.black;
    });
    saveColors(); 
  }

  Future<void> _loadRecentBrands() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentBrands = prefs.getStringList('recentBrands') ?? [];
    });
  }

  Future<void> saveRecentBrand(String brand) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { 
      recentBrands.remove(brand); 
      recentBrands.insert(0, brand); 
      if (recentBrands.length > 3) { 
        recentBrands = recentBrands.sublist(0, 3); 
      }
    });
    await prefs.setStringList('recentBrands', recentBrands);
  }

  void _showColorPickerDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(type == 'card' ? 'เลือกสีพื้นหลัง Card' : 
                     type == 'appbar' ? 'เลือกสี AppBar' : 'เลือกสีตัวหนังสือ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: type == 'text' ? [
              // Text color options with names
              ...textColorOptions.map((color) => ListTile(
                title: Text(
                  colorNames[color] ?? 'สี',
                  style: TextStyle(color: color),
                ),
                tileColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    textColor = color;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              )).toList(),
            ] : type == 'card' ? [
              // สีอ่อนสำหรับ Card
              ListTile(
                title: const Text('Soft Blue'),
                tileColor: const Color(0xFFE3F2FD),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFE3F2FD);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Soft Pink'),
                tileColor: const Color(0xFFFCE4EC),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFFCE4EC);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Soft Green'),
                tileColor: const Color(0xFFE8F5E9),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFE8F5E9);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Soft Purple'),
                tileColor: const Color(0xFFF3E5F5),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFF3E5F5);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Soft Yellow'),
                tileColor: const Color(0xFFFFFDE7),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFFFFDE7);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Soft Orange'),
                tileColor: const Color(0xFFFFF3E0),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFFFF3E0);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Soft Cyan'),
                tileColor: const Color(0xFFE0F7FA),
                onTap: () {
                  setState(() {
                    cardBackgroundColor = const Color(0xFFE0F7FA);
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
            ] : [
              // สีเข้มสำหรับ AppBar
              ListTile(
                title: const Text('Blue'),
                tileColor: Colors.blue,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.blue;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Red'),
                tileColor: Colors.red,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.red;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Green'),
                tileColor: Colors.green,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.green;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Purple'),
                tileColor: Colors.purple,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.purple;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Orange'),
                tileColor: Colors.orange,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.orange;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Teal'),
                tileColor: Colors.teal,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.teal;
                  });
                  saveColors();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Indigo'),
                tileColor: Colors.indigo,
                onTap: () {
                  setState(() {
                    appBarColor = Colors.indigo;
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (appBackgroundColor == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredBrands = getFilteredBrands();

    return GestureDetector(
      onTap: () {
        searchController.clear();
        setState(() {
          searchQuery = '';
        });
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          toolbarHeight: 140,
          title: Column(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ค้นหาแบรนด์...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    size: 26,
                  ),
                  onPressed: () => _showSettingsDialog(context),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    'แบรนด์ยอดนิยม',
              style: TextStyle(
                      fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredBrands.length,
                    itemBuilder: (context, index) {
                      final brand = filteredBrands[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: BrandCard(
                          brand: brand['name']!,
                          subtitle: brand['subtitle']!,
                          image: brand['image']!,
                    isSvg: true,
                          backgroundColor: cardBackgroundColor,
                          isOutdoorOnly: brand['isOutdoorOnly']!,
                        ),
                      );
                    },
                  ),
                ),
                if (recentBrands.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Text(
                      'เข้าชมล่าสุด',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentBrands.length,
                    itemBuilder: (context, index) {
                      final brandName = recentBrands[index];
                      final brand = brands.firstWhere(
                        (b) => b['name'] == brandName,
                        orElse: () => brands[0],
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Card(
                          elevation: 1,
                          color: cardBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: Container(
                              width: 36,
                              height: 36,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: SvgPicture.asset(
                                brand['image']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            title: Text(
                              brand['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              brand['subtitle']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor.withOpacity(0.7),
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: textColor.withOpacity(0.7),
                            ),
                            onTap: () async {
                              await saveRecentBrand(brand['name']!);
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BrandDetailScreen(
                                      brand: brand['name']!,
                                      image: brand['image']!,
                                      isSvg: true,
                                      isOutdoorOnly: brand['isOutdoorOnly']!,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ตั้งค่าธีม',
                style: TextStyle(fontSize: 20),
              ),
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
              _buildSettingsTile(
                'เปลี่ยนสีแถบด้านบน',
                Icons.palette,
                () {
                  Navigator.pop(context);
                  _showColorPickerDialog('appbar');
                },
              ),
              _buildSettingsTile(
                'เปลี่ยนสีพื้นหลังเมนู',
                Icons.format_paint,
                () {
                  Navigator.pop(context);
                  _showColorPickerDialog('card');
                },
              ),
              _buildSettingsTile(
                'เปลี่ยนสีตัวหนังสือ',
                Icons.text_fields,
                () {
                  Navigator.pop(context);
                  _showColorPickerDialog('text');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// ====== Brand Card Widget ======
class BrandCard extends StatelessWidget {
  final String brand;
  final String subtitle;
  final String image;
  final bool isSvg;
  final Color backgroundColor;
  final bool isOutdoorOnly;

  const BrandCard({
    super.key,
    required this.brand,
    required this.subtitle,
    required this.image,
    required this.isSvg,
    required this.backgroundColor,
    required this.isOutdoorOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'brand-$brand',
      child: Material(
        child: GestureDetector(
          onTap: () async {
            if (context.findAncestorStateOfType<_MyHomePageState>() != null) {
              final homeState = context.findAncestorStateOfType<_MyHomePageState>()!;
              homeState.searchController.clear();
              homeState.setState(() {
                homeState.searchQuery = '';
              });
              homeState.saveRecentBrand(brand);
            }
            
            if (context.mounted) {
              Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BrandDetailScreen(
              brand: brand,
              image: image,
              isSvg: isSvg,
                    isOutdoorOnly: isOutdoorOnly,
            ),
          ),
        );
            }
      },
      child: Container(
            width: 180,
            height: 260,
        decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
        ),
        child: Column(
          children: [
                Expanded(
                  flex: 3,
              child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        image,
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                        placeholderBuilder: (BuildContext context) => Container(
                          width: 140,
                          height: 140,
                          child: const Center(
                            child: CircularProgressIndicator(),
                      ),
              ),
            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: FutureBuilder<SharedPreferences>(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        final textColor = snapshot.hasData 
                            ? Color(snapshot.data!.getInt('textColor') ?? Colors.black.value)
                            : Colors.black;
                        
                        return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    brand,
                              style: TextStyle(
                                fontSize: 20,
                      fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            if (isOutdoorOnly)
                              const Text(
                                'Outdoor Unit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else
                  Text(
                    subtitle,
                    style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                  ),
                ],
                        );
                      },
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

// ====== Brand Detail Page ======
class BrandDetailScreen extends StatelessWidget {
  static final Map<String, String> brandDescriptions = {
    'PANASONIC': 'แบรนด์ญี่ปุ่นที่มีประวัติยาวนานในการผลิตเครื่องใช้ไฟฟ้า โดดเด่นด้านเทคโนโลยี Inverter ที่ให้พลังงานคงที่ในระดับกลางและต่ำ มีระบบฟอกอากาศและควบคุมความชื้นอัตโนมัติ การออกแบบที่ทันสมัยและประหยัดพลังงาน',
    'LG': 'แบรนด์เกาหลีที่โดดเด่นด้านดีไซน์และเทคโนโลยี AI มีระบบ Dual Inverter Compressor ประหยัดพลังงานและลดเสียงรบกวน ฟังก์ชัน ThinQ ควบคุมแอร์ผ่านสมาร์ทโฟน มีระบบฟอกอากาศและฆ่าเชื้อแบคทีเรีย',
    'CARRIER': 'แบรนด์อเมริกันที่เป็นผู้นำด้านระบบปรับอากาศ มีเทคโนโลยี Smart Auto Mode ปรับความเร็วพัดลมอัตโนมัติตามคุณภาพอากาศ ระบบกรองอากาศประสิทธิภาพสูง และการควบคุมอุณหภูมิที่แม่นยำ',
    'DAIKIN': 'แบรนด์ญี่ปุ่นที่มีชื่อเสียงด้านเทคโนโลยีระบบปรับอากาศระดับโลก มีระบบ Streamer Discharge ที่ช่วยฟอกอากาศและฆ่าเชื้อโรค เทคโนโลยี Inverter ประหยัดพลังงานสูง คอมเพรสเซอร์ทนทาน และระบบควบคุมอุณหภูมิแม่นยำ',
    'HAIER': 'แบรนด์จีนที่มีความเชี่ยวชาญด้านอุปกรณ์เครื่องใช้ไฟฟ้า เทคโนโลยี Self-Cleaning ป้องกันเชื้อราและแบคทีเรีย ระบบ Hyper PCB ทำให้ทำงานได้เสถียรแม้ไฟตก คอมเพรสเซอร์ทนทานและประหยัดพลังงาน',
    'MITSUBISHI': 'แบรนด์ญี่ปุ่นที่ขึ้นชื่อเรื่องความทนทานและประหยัดพลังงาน ระบบ Fast Cooling ทำให้เย็นเร็วทันใจ เทคโนโลยี Dual Barrier Coating ลดการสะสมของฝุ่นและคราบน้ำมัน ใช้น้ำยาทำความเย็น R32 ที่เป็นมิตรต่อสิ่งแวดล้อม',
    'TCL': 'แบรนด์จีนที่ให้ความคุ้มค่าราคาประหยัด ระบบ Gentle Breeze กระจายลมได้อย่างนุ่มนวล คอมเพรสเซอร์ Inverter ช่วยประหยัดไฟ ดีไซน์ทันสมัย รองรับการควบคุมผ่านแอป',
    
  };

  final String brand;
  final String image;
  final bool isSvg;
  final bool isOutdoorOnly;

  const BrandDetailScreen({
    required this.brand,
    required this.image,
    required this.isSvg,
    required this.isOutdoorOnly,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brand),
        backgroundColor: _MyHomePageState.appBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'brand-$brand',
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
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'ข้อมูลเครื่องปรับอากาศ ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: brand,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _MyHomePageState.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    brandDescriptions[brand] ?? 'Brand description not available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: _MyHomePageState.textColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // แก้ไขส่วนนี้เพื่อนำทางไปยังหน้า Error Code ที่เหมาะสม
                        Widget errorPage;
                        if (brand == 'CARRIER') {
                          errorPage = const CarrierErrorCodePage();
                        } else if (brand == 'DAIKIN') {
                          errorPage = const DaikinErrorCodePage();
                        } else if (brand == 'TCL') {
                          errorPage = const TclErrorCodePage();
                        } else if (brand == 'HAIER') {
                          errorPage = const HaierErrorCodePage();
                        } else if (brand == 'LG') {
                          errorPage = const LGErrorCodePage();
                        } else if (brand == 'PANASONIC') {
                          errorPage = const PanasonicErrorCodePage();
                        } else if (brand == 'MITSUBISHI') {
                          errorPage = const MitsubishiErrorCodePage();
                        } else {
                          return; // ไม่มีหน้า Error Code สำหรับแบรนด์นี้
                        }
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => errorPage,
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

// ====== Error Code Page ======
class ErrorCodeScreen extends StatefulWidget {
  final String brand;
  final bool isOutdoorOnly;

  const ErrorCodeScreen({
    required this.brand,
    required this.isOutdoorOnly,
    Key? key,
  }) : super(key: key);

  @override
  State<ErrorCodeScreen> createState() => _ErrorCodeScreenState();
}

class _ErrorCodeScreenState extends State<ErrorCodeScreen> {
  String searchQuery = '';
  Color brandTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadTextColor();
  }

  Future<void> _loadTextColor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      brandTextColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String baseBrand = widget.brand.split(' (')[0];
    final bool hasOuterText = widget.brand.contains('(ตัวนอก)');

    final Map<String, List<Map<String, dynamic>>> errorCodes = {
      'TCL': [
    {
        'code': 'P0',
        'problem': 'บอร์ด IPM module ทำงานผิดพลาด',
       
    },
    {
        'code': 'P1',
        'problem': 'แรงดันไฟฟ้าสูงหรือต่ำเกินไป',
       
    },
    {
        'code': 'P2',
        'problem': 'กระแสไฟฟ้าสูงเกินไป',
       
    },
    {
        'code': 'P4',
        'problem': 'เซนเซอร์ตรวจวัดอุณหภูมิท่อ Discharge outdoor มีอุณหภูมิสูงเกินไป',
       
    },
    {
        'code': 'P5',
        'problem': 'ตรวจสอบระบบน้ำยาในโหมด Cooling เนื่องจากอุณหภูมิท่อทางเข้าของส่วน Subcooling',
       
    },
    {
        'code': 'P6',
        'problem': 'ตรวจสอบระบบน้ำยาในโหมด Cooling เนื่องจากท่อมีอุณหภูมิสูงเกินไป',
       
    },
    {
        'code': 'P7',
        'problem': 'ตรวจสอบระบบน้ำยาในโหมด Heating เนื่องจากท่อมีอุณหภูมิสูงเกินไป',
       
    },
    {
        'code': 'P8',
        'problem': 'เซนเซอร์ตรวจวัดอุณหภูมิภายนอกค่าสูงหรือต่ำเกินไป',
       
    },
    {
        'code': 'P9',
        'problem': 'คอมเพรสเซอร์ทำงานผิดปกติ',
       
    },
    {
        'code': 'PA',
        'problem': 'การสื่อสารผิดพลาด สำหรับ TOP / Preset mode มีปัญหา',
       
    },
    {
        'code': 'F0',
        'problem': 'เซนเซอร์รับคำสั่งหรือตรวจสอบความรู้สึกของผู้ใช้งานทำงานผิดพลาด',
       
    },
    {
        'code': 'F1',
        'problem': 'โมดูลตรวจสอบกำลังไฟทำงานผิดพลาด',
       
    },
    {
        'code': 'F2',
        'problem': 'เซนเซอร์อุณหภูมิของท่อ Discharge ทำงานผิดพลาด',
       
    },
    {
        'code': 'F3',
        'problem': 'อุณหภูมิของคอยล์ร้อนผิดปกติ',
       
    },
    {
        'code': 'F4',
        'problem': 'ระบบการไหลของน้ำยาผิดปกติ',
       
    },
    {
        'code': 'F5',
        'problem': 'ตรวจจับกระแสไฟฟ้าสูงเกินไป / PFC สูงเกินไป',
       
    },
    {
        'code': 'F6',
        'problem': 'กระแสไฟฟ้าวงจรของคอมเพรสเซอร์',
       
    },
    {
        'code': 'F7',
        'problem': 'อุณหภูมิของบอร์ดโมดูลผิดปกติ',
       
    },
    {
        'code': 'F8',
        'problem': 'ตัวของ 4-Way สูงผิดปกติ',
       
    },
    {
        'code': 'F9',
        'problem': 'วงจรทดสอบอุณหภูมิของบอร์ดโมดูลทำงานผิดพลาด',
       
    },
    {
        'code': 'FA',
        'problem': 'วงจรทดสอบกระแสเฟสของคอมเพรสเซอร์ทำงานผิดพลาด',
       
    },
    {
        'code': 'Fb',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการทำความเย็นหรือทำความร้อนเกินไปในโหมด Cooling/โหมด Heating',
       
    },
    {
        'code': 'FC',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการใช้พลังงานสูงเกินไป',
       
    },
    {
        'code': 'FE',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการกินกระแสของมอเตอร์โมดูล (เฟสของคอมเพรสเซอร์)',
       
    },
    {
        'code': 'FF',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันอุณหภูมิของมอเตอร์โมดูล',
       
    },
    {
        'code': 'FH',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการทำงานของคอมเพรสเซอร์',
       
    },
    {
        'code': 'FP',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการเกิดแผ่นน้ำแข็ง',
       
    },
    {
        'code': 'FU',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการบกพร่องส่วนอื่นๆ',
       
    },
    {
        'code': 'FJ',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันอุณหภูมิของท่อ Discharge',
       
    },
    {
        'code': 'Fn',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการกินกระแสของส่วน Outdoor',
       
    },
    {
        'code': 'H1',
        'problem': 'การสลับระบบการทำความเย็นแรงดันสูงผิดปกติ',
       
    },
    {
        'code': 'H2',
        'problem': 'การสลับระบบการทำความเย็นแรงดันต่ำผิดปกติ',
       
    },
    {
        'code': 'BJ',
        'problem': 'เซนเซอร์วัดความชื้นทำงานผิดพลาด',
       
    },
    {
        'code': 'BF',
        'problem': 'TVOC เซ็นเซอร์ มีปัญหา',
       
    },
    {
        'code': 'BD',
        'problem': 'มอเตอร์พัดลมดูดอากาศมีปัญหา',
       
    },
    {
        'code': 'D4',
        'problem': 'ระบบระบายน้ำทิ้งมีปัญหา',
       
    },
    {
        'code': '2A 3A 4A 5A 6A 7A 8A 9A 0A',
        'problem': 'ถ้าปิดโหมดสแตนบาย โหลดบกเลิกออกโดยการกดปุ่ม GEN หรือโหมดกดปุ่มจนกว่าหน้าจอโทรโชว์ OF แล้วปล่อยมือ ประมาณ 5 วินาทีพัดลมก็จะหยุดไปหลังจากนั้นคอมเพรสเซอร์จะกลับมาทำงาน 100% หรือ เป็นเดิมที',
       
    },
    {
        'code': 'CF PP SA AP',
        'problem': 'ไม่ใช่ error code แต่มันคือการส่งสัญญาณเพื่อเชื่อมต่อหา wifi ในลักษณะนี้จะมีในแอร์รุ่นที่เชื่อมต่อ wifi ได้ครับ เป็นการทำงานปกติ',
       
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
        },
        {
          'code': 'OE',
          'problem': 'ปัญหาการระบายน้ำ',
        },
        {
          'code': 'LE',
          'problem': 'ข้อผิดพลาดของเซ็นเซอร์รั่วไหล',
        },
        {
          'code': 'LO',
          'problem': 'แรงดันต่ำในระบบ',
        },
        {
          'code': 'nG',
          'problem': 'ตรวจพบการรั่วของก๊าซ',
        },
        {
          'code': 'PC',
          'problem': 'ข้อผิดพลาดของวงจร PFC',
        },
        {
          'code': 'PC1',
          'problem': 'ข้อผิดพลาดของเซ็นเซอร์กระแสไฟฟ้า PFC',
        },
        {
          'code': 'PC2', 
          'problem': 'ข้อผิดพลาดของเซ็นเซอร์แรงดันไฟฟ้า PFC',
        },
        {
          'code': 'PC3',
          'problem': 'ข้อผิดพลาดของวงจรควบคุม PFC',
        },
        {
          'code': 'PC4',
          'problem': 'ข้อผิดพลาดของวงจรตรวจจับกระแสไฟฟ้า PFC',
        },
        {
          'code': 'PH',
          'problem': 'อุณหภูมิฮีตซิงค์สูงผิดปกติ',
        },
        {
          'code': 'PO',
          'problem': 'แรงดันสูงในระบบ',
        },
        {
          'code': 'PS',
          'problem': 'ข้อผิดพลาดของแหล่งจ่ายไฟ DC',
        },
        {
          'code': 'AE',
          'problem': 'ข้อผิดพลาดของระบบอัตโนมัติ',
        },
        {
          'code': 'CE',
          'problem': 'ข้อผิดพลาดในการสื่อสาร',
        },
        {
          'code': 'H1',
          'problem': 'ข้อผิดพลาดของระบบควบคุมความชื้น',
        },
        {
          'code': 'HE',
          'problem': 'ข้อผิดพลาดของระบบทำความร้อน',
        },
        {
          'code': 'HH',
          'problem': 'อุณหภูมิสูงผิดปกติ',
        },
        {
          'code': 'HO',
          'problem': 'ข้อผิดพลาดของเซ็นเซอร์อุณหภูมิภายนอก',
        },
        {
          'code': 'L1',
          'problem': 'ข้อผิดพลาดของเซ็นเซอร์ระดับน้ำ',
        },
        {
          'code': 'L2',
          'problem': 'ระดับน้ำต่ำ',
        },
        {
          'code': 'L3',
          'problem': 'ระดับน้ำสูง',
        },
        {
          'code': 'dF',
          'problem': 'ข้อผิดพลาดในการละลายน้ำแข็ง',
        },
        {
          'code': 'FF',
          'problem': 'ข้อผิดพลาดของพัดลม',
        },
        {
          'code': 'IF',
          'problem': 'ข้อผิดพลาดของระบบกรองอากาศ',
        },
        {
          'code': 'OF',
          'problem': 'ข้อผิดพลาดของระบบระบายอากาศ',
        },
        {
          'code': 'P1',
          'problem': 'ข้อผิดพลาดของปั๊มระบายน้ำ',
        },
        {
          'code': 'P2',
          'problem': 'ข้อผิดพลาดของระบบป้องกันความดันสูง',
        },
        {
          'code': 'P3',
          'problem': 'ข้อผิดพลาดของระบบป้องกันความดันต่ำ',
        },
        {
          'code': 'P4',
          'problem': 'ข้อผิดพลาดของระบบป้องกันอุณหภูมิ',
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
          'code': ' on Remote H6',
          'problem': 'คอมเพรสเซอร์กินกระแสสูง',
        },
        {
          'code': 'on Remote H9',
          'problem': 'เซนเซอร์อุณหภูมิอากาศของชุดคอยล์ร้อนผิดปกติ',
        },
        {
          'code': 'J3',
          'problem': 'เซนเซอร์อุณหภูมิท่อด้านส่งผิดปกติ',
        }
        ,
        {
          'code': 'J6',
          'problem': 'เซนเซอร์อุณหภูมิแลกเปลี่ยนความร้อนผิดปกติ',
        }
         ,
        {
          'code': 'J8',
          'problem': 'เซนเซอร์อุณหภูมิท่อของเหลวผิดปกติ',
        }
         ,
        {
          'code': 'E7',
          'problem': 'มอเตอร์พัดลมคอยล์ร้อนเสียหรือ PCB เสีย',
        }
      ],
    
      'HAIER': [
        {
          'code': 'E12',
          'LED_blink': 1,
          'problem': 'ข้อมูลใน EEPROM เสียหาย',
         
        },
        {
          'code': 'F1',
          'LED_blink': 2,
          'problem': 'เซนเซอร์ในห้อง',
         
        },
        {
          'code': 'F22',
          'LED_blink': 3,
          'problem': 'การแสดงฟังก์ชั่นการสูญเสียกำลังไฟ',
         
        },
        {
          'code': 'F3',
          'LED_blink': 4,
          'problem': 'การป้องกัน รันฟ์สร้อยกระทำงานบกพร่อง และเซนเซอร์ในห้อง',
         
        },
        {
          'code': 'F20',
          'LED_blink': 6,
          'problem': 'มอเตอร์เข้าไม่ถึงเครื่องสูงสุด หรือ ล้ำเกินไป',
         
        },
        {
          'code': 'F4',
          'LED_blink': 8,
          'problem': 'อุณหภูมิที่ท่อท่อเย็นวัดที่ท่อกลางๆ สูงเกินไป',
         
        },
        {
          'code': 'F21',
          'LED_blink': 10,
          'problem': 'เซนเซอร์ป้องกันน้ำซึมการทำแห้งคอนเดนเซอร์เสีย',
         
        },
        {
          'code': 'F6',
          'LED_blink': 12,
          'problem': 'เซนเซอร์ตรวจจับอุณหภูมิกระเปาะเปียกเสีย',
         
        },
        {
          'code': 'F25',
          'LED_blink': 13,
          'problem': 'เซนเซอร์ตรวจจับอุณหภูมิที่ท่อกลางเสีย',
         
        },
        {
          'code': 'F11',
          'LED_blink': 18,
          'problem': 'วงจรการจับค่าตำแหน่งของมอเตอร์เสียหา',
         
        },
        {
          'code': 'F28',
          'LED_blink': 19,
          'problem': 'เซนเซอร์ในห้อง',
         
        },
        {
          'code': 'F2',
          'LED_blink': 24,
          'problem': 'คอมเพรสเซอร์ไม่การะแสไฟ',
         
        },
        {
          'code': 'F23',
          'LED_blink': 25,
          'problem': 'การแสดงฟังก์ชั่นของกระแสไฟที่เข้าไฟเยอะๆ สูงไป',
         
        }
      ],
    };

    final brandCodes = errorCodes[widget.brand] ?? [];
    final filteredCodes = brandCodes.where((error) =>
      error['code']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
      error['problem']!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brand} Error Code'),
        backgroundColor: _MyHomePageState.appBarColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCodes.length,
        itemBuilder: (context, index) {
                final error = filteredCodes[index];
          return Card(
            margin: const EdgeInsets.all(8),
            color: _MyHomePageState.cardBackgroundColor,
            child: ExpansionTile(
              title: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Error: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '${error['code']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _MyHomePageState.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.brand == 'HAIER' && error['LED_blink'] != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ไฟกระพริบ ${error['LED_blink']} ครั้ง',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'ปัญหา: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: error['problem'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _MyHomePageState.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'สถานะ: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: error['status'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _MyHomePageState.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'การควบคุม: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: error['control'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _MyHomePageState.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'วิธีแก้ไข: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: error['solution'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _MyHomePageState.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                            Text(
                              'วิธีแก้ไข:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: brandTextColor,
                              ),
                      ),
                      const SizedBox(height: 8),
                            Text(
                              error['solution'] ?? '',
                              style: TextStyle(color: brandTextColor),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
            ),
          ),
        ],
      ),
    );
  }
}

// ====== Problem Card Widget ======
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

// เพิ่ม CarrierErrorCodePage class ใหม่
class CarrierErrorCodePage extends StatefulWidget {
  const CarrierErrorCodePage({Key? key}) : super(key: key);

  @override
  _CarrierErrorCodePageState createState() => _CarrierErrorCodePageState();
}

class _CarrierErrorCodePageState extends State<CarrierErrorCodePage> {
  String searchQuery = '';
  String selectedMainCode = '';
  String selectedGroup = '';

  // Add these constants at the top of the class
  static const String PROBLEM_LABEL = 'ปัญหา: ';
  static const String STATUS_LABEL = 'สถานะการทำงาน: ';
  static const String CONTROL_LABEL = 'จุดสังเกต: ';
  static const String SOLUTION_LABEL = 'วิธีแก้ไข: ';

  final Map<String, List<Map<String, String>>> errorData = {
    '00': [
      {
        'group': 'PC บอร์ด/ภายใน',
        'code': '0C',
        'problem': 'เซ็นเซอร์อุณหภูมิห้อง(TA)ขาดหรือขอร์ท',
        'status': 'ทำงานต่อเนื่อง',
        'control': 'แสดงว่าพบข้อบกพร่อง',
        'solution': '1. วัดเซ็นเซอร์อุณหภูมิห้อง\n \t\t             2. ถ้าเซ็นเซอร์ปกติตรวจ PC. บอร์ค',
      },
        {
        'group': 'PC บอร์ด/ภายใน',
        'code': '0D',
        'problem': 'สายสัญญาณไฟฟ้า (PowerTA) หลวมหรือหลุด',
        'status': 'หยุดทำงาน',
        'control': 'แสงดมลเมื่อพบข้อบกพร่อง',
        'solution': '1. ตรวจสอบสายไฟฟ้า\n \t\t             2. รีเซ็ทเครื่องหรือรีบูต PC นอก',
      },
        {
        'group': 'PC บอร์ด/ภายใน',
        'code': '11',
        'problem': 'ปัญหาจาก PC. บอร์ด อื่นๆ',
        'status': 'ดับหมด',
        'control': 'แสดงว่าเมื่อพบข้อบกพร่อง',
        'solution': 'เปลี่ยน PC. บอร์ด',
      },
        {
        'group': 'ไม่แสดง',
        'code': '12',
        'problem': 'ปัญหาจาก PC. บอร์ด อื่นๆ',
        'status': 'ทำงานต่อเนื่อง',
        'control': 'แสดงผลเมื่อพบข้อบกพร่อง 01',
        'solution': 'เปลี่ยน PC บอร์ด',
      }
      // เพิ่มข้อมูลอื่นๆs
    ],
    '01': [
      {
        'group': 'สายเชื่อมต่อสัญญาณอนุกรม',
        'code': '04',
        'problem': 'ไม่มีสัญญาณตอบกลับไปยังภายในเมื่อเริ่มทำงาน\n \t\t (1) สารเชื่อมต่อเสียง \n \t\t (2)สารทำความเย็นรั่วขาด เทอร์โมฯคอมเพรสเซอร์ทำงาน',
        'status': 'ทำงานต่อเนื่อง',
        'control': 'กระพริบเมื่อไม่มีสัญญาณตอบกลับปกติเมื่อสัญญาณรีเซ็ท',
        'solution': '1. เมื่อภายนอกไม่ทำงาน \n \t\t(1) วัดสายเชื่อมต่อและแก้ไข\n \t\t(2) วัดฟิวส์ 25A ชุดอินเวอร์เตอร์\n \t\t(3) ตรวจฟิวส์ 3.15A บนบอร์ดอินเวอร์เตอร์\n 2. ถ้ามีรหัสอีน ให้ดูเทอร์โมลดัทคอมเพรสเซอร์ตัด และปริมาณสารทำความเย็นรั่ว หรือขาด\n3. เครื่องทำงานปกติขณะทดสอบ ถ้ามีสัญญาณอนุกรมระหว่างขา 2 กับ 3 จุดต่อภายในเปลี่ยนบอร์ดอินเวอร์เตอร์ ถ้าไม่มีสัญญาณขา 2 กับ 3 เปลี่ยนบอร์ดชุดภายใน',
      },
       {
        'group': 'สายเชื่อมต่อสัญญาณอนุกรม',
        'code': '05',
        'problem': 'ไม่มีคำสั่งสัญญาณไปยังภายนอก',
        'status': 'ทำงานต่อเนื่อง',
        'control': 'กระพริบเมื่อไม่มีสัญญาณตอบกลับปกติเมื่อสัญญาณรีเซ็ท',
        'solution': 'เครื่องทำงานปกติขณะทดสอบถ้ามีสัญญาณอนุกรมระหว่าง ขา 2 กับ 3 จุดต่อภายในเปลี่ยนบอร์ดอินเวอร์เตอร์ ถ้าไม่มีสัญญาณขา 2 กับ 3 เปลี่ยนบอร์ดชุดภายใน',
      },
    ],
      '02': [
       {
    "group": "PC บอร์ดภายใน",
    "code": "14",
    "problem": "วงจรป้องกันกระแสเย็น-เวอร์เตอร์เกินทำงาน(ทำงานช่วงสั้นๆ)",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "เมื่อเปิดอีกครั้งการทำงานทั้งหมดหยุดทันทีเปลี่ยน PC. บอร์ด"
  },
  {
    "group": "PC บอร์ดภายใน",
    "code": "16",
    "problem": "วงจรตรวจสอบคำแหน่งมอเตอร์ซอร์ท",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "1. ถอดสายต่อคอมเพรสเซอร์ออกวงจรอ่านต่ำแหน่งไม่ทำงานเปลี่ยน PC. บอร์ด \n                2. วัดความด้านทานชดลวดคอม-เพรสเซอร์พบว่าซอร์ทเปลี่ยนคอมเพรสเซอร์"
  },
  {
    "group": "PC บอร์ดภายใน",
    "code": "17",
    "problem": "วงจรวัดกระแสทำงานผิดพลาด",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "เมื่อเปิดอีกครั้งการทำงานทั้งหมดหยุดทันทีเปลี่ยน PC. บอร์ด"
  },
  {
    "group": "PC บอร์ดภายใน",
    "code": "18",
    "problem": "สายเซ็นเชอร์อุณหภูมิอากาศ ภายนอกขาด หมุด หรือ ซอร์ท",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "1. วัดเซ็นเซอร์อุณหภูมิภายนอก(TE.) \n                2. ตรวจสอบ PC. บอร์ด"
  },
  {
    "group": "PC บอร์ดภายใน",
    "code": "19",
    "problem": "สายเข็นเชอร์อุณหภูมิติจชาร์จ หลุดหรือซอร์ท",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "1. ตรวจสอบเซ็นเซอร์อุณหภูมิติจชาร์จ(TD) \n                2. ตรวจสอบ PC. บอร์ด"
  },
  {
    "group": "PC บอร์ดภายใน",
    "code": "1A",
    "problem": "ระบบขับพัดลมภายนอกทำงาน ผิดพลาด",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "ตัวอ่านตำแหน่งทำงานผิดพลาดวงจรกระแสเกินทำงานจากมอเตอร์ติดชัดเป็นต้นเปลี่ยนPC. บอร์ดหรือมอเตอร์พัดลม"
  }
  ,
  {
    "group": "ไม่แสดงผล",
    "code": "1b",
    "problem": "เซ็นเซอร์วัดอุณภูมิภายนอกเสีย)",
    "status": "ทำงานต่อเนื่อง",
    "control": "-",
    "solution": "1. วัดเซ็นเซอร์ภายนอก(TE) \n 2. ตรวจสอบ PC. บอร์ด"
  },
  {
    "group": "PC บอร์ดภายนอก",
    "code": "1C",
    "problem": "วงจรขับคอมเพรสเซอร์เมียคอมเพรสเซอร์เสีย(ติดขัด เป็นต้น)",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "เมื่อทำงานได้ประมาณ 20 วินาทีวงจรอ่านตำแหน่งพบว่าบกพร่องต้องเปลี่ยนคอมเพรสเซอร์"
  }
    ],
    '03': [
      {
        "group": "ปัญหาอื่นรวมคอมเพรสเซอร์",
    "code": "07",
    "problem": "สัญญาณอนุกรมทำงานเริมต้นหลังจากนั้นหยุดส่ง\n   (1) เทอร์โมสคัทคอมเพรสเซอร์ตัดหรือสารทำความเย็นขาด, รั่ว\n   (2) ไฟฟ้ากระพริบ",
    "status": "ทำงานต่อเนื่อ",
    "control": "กระพริบเมื่อไม่มีสัญญาณตอบกลับปกติเมื่อสัญญาณรีเซ็ท",
    "solution": "1. ตัดต่อด้วยช่วงเวลาประมาณ 10-40นาที (ไม่มีรหัสบกพร่องเกิดขึ้น)ตรวจสอบสารทำความเย็นรั่วขาด\n                2. เครื่องทำงานปกติขณะทดสอบถ้ามีสัญญาณอนุกรมระหว่าง ขา 2 กับ 3 จุดต่อคอยล์เย็นเปลี่ยนบอร์คอินเวอร์เดอร์ ถ้าไม่มีสัญญาณขา 2 กับ 3 เปลี่ยนบอร์ดชุคคอยล์เย็น"
      },
         {
        "group": "ปัญหาอื่นรวมคอมเพรสเซอร์",
    "code": "1d",
    "problem": "คอมเพรสเซอร์ไม่หมุน(วงจะป้องกันไม่ทำงานเมื่อคอมทำงาน)",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "1. คอมเพรสเซอร์เสีย\n                2. ใส่สายคอมเพรสเซอร์ผิด(เฟสผิด)"
      },
      {
              "group": "ปัญหาอื่นรวมคอมเพรสเซอร์",
    "code": "1E",
    "problem": "คุณหภูมิคิงชาร์จเกิน 117°C",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "1. ตรวจเซ็นเซอร์ติจชาร์จ (TD) \n                2. เอาอากาศออก\n                3. PMV เสีย"
      },
       {
              "group": "ปัญหาอื่นรวมคอมเพรสเซอร์",
    "code": "1F",
    "problem": "คอมเพรสเซอร์เลีย",
    "status": "ดับหมด",
    "control": "แสดงผลเมื่อพบข้อบกพร่อง",
    "solution": "1. วัดแรงดันไฟฟ้า（220V士 10%6） \n                2. ระบบทำความเย็นโหลดเกิน ดูการติดตั้งและการระบายลมคอยล์ร้อนไม่ย้อนกลับ"
      },
      {
         "group": "ปัญหาอื่นรวมคอมเพรสเซอร์",
    "code": "08",
    "problem": "วาล์ว 4 ทางทำงานย้อนกลับ(เซ็นเซอร์ TC มีค่าต่ำในช่วงทำความร้อน)",
    "status": "ทำงานต่อเนื่อง",
    "control": "-",
    "solution": "1. ตรวจสอบการทำงานวาล์ว 4 ทาง"
      },
    ]
  };

  List<Map<String, String>> _getFilteredData() {
    // If no main code is selected, combine all data from all main codes
    if (selectedMainCode.isEmpty) {
      List<Map<String, String>> allData = [];
      errorData.values.forEach((codeList) {
        allData.addAll(codeList);
      });
      
      // Apply search filter if exists
      if (searchQuery.isNotEmpty) {
        return allData.where((error) =>
          error['code']!.toLowerCase().contains(searchQuery) ||
          error['problem']!.toLowerCase().contains(searchQuery) ||
          error['solution']!.toLowerCase().contains(searchQuery)
    ).toList();
      }
      
      return allData;
    }
    
    // If main code is selected, filter by main code
    var filteredList = errorData[selectedMainCode]!;
    
    // Apply group filter if selected
    if (selectedGroup.isNotEmpty) {
      filteredList = filteredList.where((error) => 
        error['group'] == selectedGroup
      ).toList();
    }
    
    // Apply search filter if exists
    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((error) =>
        error['code']!.toLowerCase().contains(searchQuery) ||
        error['problem']!.toLowerCase().contains(searchQuery) ||
        error['solution']!.toLowerCase().contains(searchQuery)
      ).toList();
    }
    
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CARRIER Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Main Code Selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('รหัสหลัก:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...errorData.keys.map((code) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(code),
                      selected: selectedMainCode == code,
                      onSelected: (selected) {
                        setState(() {
                          selectedMainCode = selected ? code : '';
                          selectedGroup = '';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedMainCode.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('กลุ่ม:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...errorData[selectedMainCode]!
                      .map((e) => e['group']!)
                      .toSet()
                      .map((group) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: FilterChip(
                            label: Text(group),
                            selected: selectedGroup == group,
                            onSelected: (selected) {
                              setState(() {
                                selectedGroup = selected ? group : '';
                              });
                            },
                          ),
                        ),
                      ),
                ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredData().length,
              itemBuilder: (context, index) {
                final error = _getFilteredData()[index];
                // Find the main code for this error
                String mainCode = '';
                errorData.forEach((key, value) {
                  if (value.any((e) => e['code'] == error['code'])) {
                    mainCode = key;
                  }
                });

                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Error: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${error['code']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _MyHomePageState.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
                              child: Text(
                                'รหัสหลัก: $mainCode',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'กลุ่ม: ${error['group']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: PROBLEM_LABEL,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: error['problem'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _MyHomePageState.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: STATUS_LABEL,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: error['status'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _MyHomePageState.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: CONTROL_LABEL,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: error['control'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _MyHomePageState.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: SOLUTION_LABEL,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: error['solution'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _MyHomePageState.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Add this new class after the ErrorCodeScreen class
class DaikinErrorCodePage extends StatefulWidget {
  const DaikinErrorCodePage({Key? key}) : super(key: key);

  @override
  _DaikinErrorCodePageState createState() => _DaikinErrorCodePageState();
}

class _DaikinErrorCodePageState extends State<DaikinErrorCodePage> {
  String searchQuery = '';

  final List<Map<String, String>> daikinErrors = [
    {
      'code': 'A1',
      'problem': 'แผง PCB ชุดคอยล์เย็นเสียหรือไฟฟ้าตก',
    },
     {
      'code': 'A5',
      'problem': 'ระบบป้องกันการเป็นน้ำแข็ง',
    },
     {
      'code': 'A6',
      'problem': 'มอเตอร์คอยล์เย็นเสียหรือแผง PCB เสีย',
    },
     {
      'code': 'C4',
      'problem': 'เซ็นเชอร์น้ำแข็งค่าความต้านทานผิดปกติ',
    },
     {
      'code': 'C9',
      'problem': 'เซ็นเซอร์อุณหภูมิค่าความต้านทานผิดปกติ',
    },
     {
      'code': 'CC',
      'problem': 'เซ็นเซอร์ความชื้นค่าความต้านทานผิดปกติ',
    },
     {
      'code': 'U4',
      'problem': 'การส่งสัญญาณระห่างชุดคอยล์เย็นกับคอยล์ร้อนผิดปกติหรือแผง PCB ชุดคอยล์ร้อนเสีย',
    },
     {
      'code': 'F3',
      'problem': 'การทำงานผิดปกติของอุณหภูมิท่อด้านจ่าย',
    },
     {
      'code': 'L5',
      'problem': 'คอมเพรสเซอร์หรือแผง PCB ชุดคอยล์ร้อนเสีย',
    },
     {
      'code': 'H6',
      'problem': 'คอมเพรสเซอร์กินกระแสสูง',
    },
    {
      'code': 'H9',
      'problem': 'เซนเซอร์อุณหภูมิอากาศของชุดคอยล์ร้อนผิดปกติ',
    },
    {
      'code': 'J3',
      'problem': 'เซนเซอร์อุณหภูมิท่อด้านส่งผิดปกติ',
    },
    {
      'code': 'J6',
      'problem': 'เซนเซอร์อุณหภูมิแลกเปลี่ยนความร้อนผิดปกติ',
    },
    {
      'code': 'J8',
      'problem': 'เซนเซอร์อุณหภูมิท่อของเหลวผิดปกติ',
    },
    {
      'code': 'E7',
      'problem': 'มอเตอร์พัดลมคอยล์ร้อนเสียหรือ PCB เสีย',
    },
  ];

  List<Map<String, String>> get filteredErrors {
    if (searchQuery.isEmpty) {
      return daikinErrors;
    }
    return daikinErrors.where((error) =>
      error['code']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
      error['problem']!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAIKIN Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredErrors.length,
              itemBuilder: (context, index) {
                final error = filteredErrors[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Error: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: error['code'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                         subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ปัญหา: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                          TextSpan(
                            text: error['problem'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TclErrorCodePage extends StatefulWidget {
  const TclErrorCodePage({Key? key}) : super(key: key);

  @override
  _TclErrorCodePageState createState() => _TclErrorCodePageState();
}

class _TclErrorCodePageState extends State<TclErrorCodePage> {
  String searchQuery = '';
  String selectedGroup = '';

  // กำหนดกลุ่มข้อมูล TCL
  final Map<String, List<Map<String, String>>> errorGroups = {
   "อาการเสีย": [
    {
      "code": "P0",
      "problem": "บอร์ด IPM module ทำงานผิดพลาด"
    },
    {
      "code": "P1",
      "problem": "แรงดันไฟฟ้าต่ำหรือสูงเกินไป"
    },
    {
      "code": "P2",
      "problem": "กระแสไฟฟ้าสูงเกินไป"
    },
    {
      "code": "P4",
      "problem": "เซนเซอร์ตรวจวัดอุณหภูมิท่อ Discharge outdoor มีอุณหภูมิสูงเกินไป"
    },
    {
      "code": "P5",
      "problem": "ตรวจสอบระบบน้ำยาในโหมด Cooling เนื่องจากอุณหภูมิของท่อ Subcooling ของส่วน Outdoor"
    },
    {
      "code": "P6",
      "problem": "ตรวจสอบระบบน้ำยาในโหมด Cooling เนื่องจากอุณหภูมิอุณหภูมิสูงเกินไป"
    },
    {
      "code": "P7",
      "problem": "ตรวจสอบระบบน้ำยาในโหมด Heating เนื่องจากอุณหภูมิอุณหภูมิสูงเกินไป"
    },
    {
      "code": "P8",
      "problem": "เซนเซอร์ตรวจวัดอุณหภูมิภายนอกค่าต่ำหรือสูงเกินไป"
    },
    {
      "code": "P9",
      "problem": "คอมเพรสเซอร์ทำงานผิดปกติ"
    },
    {
      "code": "PA",
      "problem": "การสื่อสารผิดพลาด สำหรับ TOP / Preset mode เกิดปัญหา"
    },
    {
      "code": "F0",
      "problem": "เซนเซอร์วัดค่าเซนเซอร์ตรวจสอบความรู้สึกของผู้ใช้งานทำงานผิดพลาด"
    },
    {
      "code": "F1",
      "problem": "โมดูลตรวจสอบกำลังไฟทำงานผิดพลาด"
    },
    {
      "code": "F2",
      "problem": "เซนเซอร์อุณหภูมิของท่อ Discharge ทำงานผิดพลาด"
    },
    {
      "code": "F3",
      "problem": "อุณหภูมิของคอยล์ร้อนผิดปกติ"
    },
    {
      "code": "F4",
      "problem": "ระบบการไหลของน้ำยาผิดปกติ"
    },
    {
      "code": "F5",
      "problem": "ตรวจวัดกระแสไฟฟ้าสูงเกินไป / PFC สูงเกินไป"
    },
    {
      "code": "F6",
      "problem": "กระแสไฟฟ้าวัวโมสวนของคอมเพรสเซอร์"
    },
    {
      "code": "F7",
      "problem": "อุณหภูมิของบอร์ดโมดูลผิดปกติ"
    },
    {
      "code": "F8",
      "problem": "ตำแหน่ง 4-Way สูงผิดปกติ"
    },
    {
      "code": "F9",
      "problem": "วงจรทดสอบอุณหภูมิของบอร์ดโมดูลทำงานผิดพลาด"
    },
    {
      "code": "FA",
      "problem": "วงจรทดสอบกระแสเฟสของคอมเพรสเซอร์ทำงานผิดพลาด"
    },
    {
      "code": "Fb",
      "problem": "รหัสป้องกันการเกิดน้ำแข็งที่คอยล์เย็นทำงานผิดปกติในโหมด Cooling/โหมด Heating"
    },
    {
      "code": "FC",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันการใช้พลังงานสูงเกินไป"
    },
    {
      "code": "FE",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันการกินกระแสของมอเตอร์โมดูล (เฟสของคอมเพรสเซอร์)"
    },
    {
      "code": "FF",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันอุณหภูมิของมอเตอร์โมดูล"
    },
    {
      "code": "FH",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันการทำงานของคอมเพรสเซอร์"
    },
    {
      "code": "FP",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันการเกิดแผ่นดิน"
    },
    {
      "code": "FU",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันการบาดเจ็บของนาฬิกา"
    },
    {
      "code": "Fj",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันอุณหภูมิของท่อ Discharge"
    },
    {
      "code": "Fn",
      "problem": "จำกัด/ลดความถี่ เพื่อป้องกันการกินกระแสของส่วน Outdoor"
    },
    {
      "code": "H1",
      "problem": "การสลับระบบการทำความเย็นแรงดันสูงผิดปกติ"
    },
    {
      "code": "H2",
      "problem": "การสลับระบบการทำความเย็นแรงดันต่ำผิดปกติ"
    },
    {
      "code": "BJ",
      "problem": "เซนเซอร์วัดความชื้นทำงานผิดพลาด"
    },
    {
      "code": "BF",
      "problem": "TVOC เซนเซอร์ มีปัญหา"
    },
    {
      "code": "BD",
      "problem": "มอเตอร์พัดลมดูดอากาศมีปัญหา"
    },
    {
      "code": "D4",
      "problem": "ระบบระบายน้ำทิ้งมีปัญหา"
    }
  ],
  "ไม่ใช่อาการเสีย": [
    {
      "code": "2A 3A 4A 5A 6A ",
      "problem": "ถ้าปิดโหมดอยู่ ไฟกดบนเครื่องออกโดยการกดปุ่ม GEN หรือโหม กดปุ่มจนกว่าหน้าจอโทรโชว์ OF แล้วปล่อยมือ ประมาณ 5 วินาทีพัดผ้าก็จะหยุดไป หลังจากนั้นคอมเพรสเซอร์จะกลับมาทำงาน 100% หรือ เป็นเดิมที"
    },
    {
      "code": " 7A 8A 9A 0A",
      "problem": "ถ้าปิดโหมดอยู่ ไฟกดบนเครื่องออกโดยการกดปุ่ม GEN หรือโหม กดปุ่มจนกว่าหน้าจอโทรโชว์ OF แล้วปล่อยมือ ประมาณ 5 วินาทีพัดผ้าก็จะหยุดไป หลังจากนั้นคอมเพรสเซอร์จะกลับมาทำงาน 100% หรือ เป็นเดิมที"
    },
    {
      "code": "CF PP SA AP",
      "problem": "ไม่ใช่ error code แต่เป็นตัวการส่งสัญญาณเพื่อเชื่อมต่อหา wifi ในลักษณะนี้จะมีในแอร์ที่เชื่อมต่อ wifi ได้ครับ เป็นการทำงานปกติ"
    }
  ]
  };

  // เพิ่มฟังก์ชันหาชื่อกลุ่มจาก error code
  String getGroupNameForError(String errorCode) {
    for (var entry in errorGroups.entries) {
      if (entry.value.any((error) => error['code'] == errorCode)) {
        return entry.key;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TCL Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          // ช่องค้นหา
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // แถบเลือกกลุ่ม
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
      child: Row(
        children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('ทั้งหมด'),
                        selected: selectedGroup.isEmpty,
                        onSelected: (selected) {
                          setState(() {
                            selectedGroup = '';
                          });
                        },
                      ),
                      ...errorGroups.keys.map((group) => FilterChip(
                        label: Text(group),
                        selected: selectedGroup == group,
                        onSelected: (selected) {
                          setState(() {
                            selectedGroup = selected ? group : '';
                          });
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // แสดงรายการ Error Codes
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredErrors().length,
              itemBuilder: (context, index) {
                final error = _getFilteredErrors()[index];
                final groupName = getGroupNameForError(error['code']!);
                
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Error: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '${error['code']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _MyHomePageState.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
          Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
            decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            groupName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                      subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ปัญหา: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                          TextSpan(
                            text: error['problem'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getFilteredErrors() {
    List<Map<String, String>> filteredList = [];
    
    if (selectedGroup.isEmpty) {
      // ถ้าไม่ได้เลือกกลุ่ม ให้แสดงทั้งหมด
      filteredList = errorGroups.values.expand((group) => group).toList();
    } else {
      // แสดงเฉพาะกลุ่มที่เลือก
      filteredList = errorGroups[selectedGroup] ?? [];
    }

    // กรองตามคำค้นหา
    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((error) {
        return error['code']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
               error['problem']!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filteredList;
  }
}

class HaierErrorCodePage extends StatefulWidget {
  const HaierErrorCodePage({Key? key}) : super(key: key);

  @override
  _HaierErrorCodePageState createState() => _HaierErrorCodePageState();
}

class _HaierErrorCodePageState extends State<HaierErrorCodePage> {
  String searchQuery = '';

  final List<Map<String, dynamic>> haierErrors = [
   {
          'code': 'E12',
          'LED_blink': 1,
          'problem': 'ข้อมูลใน EEPROM เสียหาย',
          
        },
        {
          'code': 'F1',
          'LED_blink': 2,
          'problem': 'เซนเซอร์ในห้อง',
          
        },
        {
          'code': 'F22',
          'LED_blink': 3,
          'problem': 'การแสดงฟังก์ชั่นการสูญเสียกำลังไฟ',
          
        },
        {
          'code': 'F3',
          'LED_blink': 4,
          'problem': 'การป้องกัน รันฟ์สร้อยกระทำงานบกพร่อง และเซนเซอร์ในห้อง',
          
        },
        {
          'code': 'F20',
          'LED_blink': 6,
          'problem': 'มอเตอร์เข้าไม่ถึงเครื่องสูงสุด หรือ ล้ำเกินไป',
          
        },
        {
          'code': 'F4',
          'LED_blink': 8,
          'problem': 'อุณหภูมิที่ท่อท่อเย็นวัดที่ท่อกลางๆ สูงเกินไป',
          
        },
        {
          'code': 'F21',
          'LED_blink': 10,
          'problem': 'เซนเซอร์ป้องกันน้ำซึมการทำแห้งคอนเดนเซอร์เสีย',
          
        },
        {
          'code': 'F6',
          'LED_blink': 12,
          'problem': 'เซนเซอร์ตรวจจับอุณหภูมิกระเปาะเปียกเสีย',
          
        },
        {
          'code': 'F25',
          'LED_blink': 13,
          'problem': 'เซนเซอร์ตรวจจับอุณหภูมิที่ท่อกลางเสีย',
          
        },
        {
          'code': 'F11',
          'LED_blink': 18,
          'problem': 'วงจรการจับค่าตำแหน่งของมอเตอร์เสียหา',
          
        },
        {
          'code': 'F28',
          'LED_blink': 19,
          'problem': 'เซนเซอร์ในห้อง',
          
        },
        {
          'code': 'F2',
          'LED_blink': 24,
          'problem': 'คอมเพรสเซอร์ไม่การะแสไฟ',
          
        },
        {
          'code': 'F23',
          'LED_blink': 25,
          'problem': 'การแสดงฟังก์ชั่นของกระแสไฟที่เข้าไฟเยอะๆ สูงไป',
          
        }
    // Add other HAIER error codes here
  ];

  List<Map<String, dynamic>> get filteredErrors {
    if (searchQuery.isEmpty) {
      return haierErrors;
    }
    return haierErrors.where((error) =>
      error['code'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
      error['problem'].toString().toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HAIER Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredErrors.length,
              itemBuilder: (context, index) {
                final error = filteredErrors[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: ListTile(
                    title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Error: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${error['code']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _MyHomePageState.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                        const SizedBox(height: 8), // Add spacing
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                Text(
                              'ไฟกระพริบ ${error['LED_blink']} ครั้ง',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                      subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ปัญหา: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                          TextSpan(
                            text: error['problem'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LGErrorCodePage extends StatefulWidget {
  const LGErrorCodePage({Key? key}) : super(key: key);

  @override
  _LGErrorCodePageState createState() => _LGErrorCodePageState();
}

class _LGErrorCodePageState extends State<LGErrorCodePage> {
  String searchQuery = '';
  String selectedGroup = '';

  // กำหนดกลุ่มข้อมูล
  final Map<String, List<Map<String, String>>> errorGroups = {
    'โค้ดแสดงความผิดปกติของคอยล์เป็น': [
     {
    "code": "1",
    "problem": "เซ็นเซอร์อุณหภูมิห้องเสีย"
  },
  {
    "code": "2",
    "problem": "เซ็นเซอร์อุณหภูมิท่อคอยล์เย็นขาเข้าเสีย"
  },
  {
    "code": "3",
    "problem": "รีโมทแบบสายมีปัญหา"
  },
  {
    "code": "4",
    "problem": "ไฟเวอร์ไดร์เสีย(ลอคฟัน)"
  },
  {
    "code": "5",
    "problem": "การสื่อสัญญาณระหว่างคอยล์เย็น-คอยล์ร้อนมีปัญหา"
  },
  {
    "code": "6",
    "problem": "เซ็นเซอร์อุณหภูมิท่อคอยล์เย็นขาออกเสีย"
  },
  {
    "code": "9",
    "problem": "EEPROM มีปัญหา(หน่วยความจำคอยล์เย็นเสีย)"
  },
  {
    "code": "10",
    "problem": "มอเตอร์พัดลมเย็น ล็อค/ไม่หมุน"
  },
  {
    "code": "12",
    "problem": "เซ็นเซอร์อุณหภูมิท่อคอยล์เย็น(กลางแลกเปลี่ยนเย็น) เสีย"
  },
    ],
    'โค้ดแสดงความผิดปกติของคอยดร้อน': [
      {
    "code": "21",
    "problem": "แรงดันไฟ DC /ไฟ แรงดันไฟต่ำมากเกินไป(IPM เสีย/ มีปัญหา)"
  },
  {
    "code": "22",
    "problem": "กระแสค่าไฟสูงวงจร(CT 2 ไอเวอร์ไดรฟ์)"
  },
  {
    "code": "23",
    "problem": "แรงดันไฟ DC Link ค่าต่ำผิดปกติ(ไฟฟ้าขาเข้าอาจไม่เพียงพอ)"
  },
  {
    "code": "26",
    "problem": "แรงดันไฟ DC Comp มีปัญหา"
  },
  {
    "code": "27",
    "problem": "PSC มีปัญหา"
  },
  {
    "code": "29",
    "problem": "กระแสคอมเพรสเซอร์ในแต่ละเฟสผิดปกติ(สายหลุด/หลวม/สายขาด)"
  },
    ],
    'โค้ดแสดงความผิดปกติของคอยล์ร้อน': [
      {
    "code": "32",
    "problem": "อุณหภูมิท่อคอยล์แคนเดนเซอร์ (หลายๆค่า) สูงเกินไป"
  },
  {
    "code": "34",
    "problem": "เซ็นเซอร์High Pressure จับแรงดันได้สูงเกินไป"
  },
  {
    "code": "35",
    "problem": "เซ็นเซอร์Low Pressure จับแรงดันได้ต่ำเกินไป"
  },
  {
    "code": "36(38)",
    "problem": "น้ำแข็งจับ"
  },
  {
    "code": "37",
    "problem": "อัตราส่วนการอัดอากาศต่างๆผิดปกติ"
  },
  {
    "code": "40",
    "problem": "เซ็นเซอร์วัดระบบแรงดัน (CT) มีปัญหา"
  },
  {
    "code": "41",
    "problem": "เซ็นเซอร์วัดอุณหภูมิปล่อยลมร้อน (หลายๆค่า) มีปัญหา"
  },
  {
    "code": "42",
    "problem": "เซ็นเซอร์Low Pressure เสีย/ มีปัญหา"
  },
  {
    "code": "43",
    "problem": "เซ็นเซอร์High Pressure เสีย/ มีปัญหา"
  },
  {
    "code": "44",
    "problem": "เซ็นเซอร์อุณหภูมิอุณหภูมิเสีย (อุณหภูมิอากาศภายนอกห้อง)"
  },
  {
    "code": "45",
    "problem": "เซ็นเซอร์อุณหภูมิท่อไม่ปล่อยลมร้อน (คอลเลค) มีปัญหา"
  },
  {
    "code": "46",
    "problem": "เซ็นเซอร์ท่อดูดมีปัญหา(Suction-Pipe Sensor Error)"
  },
  {
    "code": "51",
    "problem": "ขาดแรงลมที่ดูดเจอลมเย็นและเกิดลมรั่ว(ไม่ตรงกับแผนที่ไม่สมดุล)"
  },
  {
    "code": "53",
    "problem": "การสื่อสัญญาณระหว่างคอยล์เย็น-คอยล์ร้อน มีปัญหา"
  },
  {
    "code": "61",
    "problem": "อุณหภูมิเย็นและท่อไอน้ำแบบเซอร์มิสเตอร์"
  },
  {
    "code": "62",
    "problem": "Heat Sink ร้อนเกิน(อุณหาจะร้อนไม่แลกเปลี่ยนกับ IPM)"
  },
  {
    "code": "67",
    "problem": "DC Motor คอยล์ร้อนมีปัญหา(สายขาด/ หลวม/ มอเตอร์เสีย)"
  },
  {
    "code": "72",
    "problem": "วาวส์4 Way มีปัญหาหลุด/หลวม/ เสีย"
  }
    ],
  };

  // เพิ่มฟังก์ชันหาชื่อกลุ่มจาก error code
  String getGroupNameForError(String errorCode) {
    for (var entry in errorGroups.entries) {
      if (entry.value.any((error) => error['code'] == errorCode)) {
        return entry.key;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          // ช่องค้นหา
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // แถบเลือกกลุ่ม
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('ทั้งหมด'),
                        selected: selectedGroup.isEmpty,
                        onSelected: (selected) {
                          setState(() {
                            selectedGroup = '';
                          });
                        },
                      ),
                      ...errorGroups.keys.map((group) => FilterChip(
                        label: Text(group),
                        selected: selectedGroup == group,
                        onSelected: (selected) {
                          setState(() {
                            selectedGroup = selected ? group : '';
                          });
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // แสดงรายการ Error Codes
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredErrors().length,
              itemBuilder: (context, index) {
                final error = _getFilteredErrors()[index];
                final groupName = getGroupNameForError(error['code']!);
                
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Error: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '${error['code']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _MyHomePageState.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            groupName,
                  style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ปัญหา: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                          TextSpan(
                            text: error['problem'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getFilteredErrors() {
    List<Map<String, String>> filteredList = [];
    
    if (selectedGroup.isEmpty) {
      // ถ้าไม่ได้เลือกกลุ่ม ให้แสดงทั้งหมด
      filteredList = errorGroups.values.expand((group) => group).toList();
    } else {
      // แสดงเฉพาะกลุ่มที่เลือก
      filteredList = errorGroups[selectedGroup] ?? [];
    }

    // กรองตามคำค้นหา
    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((error) {
        return error['code']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
               error['problem']!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filteredList;
  }
}

class PanasonicErrorCodePage extends StatefulWidget {
  const PanasonicErrorCodePage({Key? key}) : super(key: key);

  @override
  _PanasonicErrorCodePageState createState() => _PanasonicErrorCodePageState();
}

class _PanasonicErrorCodePageState extends State<PanasonicErrorCodePage> {
  String searchQuery = '';

  final List<Map<String, dynamic>> panasonicErrors = [
     {
    "code": "E0",
    "LED_blink": "ไฟ RUN กระพริบ 1 ครั้งในวินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "ระบบการทำลายน้ำแข็งล้มเหลว หรือเสียหายชำรุด"
  },
  {
    "code": "P3",
    "LED_blink": "ไฟ RUN กระพริบ 1 ครั้งในวินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "อยู่ในสถานะการละลายน้ำแข็ง (ปุ่มกดละลายน้ำแข็งค้าง)"
  },
  {
    "code": "P1",
    "LED_blink": "ไฟ RUN กระพริบ 2 ครั้งใน 4 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "อยู่ในสถานะการต่อคอมเพรสเซอร์โดยตรง"
  },
  {
    "code": "E2",
    "LED_blink": "ไฟ RUN กระพริบ 2 ครั้งใน 4 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "ขดลวดเซ็นเซอร์อีวาพอเรเตอร์เสียหาย"
  },
  {
    "code": "E3",
    "LED_blink": "ไฟ RUN กระพริบ 3 ครั้งใน 5 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "ขดลวดเซ็นเซอร์คอยล์ร้อนเสียหาย"
  },
  {
    "code": "P5",
    "LED_blink": "ไฟ RUN กระพริบ 4 ครั้งใน 6 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "คอมเพรสเซอร์โหลดคู่มอเตอร์"
  },
  {
    "code": "P6",
    "LED_blink": "ไฟ RUN กระพริบ 5 ครั้งใน 7 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "คอมเพรสเซอร์โหลดคู่มอเตอร์ 5 kW."
  },
  {
    "code": "E9",
    "LED_blink": "ไฟ RUN กระพริบ 6 ครั้งใน 8 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "กำลังละลายน้ำแข็งต่อเนื่อง"
  },
  {
    "code": "F4",
    "LED_blink": "ไฟ RUN กระพริบ 7 ครั้งใน 9 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "สภาวะป้องกันความดันต่ำเกินต่ำ (Low-pressure)"
  },
  {
    "code": "F2",
    "LED_blink": "ไฟ RUN กระพริบ 8 ครั้งใน 10 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "ขาดไฟฟ้าภายในห้องเย็น, ลำลุ"
  },
  {
    "code": "EA",
    "LED_blink": "ไฟ RUN กระพริบ 9 ครั้งใน 11 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "เกิดโอเวอร์โหลดในระบบ"
  },
  {
    "code": "F5",
    "LED_blink": "ไฟ RUN กระพริบ 10 ครั้งใน 12 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "ปีกน้ำแข็งบล็อกเซ็นเซอร์"
  },
  {
    "code": "E5",
    "LED_blink": "ไฟ RUN กระพริบ 11 ครั้งใน 13 วินาที",
    "status": "เมื่อหยุดเครื่อง หลอดไฟอลาร์มติด, ไฟรัน (RUN) กระพริบ",
    "problem": "เซ็นเซอร์อุณหภูมิห้องเย็นผิดพลาดผิดปกติหรือหลุดออก"
  },
  {
    "code": "E2",
    "LED_blink": "ไฟ TIMER กระพริบตลอด",
    "status": "ไฟ TIMER กระพริบตลอด",
    "problem": "ขดลวดเซ็นเซอร์อีวาพอเรเตอร์เสียหาย"
  },
  {
    "code": "E3",
    "LED_blink": "ไฟ RUN กระพริบตลอด",
    "status": "ไฟ RUN กระพริบตลอด",
    "problem": "ขดลวดเซ็นเซอร์คอยล์ร้อนเสียหาย"
  },
  {
    "code": "E5",
    "LED_blink": "ไฟ DEFROST กระพริบตลอด",
    "status": "ไฟ DEFROST กระพริบตลอด",
    "problem": "เซ็นเซอร์อุณหภูมิห้องเย็นผิดปกติ"
  },
  {
    "code": "F5",
    "LED_blink": "ไฟ อลาร์มแดง กระพริบตลอด",
    "status": "ไฟ อลาร์มแดง กระพริบตลอด",
    "problem": "ปีกน้ำแข็งบล็อกเซ็นเซอร์"
  },
  {
    "code": "F2",
    "LED_blink": "ไฟ DEFROST กระพริบตลอด",
    "status": "ไฟ DEFROST กระพริบตลอด",
    "problem": "คอมเพรสเซอร์โหลดผิดปกติ"
  },
  {
    "code": "E1",
    "LED_blink": "ไฟ RUN กระพริบตลอด",
    "status": "ไฟ RUN กระพริบตลอด",
    "problem": "เซ็นเซอร์อุณหภูมิผิดปกติ"
  },
  {
    "code": "P6",
    "LED_blink": "ไฟ DEFROST กระพริบ TIMER กระพริบ",
    "status": "ไฟ DEFROST กระพริบ TIMER กระพริบ",
    "problem": "ระบบ EEPROM หล่อมลายผิดปกติ"
  },
  {
    "code": "N0",
    "LED_blink": "ไฟ RUN กระพริบตลอด",
    "status": "ไฟ RUN กระพริบตลอด",
    "problem": "อยู่ในโหมดทดสอบ (ปกติ)"
  },
  {
    "code": "P3",
    "LED_blink": "ไฟ DEFROST ติดตลอด",
    "status": "ไฟ DEFROST ติดตลอด",
    "problem": "กำลังละลายน้ำแข็ง"
  }
    // เพิ่ม error codes อื่นๆ ตามต้องการ
  ];

  List<Map<String, dynamic>> get filteredErrors {
    if (searchQuery.isEmpty) {
      return panasonicErrors;
    }
    return panasonicErrors.where((error) =>
      error['code'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
      error['problem'].toString().toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PANASONIC Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหารหัสข้อผิดพลาดหรือปัญหา...',
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredErrors.length,
              itemBuilder: (context, index) {
                final error = filteredErrors[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Error: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${error['code']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _MyHomePageState.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${error['LED_blink']}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                       
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'สถานะ: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                   // color: _MyHomePageState.textColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '${error['status']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _MyHomePageState.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                     subtitle: Text.rich(
                      TextSpan(
                        children: [ 
                          TextSpan(
                            text: 'ปัญหา: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              
                            ),
                          ),
                          TextSpan(
                            text: error['problem'],
                            style: TextStyle(
                              fontSize: 14,
                              color: _MyHomePageState.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MitsubishiErrorCodePage extends StatefulWidget {
  const MitsubishiErrorCodePage({Key? key}) : super(key: key);

  static const String PROBLEM_LABEL = 'ปัญหา: ';
  static const String STATUS_LABEL = 'สถานะการทำงาน: ';
  static const String CONTROL_LABEL = 'จุดสังเกต: ';
  static const String SOLUTION_LABEL = 'วิธีแก้ไข: ';
  static const String Errorss = 'Error';

  @override
  State<MitsubishiErrorCodePage> createState() => _MitsubishiErrorCodePageState();
}

class _MitsubishiErrorCodePageState extends State<MitsubishiErrorCodePage> {
  String searchQuery = '';
  String selectedGroup = '';
  
  final Map<String, List<Map<String, dynamic>>> errorGroups = {
      'ปัญหาเกี่ยวกับเซ็นเซอร์': [
      {
        "code": "E1",
        "LED_blink": "ไฟ OPERATION กระพริบ 1 ครั้ง",
        "LED_out": "กะพริบ 1 ครั้ง ทุก 2 วินาที",
        "problem": "เซ็นเซอร์อุณหภูมิห้องเสียหาย",
        "test": "เมื่อหยุดเครื่อง ไฟ OPERATION กระพริบ"
      },
      {
        "code": "E2",
        "LED_blink": "ไฟ OPERATION กระพริบ 2 ครั้ง",
        "LED_out": "กะพริบ 2 ครั้ง ทุก 3 วินาที", 
        "problem": "เซ็นเซอร์แลกเปลี่ยนความร้อนเสียหาย",
        "test": "เมื่อหยุดเครื่อง ไฟ OPERATION กระพริบ"
      },
      {
        "code": "E3",
        "LED_blink": "ไฟ OPERATION กระพริบ 3 ครั้ง",
        "LED_out": "กะพริบ 3 ครั้ง ทุก 3 วินาที",
        "problem": "เซ็นเซอร์ท่อคอนเดนเซอร์เสียหาย",
        "test": "เมื่อหยุดเครื่อง ไฟ OPERATION กระพริบ"
      }
    ],
    'อาการเสียเครื่องตัวในบ้าน': [
      {
        "code": "00",
        "problem": "ไม่มี (ปกติ)"
      },
      {
        "code": "E6 E7",
        "problem": "สัญญาณแบบอนุกรม"
      },
        {
        "code": "Fb",
        "problem": "ระบบควบคุมเครื่องภายในบ้าน"
      },
         {
        "code": "P1",
        "problem": "เทอร์มิสเตอร์อุณหภูมิห้อง"
      },
          {
        "code": "P2 P9",
        "problem": "คออส์เทอร์มิสเตอร์ของเครื่องภายในบ้าน"
      },
        {
        "code": "PB",
        "problem": "มอเตอร์พัดลมของเครื่องภายในบ้าน"
      },
       {
        "code": "E8 E9 EC",
        "problem": "การสื่อสารระหว่างเครื่องภายในบ้านเครื่องภายนอกบ้าน,การรับสัญญาณขัดข้อง"
      },
       {
        "code": "FC",
        "problem": "ข้อมูลหน่วยความจำถาวร"
      },
       {
        "code": "Fd",
        "problem": "แรงตันไฟฟ้าไม่ถูกต้อง"
      },
      {
        "code": "P8",
        "problem": "อุณหภูมิวาล์ว 4 ทางท่อ"
      },
       {
        "code": "PL",
        "problem": "ระบบสารทำความเย็นของเครื่องภายนอกบ้าน"
      },
       {
        "code": "U3",
        "problem": "Discharge เทอร์มิสเตอร์"
      },
        {
        "code": "U4",
        "problem": "เทอร์มิสเตอร์การละลายน้ำแข็ง \n ทอร์มิสเตอร์คุณหภูมิตรีบ \n เทอร์มิสเตอร์อุณหภูมิแผ่นวงจะควบคุมอิเล็กทรอนิกส์ \n เทอร์มิสเตอร์คุณหภูมิแวดล้อม \n เทอร์มิสเตอร์อุณหภูมิเครื่องแลกเปลี่ยนความร้อนของเครื่องภายนอกบ้าน"
        
      },
      {
        "code": "UE",
        "problem": "ราตัวเปิด-ปิด (วาล์วปิด)"
      },
      {
        "code": "UP",
        "problem": "ระบบไฟฟ้าของเครื่องภายนอกบ้าน"
      }
     
    ],
  };

  List<Map<String, dynamic>> get filteredErrors {
    if (selectedGroup.isEmpty && searchQuery.isEmpty) {
      return errorGroups.values.expand((errors) => errors).toList();
    }
    var errors = selectedGroup.isEmpty
        ? errorGroups.values.expand((errors) => errors).toList()
        : errorGroups[selectedGroup] ?? [];
    
    if (searchQuery.isEmpty) return errors;
    
    return errors.where((error) {
      final searchLower = searchQuery.toLowerCase();
      return error['code'].toString().toLowerCase().contains(searchLower) ||
             error['problem'].toString().toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MITSUBISHI Error Codes'),
        backgroundColor: _MyHomePageState.appBarColor, // Use the static appBarColor
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ค้นหารหัสข้อผิดพลาด',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('ทั้งหมด'),
                        selected: selectedGroup.isEmpty,
                        onSelected: (selected) {
                          setState(() {
                            selectedGroup = '';
                          });
                        },
                      ),
                      ...errorGroups.keys.map((group) => FilterChip(
                        label: Text(group),
                        selected: selectedGroup == group,
                        onSelected: (selected) {
                          setState(() {
                            selectedGroup = selected ? group : '';
                          });
                        },
                      )).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Error List
          Expanded(
            child: ListView.builder(
              itemCount: filteredErrors.length,
              itemBuilder: (context, index) {
                final error = filteredErrors[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: _MyHomePageState.cardBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: MitsubishiErrorCodePage.Errorss,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' ${error['code']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _MyHomePageState.textColor, // Update to use static textColor
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: MitsubishiErrorCodePage.STATUS_LABEL,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${error['LED_out']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: MitsubishiErrorCodePage.CONTROL_LABEL,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${error['LED_blink']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: MitsubishiErrorCodePage.PROBLEM_LABEL,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${error['problem']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _MyHomePageState.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: MitsubishiErrorCodePage.SOLUTION_LABEL,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '${error['test']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _MyHomePageState.textColor, // Update to use static textColor
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

