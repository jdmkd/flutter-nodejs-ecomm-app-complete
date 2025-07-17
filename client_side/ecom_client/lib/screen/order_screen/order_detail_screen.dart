import 'package:ecom_client/screen/auth_screen/login_screen/provider/user_provider.dart';
import 'package:ecom_client/screen/order_screen/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../core/data/data_provider.dart';
import '../tracking_screen/tracking_screen.dart';
import 'invoice_screen.dart';
import '../../utility/app_color.dart';
import 'package:intl/intl.dart';
import '../../../models/address.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderProvider>(
      create: (_) => OrderProvider(),
      child: _OrderDetailScreenContent(order: order),
    );
  }
}

class _OrderDetailScreenContent extends StatefulWidget {
  final Order order;
  const _OrderDetailScreenContent({required this.order});

  @override
  State<_OrderDetailScreenContent> createState() =>
      _OrderDetailScreenContentState();
}

class _OrderDetailScreenContentState extends State<_OrderDetailScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchAddresses(
        shippingAddressID: widget.order.shippingAddressID,
        billingAddressID: widget.order.billingAddressID,
      );

      print("in initState!!");
      print("orderProvider :: $orderProvider");
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final items = order.items ?? [];
    final orderTotal = order.orderTotal;
    final coupon = order.couponCode;
    final statusColor = _getStatusColor(order.orderStatus ?? '');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer2<DataProvider, OrderProvider>(
        builder: (context, dataProvider, orderProvider, child) {
          return Container(
            color: Colors.grey[100],
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Modern Order Progress Timeline at the very top
                _OrderStatusTimeline(
                  currentStatus: order.orderStatus ?? 'pending',
                  isCancelled: order.orderStatus == 'cancelled',
                ),
                const SizedBox(height: 4),
                // Refined Cancel Order Button (medium size, still prominent)
                if (_canCancelOrder(order))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 44),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 22,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Cancel Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cancel Order'),
                                content: const Text(
                                  'Are you sure you want to cancel this order?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Yes, Cancel'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await Provider.of<OrderProvider>(
                                context,
                                listen: false,
                              ).cancelOrder(order.sId!);
                              await _refreshOrderDetails();
                              Navigator.of(context).pop('order_cancelled');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Status and Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _capitalize(order.orderStatus ?? ''),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.orderDate ?? '',
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Payment Method
                Row(
                  children: [
                    Icon(Icons.payment, color: Colors.indigo[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Payment: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[700],
                      ),
                    ),
                    Text(
                      order.paymentMethod ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Shipping Address Section
                if (orderProvider.isLoading)
                  Center(child: CircularProgressIndicator()),
                if (!orderProvider.isLoading &&
                    orderProvider.shippingAddress != null)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_shipping,
                                color: AppColor.darkOrange,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Shipping Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${orderProvider.shippingAddress?.street ?? ''}, ${orderProvider.shippingAddress?.city ?? ''}, ${orderProvider.shippingAddress?.state ?? ''}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            '${orderProvider.shippingAddress?.country ?? ''} - ${orderProvider.shippingAddress?.postalCode ?? ''}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          if (orderProvider.shippingAddress?.phone != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 16,
                                    color: AppColor.darkGrey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    orderProvider.shippingAddress!.phone!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (!orderProvider.isLoading &&
                    orderProvider.shippingAddress == null)
                  const Text('Shipping address not available.'),
                const SizedBox(height: 18),
                // Divider(thickness: 1.2, color: Colors.grey[300]),
                // Order Items
                Container(
                  // margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: AppColor.darkOrange,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Order Items',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...items.map((item) {
                          String? imageUrl;
                          if (item.productID != null) {
                            final product = dataProvider.allProducts.firstWhere(
                              (p) => p.sId == item.productID,
                              orElse: () => Product(),
                            );
                            if (product.images != null &&
                                product.images!.isNotEmpty) {
                              imageUrl = product.images!.first.url;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageUrl != null
                                      ? Image.network(
                                          imageUrl,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    width: 56,
                                                    height: 56,
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                      Icons.image,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                        )
                                      : Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (item.variant != null &&
                                          item.variant!.isNotEmpty)
                                        Text(
                                          'Variant: ${item.variant}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      Text(
                                        'Qty: ${item.quantity}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '₹${item.price?.toStringAsFixed(2) ?? ''}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Divider(thickness: 1.2, color: Colors.grey[300]),
                // Coupon
                if (coupon != null)
                  Card(
                    color: Colors.grey[100],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.discount, color: AppColor.darkGrey),
                          const SizedBox(width: 8),
                          if (coupon.couponCode != null)
                            Text(
                              'Coupon: ${coupon.couponCode}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                // Order Total
                Container(
                  // margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: AppColor.darkOrange,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (orderTotal != null) ...[
                          _summaryRow('Subtotal', orderTotal.subtotal),
                          _summaryRow(
                            'Discount',
                            orderTotal.discount,
                            isDiscount: true,
                          ),
                          _summaryRow('Total', orderTotal.total, isTotal: true),
                        ] else ...[
                          _summaryRow('Total', order.totalPrice, isTotal: true),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tracking Button
                if (order.trackingUrl != null && order.trackingUrl!.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    icon: const Icon(Icons.location_on),
                    label: const Text('Track Order'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              TrackingScreen(url: order.trackingUrl!),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 16),
                // Advanced Features: Reorder & Contact Support
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: const Text('Reorder'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                          side: const BorderSide(color: Colors.deepOrange),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reorder placed! (Demo)'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.support_agent),
                        label: const Text('Contact Support'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          side: const BorderSide(color: Colors.indigo),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Contact Support'),
                              content: const Text(
                                'For support, email us at support@example.com',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('View Invoice'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.indigo,
                      side: const BorderSide(color: Colors.indigo),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => InvoiceScreen(order: order),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double? value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value == null
                ? '-'
                : (isDiscount
                      ? '- ₹${value.toStringAsFixed(2)}'
                      : '₹${value.toStringAsFixed(2)}'),
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount
                  ? Colors.red
                  : (isTotal ? Colors.green : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.grey;
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  bool _canCancelOrder(Order order) {
    if (order.orderStatus == 'cancelled' || order.orderStatus == 'delivered')
      return false;
    if (order.orderDate == null) return false;
    final orderDate = DateTime.tryParse(order.orderDate!);
    if (orderDate == null) return false;
    final now = DateTime.now();
    return now.difference(orderDate).inDays < 5;
  }

  Future<void> _refreshOrderDetails() async {
    // Direct HTTP call to fetch order by ID
    final httpService = Provider.of<OrderProvider>(
      context,
      listen: false,
    ).service;
    final response = await httpService.getItems(
      endpointUrl: 'orders/${widget.order.sId}',
      withAuth: true,
    );
    if (response.isOk && response.body != null) {
      final updatedOrder = Order.fromJson(response.body['data']);
      setState(() {
        widget.order.orderStatus = updatedOrder.orderStatus;
        widget.order.items = updatedOrder.items;
        widget.order.orderTotal = updatedOrder.orderTotal;
        widget.order.paymentMethod = updatedOrder.paymentMethod;
        widget.order.couponCode = updatedOrder.couponCode;
        widget.order.trackingUrl = updatedOrder.trackingUrl;
        widget.order.orderDate = updatedOrder.orderDate;
        // Add more fields as needed
      });
    }
  }
}

class _OrderStatusTimeline extends StatelessWidget {
  final String currentStatus;
  final bool isCancelled;
  const _OrderStatusTimeline({
    required this.currentStatus,
    required this.isCancelled,
  });

  static const List<String> statuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
  ];

  static const Map<String, Color> statusColors = {
    'pending': Color(0xFFB0BEC5), // Light Blue Grey
    'processing': Color(0xFF42A5F5), // Blue
    'shipped': Color(0xFFFFB300), // Amber
    'delivered': Color(0xFF43A047), // Green
    'cancelled': Color(0xFFE53935), // Red
  };

  static const Map<String, IconData> statusIcons = {
    'pending': Icons.hourglass_empty,
    'processing': Icons.settings,
    'shipped': Icons.local_shipping,
    'delivered': Icons.check_circle,
    'cancelled': Icons.cancel,
  };

  @override
  Widget build(BuildContext context) {
    int currentIndex = statuses.indexOf(currentStatus);
    if (isCancelled) currentIndex = statuses.length - 1;
    final stepCount = statuses.length;
    final iconSize = 34.0;
    final activeIconSize = 42.0;
    final barHeight = 8.0;
    final lineGradient = LinearGradient(
      colors: [
        statusColors['processing']!,
        statusColors['shipped']!,
        statusColors['delivered']!,
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Progress',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 90, // enough for icon + label + status
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(statuses.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Connecting line between steps, vertically centered with icon
                final rightIndex = (i + 1) ~/ 2;
                final Color segmentColor = isCancelled
                    ? statusColors['cancelled']!
                    : (rightIndex <= currentIndex && !isCancelled)
                    ? statusColors[statuses[rightIndex]]!
                    : Colors.grey[300]!;
                return Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 15,
                      ), // icon radius (42/2 or 34/2)
                      height: 6.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: segmentColor,
                      ),
                    ),
                  ),
                );
              } else {
                // Step icon + label + status
                final index = i ~/ 2;
                final status = statuses[index];
                final isActive = index == currentIndex && !isCancelled;
                final isCompleted = index < currentIndex && !isCancelled;
                final Color color = isCancelled
                    ? statusColors['cancelled']!
                    : isCompleted
                    ? statusColors[status]!
                    : isActive
                    ? statusColors[status]!
                    : Colors.grey[300]!;
                return SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      // Icon (always at the same vertical position)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        width: isActive ? 42 : 34,
                        height: isActive ? 42 : 34,
                        decoration: BoxDecoration(
                          color: color.withOpacity(
                            isActive || isCompleted || isCancelled ? 1.0 : 0.13,
                          ),
                          border: Border.all(
                            color: color,
                            width: isActive ? 3 : 1.5,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.22),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Icon(
                            isCancelled && isActive
                                ? statusIcons['cancelled']
                                : statusIcons[status],
                            color: isActive || isCompleted || isCancelled
                                ? Colors.white
                                : color,
                            size: isActive ? 26 : 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        status[0].toUpperCase() + status.substring(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isActive ? 13.5 : 12.5,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: color,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                        child: (isCompleted && !isCancelled)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: color.withOpacity(0.7),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ),
        if (isCancelled)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(Icons.cancel, color: statusColors['cancelled'], size: 18),
                const SizedBox(width: 7),
                Text(
                  'Order Cancelled',
                  style: TextStyle(
                    color: statusColors['cancelled'],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
