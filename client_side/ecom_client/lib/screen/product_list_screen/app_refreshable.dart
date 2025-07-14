import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/data/data_provider.dart';

/// A refreshable widget that shows a loading/progress bar and supports pull-to-refresh for DataProvider.
class AppRefreshable extends StatefulWidget {
  final Widget child;
  final String loadingText;

  const AppRefreshable({
    super.key,
    required this.child,
    this.loadingText = 'Loading...',
  });

  @override
  State<AppRefreshable> createState() => _AppRefreshableState();
}

class _AppRefreshableState extends State<AppRefreshable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    // Trigger initial data fetch if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      if (!dataProvider.isInitialized) {
        dataProvider.fetchAllData();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final List<Widget> content = [];
        if (dataProvider.isLoading) {
          content.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                height: 6,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEC6813).withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: _AnimatedGradientBarPainter(_controller.value),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        if (dataProvider.isLoading) {
          content.add(
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.loadingText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 49, 49, 49),
                    ),
                  ),
                ],
              ),
            ),
          );
          return Column(mainAxisSize: MainAxisSize.min, children: content);
        }
        // Not loading: just show the refreshable child
        return RefreshIndicator(onRefresh: _refreshData, child: widget.child);
      },
    );
  }
}

class _AnimatedGradientBarPainter extends CustomPainter {
  final double animationValue;
  _AnimatedGradientBarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFEC6813), Color(0xFFFFA726), Color(0xFFEC6813)],
      stops: [
        (0.0 + animationValue) % 1.0,
        (0.5 + animationValue) % 1.0,
        (1.0 + animationValue) % 1.0,
      ],
    );
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)), paint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedGradientBarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
