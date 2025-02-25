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
  late Color brandTextColor;
  final searchController = TextEditingController();
  String searchQuery = '';
  List<String> recentBrands = [];

  final Color _defaultCardColor = const Color(0xFFE0E0E0);
  final Color _defaultAppColor = Colors.white;
  final Color _defaultAppBarColor = Colors.blue;
  

  late Color cardBackgroundColor;
  late Color appBarColor;

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
    {'name': 'SAMSUNG', 'image': 'assets/images/list-samsung.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'PANASONIC', 'image': 'assets/images/list-panasonic.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'TOSHIBA', 'image': 'assets/images/list-toshiba.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'HITACHI', 'image': 'assets/images/list-hitachi.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'LG', 'image': 'assets/images/list-lg.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'CARRIER', 'image': 'assets/images/list-carrier.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'DAIKIN', 'image': 'assets/images/list-daikin.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'ELECTROLUX', 'image': 'assets/images/list-electrolux.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'GREE', 'image': 'assets/images/list-gree.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'HAIER', 'image': 'assets/images/list-haier.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': true},
    {'name': 'HISENSE', 'image': 'assets/images/list-hisense.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': true},
    {'name': 'MITSUBISHI', 'image': 'assets/images/list-mitsubishi.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'TCL', 'image': 'assets/images/list-tcl.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false},
    {'name': 'MIDEA', 'image': 'assets/images/list-midea.svg', 'subtitle': 'Air Conditioner', 'isOutdoorOnly': false}
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
      brandTextColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
    });
  }

  Future<void> saveColors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cardColor', cardBackgroundColor.value);
    await prefs.setInt('appColor', appBackgroundColor.value);
    await prefs.setInt('appBarColor', appBarColor.value);
    await prefs.setInt('textColor', brandTextColor.value);
  }

  void resetColors() {
    setState(() {
      cardBackgroundColor = _defaultCardColor;
      appBackgroundColor = _defaultAppColor;
      appBarColor = _defaultAppBarColor;
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
                    brandTextColor = color;
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
    if (appBackgroundColor == null || brandTextColor == null) {
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
          toolbarHeight: 160,
          title: Column(
            children: [
              Text(widget.title),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                },
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'ค้นหาแบรนด์...',
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
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
                  enableInteractiveSelection: true,
                  autofocus: false,
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
                          ListTile(
                            title: const Text('เปลี่ยนสีตัวหนังสือ'),
                            onTap: () {
                              Navigator.pop(context);
                              _showColorPickerDialog('text');
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'แบรนด์',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: filteredBrands.map((brand) => 
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: BrandCard(
                            brand: brand['name']!,
                            subtitle: brand['subtitle']!,
                            image: brand['image']!,
                            isSvg: true,
                            backgroundColor: cardBackgroundColor,
                            isOutdoorOnly: brand['isOutdoorOnly']!,
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  if (recentBrands.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    const Text(
                      'เข้าชมล่าสุด',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(  
                      children: recentBrands.map((brandName) {
                        final brand = brands.firstWhere(
                          (b) => b['name'] == brandName,
                          orElse: () => brands[0],
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            width: double.infinity, 
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: brandTextColor,
                                ),
                              ),
                              subtitle: Text(brand['subtitle']!),
                              onTap: () async { 
                               
                                if (context.findAncestorStateOfType<_MyHomePageState>() != null) {
                                  await context 
                                      .findAncestorStateOfType<_MyHomePageState>()!
                                      .saveRecentBrand(brand['name']!);
                                }
                                if (context.mounted) { 
                                  Navigator.of(context).push(
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
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
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
            width: 200,
            height: 280,
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
    return WillPopScope(
      onWillPop: () async {
        if (context.findAncestorStateOfType<_MyHomePageState>() != null) {
          final homeState = context.findAncestorStateOfType<_MyHomePageState>()!;
          homeState.searchController.clear();
          homeState.setState(() {
            homeState.searchQuery = '';
          });
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(brand),
          backgroundColor: Colors.blue,
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
                              builder: (context) => ErrorCodeScreen(
                                brand: brand,
                                isOutdoorOnly: isOutdoorOnly,
                              ),
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
  late Color brandTextColor;

  @override
  void initState() {
    super.initState();
    loadTextColor();
  }

  Future<void> loadTextColor() async {
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
        'solution': '-'
    },
    {
        'code': 'P1',
        'problem': 'แรงดันไฟฟ้าสูงหรือต่ำเกินไป',
        'solution': '-'
    },
    {
        'code': 'P2',
        'problem': 'กระแสไฟฟ้าสูงเกินไป',
        'solution': '-'
    },
    {
        'code': 'P4',
        'problem': 'เซนเซอร์ตรวจวัดอุณหภูมิท่อ Discharge outdoor มีอุณหภูมิสูงเกินไป',
        'solution': '-'
    },
    {
        'code': 'P5',
        'problem': 'ตรวจสอบระบบน้ำยาในโหมด Cooling เนื่องจากอุณหภูมิท่อทางเข้าของส่วน Subcooling',
        'solution': '-'
    },
    {
        'code': 'P6',
        'problem': 'ตรวจสอบระบบน้ำยาในโหมด Cooling เนื่องจากท่อมีอุณหภูมิสูงเกินไป',
        'solution': '-'
    },
    {
        'code': 'P7',
        'problem': 'ตรวจสอบระบบน้ำยาในโหมด Heating เนื่องจากท่อมีอุณหภูมิสูงเกินไป',
        'solution': '-'
    },
    {
        'code': 'P8',
        'problem': 'เซนเซอร์ตรวจวัดอุณหภูมิภายนอกค่าสูงหรือต่ำเกินไป',
        'solution': '-'
    },
    {
        'code': 'P9',
        'problem': 'คอมเพรสเซอร์ทำงานผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'PA',
        'problem': 'การสื่อสารผิดพลาด สำหรับ TOP / Preset mode มีปัญหา',
        'solution': '-'
    },
    {
        'code': 'F0',
        'problem': 'เซนเซอร์รับคำสั่งหรือตรวจสอบความรู้สึกของผู้ใช้งานทำงานผิดพลาด',
        'solution': '-'
    },
    {
        'code': 'F1',
        'problem': 'โมดูลตรวจสอบกำลังไฟทำงานผิดพลาด',
        'solution': '-'
    },
    {
        'code': 'F2',
        'problem': 'เซนเซอร์อุณหภูมิของท่อ Discharge ทำงานผิดพลาด',
        'solution': '-'
    },
    {
        'code': 'F3',
        'problem': 'อุณหภูมิของคอยล์ร้อนผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'F4',
        'problem': 'ระบบการไหลของน้ำยาผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'F5',
        'problem': 'ตรวจจับกระแสไฟฟ้าสูงเกินไป / PFC สูงเกินไป',
        'solution': '-'
    },
    {
        'code': 'F6',
        'problem': 'กระแสไฟฟ้าวงจรของคอมเพรสเซอร์',
        'solution': '-'
    },
    {
        'code': 'F7',
        'problem': 'อุณหภูมิของบอร์ดโมดูลผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'F8',
        'problem': 'ตัวของ 4-Way สูงผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'F9',
        'problem': 'วงจรทดสอบอุณหภูมิของบอร์ดโมดูลทำงานผิดพลาด',
        'solution': '-'
    },
    {
        'code': 'FA',
        'problem': 'วงจรทดสอบกระแสเฟสของคอมเพรสเซอร์ทำงานผิดพลาด',
        'solution': '-'
    },
    {
        'code': 'Fb',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการทำความเย็นหรือทำความร้อนเกินไปในโหมด Cooling/โหมด Heating',
        'solution': '-'
    },
    {
        'code': 'FC',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการใช้พลังงานสูงเกินไป',
        'solution': '-'
    },
    {
        'code': 'FE',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการกินกระแสของมอเตอร์โมดูล (เฟสของคอมเพรสเซอร์)',
        'solution': '-'
    },
    {
        'code': 'FF',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันอุณหภูมิของมอเตอร์โมดูล',
        'solution': '-'
    },
    {
        'code': 'FH',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการทำงานของคอมเพรสเซอร์',
        'solution': '-'
    },
    {
        'code': 'FP',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการเกิดแผ่นน้ำแข็ง',
        'solution': '-'
    },
    {
        'code': 'FU',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการบกพร่องส่วนอื่นๆ',
        'solution': '-'
    },
    {
        'code': 'FJ',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันอุณหภูมิของท่อ Discharge',
        'solution': '-'
    },
    {
        'code': 'Fn',
        'problem': 'จำกัด/ลดความถี่ เพื่อป้องกันการกินกระแสของส่วน Outdoor',
        'solution': '-'
    },
    {
        'code': 'H1',
        'problem': 'การสลับระบบการทำความเย็นแรงดันสูงผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'H2',
        'problem': 'การสลับระบบการทำความเย็นแรงดันต่ำผิดปกติ',
        'solution': '-'
    },
    {
        'code': 'BJ',
        'problem': 'เซนเซอร์วัดความชื้นทำงานผิดพลาด',
        'solution': '-'
    },
    {
        'code': 'BF',
        'problem': 'TVOC เซ็นเซอร์ มีปัญหา',
        'solution': '-'
    },
    {
        'code': 'BD',
        'problem': 'มอเตอร์พัดลมดูดอากาศมีปัญหา',
        'solution': '-'
    },
    {
        'code': 'D4',
        'problem': 'ระบบระบายน้ำทิ้งมีปัญหา',
        'solution': '-'
    },
    {
        'code': '2A 3A 4A 5A 6A 7A 8A 9A 0A',
        'problem': 'ถ้าปิดโหมดสแตนบาย โหลดบกเลิกออกโดยการกดปุ่ม GEN หรือโหมดกดปุ่มจนกว่าหน้าจอโทรโชว์ OF แล้วปล่อยมือ ประมาณ 5 วินาทีพัดลมก็จะหยุดไปหลังจากนั้นคอมเพรสเซอร์จะกลับมาทำงาน 100% หรือ เป็นเดิมที',
        'solution': '-'
    },
    {
        'code': 'CF PP SA AP',
        'problem': 'ไม่ใช่ error code แต่มันคือการส่งสัญญาณเพื่อเชื่อมต่อหา wifi ในลักษณะนี้จะมีในแอร์รุ่นที่เชื่อมต่อ wifi ได้ครับ เป็นการทำงานปกติ',
        'solution': '-'
    }
    ],
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
          'code': 'E12',
          'LED_blink': 1,
          'problem': 'ข้อมูลใน EEPROM เสียหาย',
          'solution': '-'
        },
        {
          'code': 'F1',
          'LED_blink': 2,
          'problem': 'เซนเซอร์ในห้อง',
          'solution': '-'
        },
        {
          'code': 'F22',
          'LED_blink': 3,
          'problem': 'การแสดงฟังก์ชั่นการสูญเสียกำลังไฟ',
          'solution': '-'
        },
        {
          'code': 'F3',
          'LED_blink': 4,
          'problem': 'การป้องกัน รันฟ์สร้อยกระทำงานบกพร่อง และเซนเซอร์ในห้อง',
          'solution': '-'
        },
        {
          'code': 'F20',
          'LED_blink': 6,
          'problem': 'มอเตอร์เข้าไม่ถึงเครื่องสูงสุด หรือ ล้ำเกินไป',
          'solution': '-'
        },
        {
          'code': 'F4',
          'LED_blink': 8,
          'problem': 'อุณหภูมิที่ท่อท่อเย็นวัดที่ท่อกลางๆ สูงเกินไป',
          'solution': '-'
        },
        {
          'code': 'F21',
          'LED_blink': 10,
          'problem': 'เซนเซอร์ป้องกันน้ำซึมการทำแห้งคอนเดนเซอร์เสีย',
          'solution': '-'
        },
        {
          'code': 'F6',
          'LED_blink': 12,
          'problem': 'เซนเซอร์ตรวจจับอุณหภูมิกระเปาะเปียกเสีย',
          'solution': '-'
        },
        {
          'code': 'F25',
          'LED_blink': 13,
          'problem': 'เซนเซอร์ตรวจจับอุณหภูมิที่ท่อกลางเสีย',
          'solution': '-'
        },
        {
          'code': 'F11',
          'LED_blink': 18,
          'problem': 'วงจรการจับค่าตำแหน่งของมอเตอร์เสียหา',
          'solution': '-'
        },
        {
          'code': 'F28',
          'LED_blink': 19,
          'problem': 'เซนเซอร์ในห้อง',
          'solution': '-'
        },
        {
          'code': 'F2',
          'LED_blink': 24,
          'problem': 'คอมเพรสเซอร์ไม่การะแสไฟ',
          'solution': '-'
        },
        {
          'code': 'F23',
          'LED_blink': 25,
          'problem': 'การแสดงฟังก์ชั่นของกระแสไฟที่เข้าไฟเยอะๆ สูงไป',
          'solution': '-'
        }
      ],
       'HISENSE': [
        {
          'code': 'E1',
          'problem': 'ล็อคประตูมีปัญหา',
          'solution': '1. ตรวจสอบกลไกล็อคประตู\n2. ตรวจสอบการปิดประตูให้สนิท'
        }
      ]
    };

    final brandCodes = errorCodes[widget.brand] ?? [];
    final filteredCodes = brandCodes.where((error) =>
      error['code']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
      error['problem']!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brand} Error Code'),
        backgroundColor: Colors.blue,
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
                  child: ExpansionTile(
                    title: Text(
                      'Error ${error['code']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: brandTextColor,
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
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'ไฟกระพริบ ${error['LED_blink']} ครั้ง',
                                style: TextStyle(
                                  color: brandTextColor,
                                ),
                              ),
                            ],
                          ),
                        Text(
                          error['problem'] ?? '',
                          style: TextStyle(color: brandTextColor),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'วิธีแก้ไข:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: brandTextColor,
                                  ),
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

