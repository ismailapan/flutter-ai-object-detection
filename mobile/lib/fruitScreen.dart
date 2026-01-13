import 'package:bitirme_project/api/api.dart';
import 'package:bitirme_project/model/fruit_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class fruitScreen extends StatefulWidget {
  final String label;
  const fruitScreen({super.key, required this.label});

  @override
  State<fruitScreen> createState() => _fruitScreenState();
}

class _fruitScreenState extends State<fruitScreen>
    with SingleTickerProviderStateMixin {
  late Future<Fruit> _fruitFuture;
  late AnimationController _controller;
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    _fruitFuture = fetchFruit(widget.label);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(size: 30, color: Colors.black),
        title: Text("Besin Değerleri", style: GoogleFonts.oswald(fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _buildBackdrop(),
            SafeArea(
              child: FutureBuilder<Fruit>(
                future: _fruitFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoading();
                  }
                  if (snapshot.hasError) {
                    return _buildError(snapshot.error);
                  }
                  if (!snapshot.hasData) {
                    return _buildEmpty();
                  }
                  if (!_startAnimation) {
                    _startAnimation = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _controller.forward();
                    });
                  }
                  final fruit = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedSection(
                          index: 0,
                          child: _buildHeader(fruit),
                        ),
                        _buildAnimatedSection(
                          index: 1,
                          child: _buildInfoCard(
                            title: "Açıklama",
                            child: Text(
                              fruit.desciription,
                              style: _bodyStyle,
                            ),
                          ),
                        ),
                        _buildAnimatedSection(
                          index: 2,
                          child: _buildInfoCard(
                            title: "Hakkında",
                            child: Text(
                              fruit.about,
                              style: _bodyStyle,
                            ),
                          ),
                        ),
                        _buildAnimatedSection(
                          index: 3,
                          child: _buildMetricCard(
                            title: "Besin Degerleri",
                            items: [
                              _MetricItem(
                                "Kalori",
                                fruit.nutrition.calories,
                                Icons.local_fire_department,
                              ),
                              _MetricItem(
                                "Karbonhidrat",
                                fruit.nutrition.carbs,
                                Icons.grain,
                              ),
                              _MetricItem(
                                "Yag",
                                fruit.nutrition.fat,
                                Icons.water_drop,
                              ),
                              _MetricItem(
                                "Protein",
                                fruit.nutrition.protein,
                                Icons.fitness_center,
                              ),
                            ],
                            accent: const Color(0xFF2D6A4F),
                          ),
                        ),
                        _buildAnimatedSection(
                          index: 4,
                          child: _buildMetricCard(
                            title: "Vitaminler",
                            items: [
                              _MetricItem(
                                "Vitamin A",
                                fruit.vitamin.vitamin_A,
                                Icons.visibility,
                              ),
                              _MetricItem(
                                "Vitamin C",
                                fruit.vitamin.vitmin_C,
                                Icons.bolt,
                              ),
                            ],
                            accent: const Color(0xFFB45309),
                          ),
                        ),
                        _buildAnimatedSection(
                          index: 5,
                          child: _buildMetricCard(
                            title: "Mineraller",
                            items: [
                              _MetricItem(
                                "Kalsiyum",
                                fruit.mineral.calcium,
                                Icons.bubble_chart,
                              ),
                              _MetricItem(
                                "Magnezyum",
                                fruit.mineral.magnesium,
                                Icons.blur_on,
                              ),
                              _MetricItem(
                                "Fosfor",
                                fruit.mineral.phosphorus,
                                Icons.science,
                              ),
                              _MetricItem(
                                "Potasyum",
                                fruit.mineral.potassium,
                                Icons.flash_on,
                              ),
                              _MetricItem(
                                "Sodyum",
                                fruit.mineral.sodium,
                                Icons.grain_outlined,
                              ),
                            ],
                            accent: const Color(0xFF1D4ED8),
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
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFF2B2B2B),
  );

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 14.5,
    height: 1.5,
    color: Color(0xFF4B4B4B),
  );

  Widget _buildBackdrop() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFB703).withOpacity(0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          right: -30,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFB7185).withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const SweepGradient(
                  colors: [Color(0xFFF97316), Color(0xFFFCD34D), Color(0xFFF97316)],
                ).createShader(rect);
              },
              child: const CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Color(0x22FFFFFF),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Veriler yukleniyor...",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B4E3D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildInfoCard(
          title: "Hata",
          child: Text(
            "Veri alinamadi: $error",
            style: _bodyStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text(
        "Veri bulunamadi",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHeader(Fruit fruit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Color(0xFFF97316), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fruit.displayname, style: _titleStyle),
                const SizedBox(height: 6),
                Text(
                  fruit.label.toUpperCase(),
                  style: const TextStyle(
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A5A44),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _titleStyle),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required List<_MetricItem> items,
    required Color accent,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _titleStyle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items
                .map(
                  (item) => _buildMetricChip(
                    label: item.label,
                    value: item.value,
                    icon: item.icon,
                    accent: accent,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip({
    required String label,
    required String value,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: accent.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2B2B2B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection({required int index, required Widget child}) {
    final double start = (index * 0.08).clamp(0.0, 1.0);
    final double end = (start + 0.45).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final IconData icon;

  _MetricItem(this.label, this.value, this.icon);
}
