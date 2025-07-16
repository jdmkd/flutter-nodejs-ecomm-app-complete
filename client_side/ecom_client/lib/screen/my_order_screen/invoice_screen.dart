import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../core/data/data_provider.dart';
import '../../utility/app_color.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' show PdfColor;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'provider/order_provider.dart';
import '../../../models/address.dart';
import 'package:media_store_plus/media_store_plus.dart';
import '../../../utility/snack_bar_helper.dart';

class InvoiceScreen extends StatelessWidget {
  final Order order;
  const InvoiceScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderProvider>(
      create: (_) => OrderProvider()
        ..fetchAddresses(
          shippingAddressID: order.shippingAddressID,
          billingAddressID: order.billingAddressID,
        ),
      child: _InvoiceScreenContent(order: order),
    );
  }
}

class _InvoiceScreenContent extends StatelessWidget {
  final Order order;
  const _InvoiceScreenContent({required this.order});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DataProvider, OrderProvider>(
      builder: (context, dataProvider, orderProvider, child) {
        final shipping = orderProvider.shippingAddress;
        final items = order.items ?? [];
        final orderTotal = order.orderTotal;
        final coupon = order.couponCode;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Invoice',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: orderProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.white,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Header
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 48,
                              color: Colors.indigo,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Order Invoice',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            _statusLabel(order.orderStatus ?? 'pending'),
                            const SizedBox(height: 4),
                            Text(
                              'Order ID: ${order.sId ?? ''}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Date: ${order.orderDate ?? ''}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Customer & Shipping Info
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person, color: Colors.indigo[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer: ${order.userID?.name ?? ''}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (shipping != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Shipping Address:',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${shipping.street ?? ''}, ${shipping.city ?? ''}, ${shipping.state ?? ''}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '${shipping.country ?? ''} - ${shipping.postalCode ?? ''}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (shipping.phone != null)
                                        Text(
                                          'Phone: ${shipping.phone}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Itemized List
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              ...items.map((item) {
                                String? imageUrl;
                                if (item.productID != null) {
                                  final product = dataProvider.allProducts
                                      .firstWhere(
                                        (p) => p.sId == item.productID,
                                        orElse: () => Product(),
                                      );
                                  if (product.images != null &&
                                      product.images!.isNotEmpty) {
                                    imageUrl = product.images!.first.url;
                                  }
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: imageUrl != null
                                            ? Image.network(
                                                imageUrl,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      width: 48,
                                                      height: 48,
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons.image,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              )
                                            : Container(
                                                width: 48,
                                                height: 48,
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
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
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
                      // Totals
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              if (orderTotal != null) ...[
                                _summaryRow('Subtotal', orderTotal.subtotal),
                                _summaryRow(
                                  'Discount',
                                  orderTotal.discount,
                                  isDiscount: true,
                                ),
                                _summaryRow(
                                  'Total',
                                  orderTotal.total,
                                  isTotal: true,
                                ),
                              ] else ...[
                                _summaryRow(
                                  'Total',
                                  order.totalPrice,
                                  isTotal: true,
                                ),
                              ],
                              if (coupon != null && coupon.couponCode != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Coupon: ${coupon.couponCode}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Download/Print Button
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              icon: const Icon(Icons.download_rounded),
                              label: const Text('Download Invoice'),
                              onPressed: () async {
                                try {
                                  // Show loading indicator
                                  SnackBarHelper.showSuccessSnackBar(
                                    'Generating invoice...',
                                  );

                                  final dataProvider =
                                      Provider.of<DataProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final items = order.items ?? [];
                                  // Prefetch all product images as bytes
                                  final Map<String, Uint8List?> productImages =
                                      {};
                                  for (final item in items) {
                                    if (item.productID != null &&
                                        !productImages.containsKey(
                                          item.productID,
                                        )) {
                                      final product = dataProvider.allProducts
                                          .firstWhere(
                                            (p) => p.sId == item.productID,
                                            orElse: () => Product(),
                                          );
                                      if (product.images != null &&
                                          product.images!.isNotEmpty) {
                                        try {
                                          final bytes = await _networkImage(
                                            product.images!.first.url!,
                                          );
                                          productImages[item.productID!] =
                                              bytes;
                                        } catch (_) {
                                          productImages[item.productID!] = null;
                                        }
                                      } else {
                                        productImages[item.productID!] = null;
                                      }
                                    }
                                  }

                                  final pdfBytes = await _generatePdf(
                                    context,
                                    productImages,
                                    null,
                                    shipping,
                                  );

                                  final fileName =
                                      'invoice_${order.sId ?? DateTime.now().millisecondsSinceEpoch}.pdf';
                                  final filePath = await savePdfToDownloads(
                                    pdfBytes,
                                    fileName,
                                  );

                                  if (filePath != null) {
                                    SnackBarHelper.showSuccessSnackBar(
                                      'Invoice downloaded to: $filePath',
                                    );
                                  } else {
                                    SnackBarHelper.showErrorSnackBar(
                                      'Storage permission denied or failed to save invoice.',
                                    );
                                  }
                                } catch (e) {
                                  SnackBarHelper.showErrorSnackBar(
                                    'Failed to download invoice: ${e.toString()}',
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              icon: const Icon(Icons.print),
                              label: const Text('Print/Preview Invoice'),
                              onPressed: () async {
                                await Printing.layoutPdf(
                                  onLayout: (format) async {
                                    final dataProvider =
                                        Provider.of<DataProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final items = order.items ?? [];
                                    // Prefetch all product images as bytes
                                    final Map<String, Uint8List?>
                                    productImages = {};
                                    for (final item in items) {
                                      if (item.productID != null &&
                                          !productImages.containsKey(
                                            item.productID,
                                          )) {
                                        final product = dataProvider.allProducts
                                            .firstWhere(
                                              (p) => p.sId == item.productID,
                                              orElse: () => Product(),
                                            );
                                        if (product.images != null &&
                                            product.images!.isNotEmpty) {
                                          try {
                                            final bytes = await _networkImage(
                                              product.images!.first.url!,
                                            );
                                            productImages[item.productID!] =
                                                bytes;
                                          } catch (_) {
                                            productImages[item.productID!] =
                                                null;
                                          }
                                        } else {
                                          productImages[item.productID!] = null;
                                        }
                                      }
                                    }
                                    return await _generatePdf(
                                      context,
                                      productImages,
                                      format,
                                      shipping,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
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

  // Add this widget for status label
  Widget _statusLabel(String status) {
    Color color;
    String label = status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1)
        : '';
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'processing':
        color = Colors.blue;
        break;
      case 'shipped':
        color = Colors.purple;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'CANCELLED';
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    BuildContext context,
    Map<String, Uint8List?> productImages,
    dynamic format,
    Address? shipping,
  ) async {
    final orderTotal = order.orderTotal;
    final coupon = order.couponCode;
    final items = order.items ?? [];
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final doc = pw.Document();

    // Load Roboto font for Unicode support (including rupee symbol)
    final robotoRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final robotoBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    pw.Widget _sectionTitle(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: robotoBold,
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('#EC6813'),
        ),
      ),
    );

    final isCancelled = (order.orderStatus ?? '').toLowerCase() == 'cancelled';

    // Add main invoice page
    doc.addPage(
      pw.MultiPage(
        build: (context) {
          final List<pw.Widget> content = [];
          if (isCancelled) {
            content.add(
              pw.Center(
                child: pw.Opacity(
                  opacity: 0.12,
                  child: pw.Text(
                    'CANCELLED',
                    style: pw.TextStyle(
                      font: robotoBold,
                      fontSize: 100,
                      color: PdfColor.fromHex('#FF0000'),
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
            content.add(pw.SizedBox(height: 20));
          }
          content.add(
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Order Invoice',
                    style: pw.TextStyle(
                      font: robotoBold,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  // Status label in PDF
                  if ((order.orderStatus ?? '').isNotEmpty)
                    pw.Opacity(
                      opacity: 0.15,
                      child: pw.Container(
                        margin: const pw.EdgeInsets.only(top: 8, bottom: 8),
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: pw.BoxDecoration(
                          color: () {
                            switch ((order.orderStatus ?? '').toLowerCase()) {
                              case 'pending':
                                return PdfColor.fromHex('#FFA500'); // orange
                              case 'processing':
                                return PdfColor.fromHex('#2196F3'); // blue
                              case 'shipped':
                                return PdfColor.fromHex('#9C27B0'); // purple
                              case 'delivered':
                                return PdfColor.fromHex('#4CAF50'); // green
                              case 'cancelled':
                                return PdfColor.fromHex('#FF0000'); // red
                              default:
                                return PdfColor.fromHex('#A6A3A0');
                            }
                          }(),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(8),
                          ),
                        ),
                        child: pw.Text(
                          (order.orderStatus ?? '').toUpperCase(),
                          style: pw.TextStyle(
                            color: () {
                              switch ((order.orderStatus ?? '').toLowerCase()) {
                                case 'pending':
                                  return PdfColor.fromHex('#FFA500');
                                case 'processing':
                                  return PdfColor.fromHex('#2196F3');
                                case 'shipped':
                                  return PdfColor.fromHex('#9C27B0');
                                case 'delivered':
                                  return PdfColor.fromHex('#4CAF50');
                                case 'cancelled':
                                  return PdfColor.fromHex('#FF0000');
                                default:
                                  return PdfColor.fromHex('#A6A3A0');
                              }
                            }(),
                            font: robotoBold,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  pw.Text(
                    'Order ID: ${order.sId ?? ''}',
                    style: pw.TextStyle(
                      font: robotoRegular,
                      fontSize: 12,
                      color: PdfColor.fromHex('#A6A3A0'),
                    ),
                  ),
                  pw.Text(
                    'Date: ${order.orderDate ?? ''}',
                    style: pw.TextStyle(
                      font: robotoRegular,
                      fontSize: 12,
                      color: PdfColor.fromHex('#A6A3A0'),
                    ),
                  ),
                ],
              ),
            ),
          );
          content.addAll([
            pw.SizedBox(height: 18),
            _sectionTitle('Customer & Shipping Info'),
            pw.Text(
              'Customer: ${order.userID?.name ?? ''}',
              style: pw.TextStyle(font: robotoRegular),
            ),
            if (shipping != null) ...[
              pw.Text(
                'Address: ${shipping.street ?? ''}, ${shipping.city ?? ''}, ${shipping.state ?? ''}',
                style: pw.TextStyle(font: robotoRegular),
              ),
              pw.Text(
                '${shipping.country ?? ''} - ${shipping.postalCode ?? ''}',
                style: pw.TextStyle(font: robotoRegular),
              ),
              if (shipping.phone != null)
                pw.Text(
                  'Phone: ${shipping.phone}',
                  style: pw.TextStyle(font: robotoRegular),
                ),
            ],
            pw.SizedBox(height: 12),
            _sectionTitle('Items'),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColor.fromHex('#E5E6E8')),
              columnWidths: {
                0: pw.FlexColumnWidth(2.5), // Product name (more space)
                1: pw.FlexColumnWidth(1), // Variant
                2: pw.FlexColumnWidth(0.7), // Qty
                3: pw.FlexColumnWidth(1), // Price
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#E5E6E8'),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Product',
                        style: pw.TextStyle(
                          font: robotoBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Variant',
                        style: pw.TextStyle(
                          font: robotoBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Qty',
                        style: pw.TextStyle(
                          font: robotoBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Price',
                        style: pw.TextStyle(
                          font: robotoBold,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...items.map((item) {
                  Uint8List? imageBytes;
                  if (item.productID != null) {
                    imageBytes = productImages[item.productID!];
                  }
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: pw.Row(
                          children: [
                            if (imageBytes != null)
                              pw.Container(
                                width: 24,
                                height: 24,
                                margin: const pw.EdgeInsets.only(right: 4),
                                child: pw.Image(
                                  pw.MemoryImage(imageBytes),
                                  fit: pw.BoxFit.cover,
                                ),
                              ),
                            pw.Container(
                              constraints: const pw.BoxConstraints(
                                maxWidth: 150,
                              ),
                              child: pw.Text(
                                item.productName ?? '',
                                softWrap: true,
                                style: pw.TextStyle(font: robotoRegular),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: pw.Text(
                          item.variant ?? '-',
                          style: pw.TextStyle(font: robotoRegular),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: pw.Text(
                          '${item.quantity ?? ''}',
                          style: pw.TextStyle(font: robotoRegular),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: pw.Text(
                          '₹${item.price?.toStringAsFixed(2) ?? ''}',
                          style: pw.TextStyle(font: robotoRegular),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 12),
            _sectionTitle('Summary'),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:', style: pw.TextStyle(font: robotoRegular)),
                pw.Text(
                  '₹${orderTotal?.subtotal?.toStringAsFixed(2) ?? '-'}',
                  style: pw.TextStyle(font: robotoRegular),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Discount:', style: pw.TextStyle(font: robotoRegular)),
                pw.Text(
                  '- ₹${orderTotal?.discount?.toStringAsFixed(2) ?? '-'}',
                  style: pw.TextStyle(font: robotoRegular),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total:',
                  style: pw.TextStyle(
                    font: robotoBold,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '₹${orderTotal?.total?.toStringAsFixed(2) ?? order.totalPrice?.toStringAsFixed(2) ?? '-'}',
                  style: pw.TextStyle(
                    font: robotoBold,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (coupon != null && coupon.couponCode != null)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 8),
                child: pw.Text(
                  'Coupon: ${coupon.couponCode}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#A6A3A0'),
                  ),
                ),
              ),
            pw.SizedBox(height: 24),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                'Thank you for your purchase!',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromHex('#A6A3A0'),
                ),
              ),
            ),
          ]);
          return content;
        },
      ),
    );
    return doc.save();
  }

  Future<Uint8List> _networkImage(String url) async {
    final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return data.buffer.asUint8List();
  }
}

Future<String?> savePdfToDownloads(Uint8List pdfBytes, String fileName) async {
  try {
    if (Platform.isAndroid) {
      // Explicitly request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return null;
      }
      final mediaStore = MediaStore();
      final file = await mediaStore.saveFile(
        fileName: fileName,
        bytes: pdfBytes,
        dirType: DirType.download,
        relativePath: 'Invoices', // Optional subfolder
        mimeType: 'application/pdf',
      );
      return file?.path;
    } else if (Platform.isIOS) {
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      return filePath;
    } else {
      // Other platforms: try downloads, else app documents
      Directory? downloadsDir;
      try {
        downloadsDir = await getDownloadsDirectory();
      } catch (_) {}
      downloadsDir ??= await getApplicationDocumentsDirectory();
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      return filePath;
    }
  } catch (e) {
    return null;
  }
}
