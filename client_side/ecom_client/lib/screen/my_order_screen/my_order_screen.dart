import '../../core/data/data_provider.dart';
import '../tracking_screen/tracking_screen.dart';
import '../../utility/app_color.dart';
import '../../utility/extensions.dart';
import '../../utility/utility_extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../widget/order_tile.dart';
import 'order_detail_screen.dart';
import '../../models/order.dart';
import '../../models/product.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with SingleTickerProviderStateMixin {
  final List<String> orderStatuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final user = context.userProvider.getLoginUsr();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.dataProvider.getAllOrderByUser(user);
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange(
      BuildContext context, DataProvider provider) async {
    final initialDateRange = provider.dateRangeFilter ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 30)),
          end: DateTime.now(),
        );
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.indigo,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      provider.setDateRangeFilter(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          if (provider.isOrderLoading) {
            return Stack(
              children: [
                // Animated gradient progress bar at the top with fade and shadow
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: provider.isOrderLoading ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: SizedBox(
                      width: double.infinity,
                      height: 8,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFEC6813).withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: _AnimatedGradientBarPainter(
                                  _controller.value),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Centered modern spinner
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFEC6813)),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Loading orders...",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEC6813),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter UI
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Order Status Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: provider.orderStatusFilter,
                        decoration: InputDecoration(
                          labelText: 'Order Status',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Statuses'),
                          ),
                          ...orderStatuses
                              .map((status) => DropdownMenuItem<String>(
                                    value: status,
                                    child:
                                        Text(status.capitalizeFirst ?? status),
                                  )),
                        ],
                        onChanged: (value) {
                          provider.setOrderStatusFilter(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Date Range Picker
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        provider.dateRangeFilter == null
                            ? 'Date Range'
                            : '${provider.dateRangeFilter!.start.toString().split(' ')[0]} -\n${provider.dateRangeFilter!.end.toString().split(' ')[0]}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onPressed: () => _pickDateRange(context, provider),
                    ),
                    if (provider.dateRangeFilter != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.redAccent),
                        tooltip: 'Clear Date Filter',
                        onPressed: () => provider.setDateRangeFilter(null),
                      ),
                  ],
                ),
              ),
              // Order List Section
              Expanded(
                child: Consumer<DataProvider>(
                  builder: (context, dataProvider, _) {
                    if (provider.filteredOrders.isEmpty) {
                      return Center(
                        child: Text(
                          'No orders found.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 8),
                        itemCount: provider.filteredOrders.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = provider.filteredOrders[index];
                          String? imageUrl;
                          if (order.items != null && order.items!.isNotEmpty) {
                            final productId = order.items!.first.productID;
                            if (productId != null) {
                              final product =
                                  dataProvider.allProducts.firstWhere(
                                (p) => p.sId == productId,
                                orElse: () => Product(),
                              );
                              if (product.images != null &&
                                  product.images!.isNotEmpty) {
                                imageUrl = product.images!.first.url;
                              }
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, bottom: 8),
                                  child: Text(
                                    'Recent Orders',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[700],
                                    ),
                                  ),
                                ),
                              OrderTile(
                                paymentMethod: order.paymentMethod ?? '',
                                items: order.items != null &&
                                        order.items!.isNotEmpty
                                    ? order.items!.first.productName ?? ''
                                    : '',
                                date: order.orderDate ?? '',
                                status: order.orderStatus ?? 'pending',
                                total: order.totalPrice,
                                thumbnailUrl: imageUrl,
                                onTap: () {
                                  Get.to(() => OrderDetailScreen(order: order));
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
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
      colors: [
        Color(0xFFEC6813),
        Color(0xFFFFA726),
        Color(0xFFEC6813),
      ],
      stops: [
        (0.0 + animationValue) % 1.0,
        (0.5 + animationValue) % 1.0,
        (1.0 + animationValue) % 1.0,
      ],
    );
    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(4)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimatedGradientBarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
