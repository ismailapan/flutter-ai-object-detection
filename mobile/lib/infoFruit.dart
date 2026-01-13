import 'package:bitirme_project/fruitScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Infofruit extends StatelessWidget {
  final String fruitName;
  final double conf;

  const Infofruit({super.key, required this.fruitName, required this.conf});

  @override
  Widget build(BuildContext context) {
    final score = (conf * 100).clamp(0, 100).toStringAsFixed(2);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black, size: 30),
        title: Text("Tespit Sonucu",style: GoogleFonts.oswald(fontSize:25, fontWeight: FontWeight.bold )),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.amber,
              Colors.green
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCard(
                  fruitName: fruitName.toUpperCase(),
                  score: score,
                  theme: theme,
                  conf: conf,
                ),
                const SizedBox(height: 18),
                _DetailCard(
                  title: "Detaylar",
                  children: [
                    _InfoRow(
                      icon: Icons.spa_outlined,
                      label: "Meyve İsmi",
                      value: fruitName.toUpperCase(),
                    ),
                    _InfoRow(
                      icon: Icons.verified_outlined,
                      label: "Güvenilirlik",
                      value: "%$score",
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailCard(
                  title: "Öneri",
                  children: [
                    Text(
                      "Sonucu doğrulamak için netliği artırarak tekrar çekim yapabilirsiniz.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: const Color(0xFF5B4A3B),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => fruitScreen(label: fruitName)));
                  },
                  icon: Icon(Icons.arrow_circle_right_outlined, color: Colors.black,),
                  label: Text("Bilgi",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 12)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.fruitName,
    required this.score,
    required this.theme,
    required this.conf,
  });

  final String fruitName;
  final String score;
  final ThemeData theme;
  final double conf;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey,
            Colors.green
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33A6572D),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tespit Edilen Meyve",
            style: theme.textTheme.labelLarge?.copyWith(
              color: const Color(0xFF4B2E1D),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fruitName,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF3A2416),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A2416),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "%$score",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7EF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D4BF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A8A5B3B),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4B2E1D),
            ),
          ),
          const SizedBox(height: 12),
          ..._withSpacing(children),
        ],
      ),
    );
  }

  List<Widget> _withSpacing(List<Widget> items) {
    if (items.isEmpty) return items;
    final spaced = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      spaced.add(items[i]);
      if (i != items.length - 1) {
        spaced.add(const SizedBox(height: 10));
      }
    }
    return spaced;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6CC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6B3A1E), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF8A6B55),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF3A2416),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
