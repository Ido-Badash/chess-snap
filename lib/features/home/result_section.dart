import 'package:flutter/material.dart';
import 'package:chess_snap/core/widgets/button.dart';

class ResultSection extends StatelessWidget {
  final Animation<double> resultSlideAnimation;
  final String detectedFen;
  final String lichessUrl;
  final Function(String) onCopyToClipboard;
  final VoidCallback onOpenInLichess;
  final VoidCallback onResetForNewAnalysis;
  final Function(String, IconData, {bool isError}) onShowSnackBar;

  const ResultSection({
    super.key,
    required this.resultSlideAnimation,
    required this.detectedFen,
    required this.lichessUrl,
    required this.onCopyToClipboard,
    required this.onOpenInLichess,
    required this.onResetForNewAnalysis,
    required this.onShowSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: resultSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, resultSlideAnimation.value * 50),
          child: Opacity(
            opacity: 1 - resultSlideAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultHeader(),
                  const SizedBox(height: 16),
                  _buildFenDisplay(),
                  const SizedBox(height: 20),
                  _buildActionGrid(),
                  const SizedBox(height: 16),
                  _buildNewAnalysisButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2ecc71), Color(0xFF16a085)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2ecc71).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Analysis Complete!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "Chess position successfully detected",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFenDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.code, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "FEN String",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildCopyButton(
                onTap: () => onCopyToClipboard(detectedFen),
                icon: Icons.copy,
                tooltip: "Copy FEN",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              detectedFen,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'monospace',
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2; // 12 for spacing

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.open_in_browser,
                    title: "Open in Lichess",
                    subtitle: "Analyze position",
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    onTap: onOpenInLichess,
                    width: cardWidth,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.link,
                    title: "Copy Link",
                    subtitle: "Share position",
                    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                    onTap: () => onCopyToClipboard(lichessUrl),
                    width: cardWidth,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
    required double width,
  }) {
    return Container(
      width: width,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopyButton({
    required VoidCallback onTap,
    required IconData icon,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      child: GradientActionButton(
        gradientColors: const [Color(0xFFff7b7b), Color(0xFFff416c)],
        shadowColor: const Color(0xFFff416c),
        leadingIcon: const Icon(Icons.refresh, color: Colors.white, size: 18),
        trailingIcon: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white.withValues(alpha: 0.7),
          size: 14,
        ),
        width: double.infinity,
        height: 60,
        label: "New Analysis",
        onPressed: onResetForNewAnalysis,
      ),
    );
  }
}
