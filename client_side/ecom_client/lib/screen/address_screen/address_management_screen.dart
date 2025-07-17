import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_screen/login_screen/provider/user_provider.dart';
import 'provider/address_provider.dart';
import '../../models/address.dart';
import '../../utility/app_color.dart';
import '../../utility/snack_bar_helper.dart';
import 'components/address_card.dart';
import 'components/add_edit_address_sheet.dart';

class AddressManagementScreen extends StatefulWidget {
  final bool isSelectionMode;
  final Function(Address)? onAddressSelected;

  const AddressManagementScreen({
    super.key,
    this.isSelectionMode = false,
    this.onAddressSelected,
  });

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    // Load addresses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      addressProvider.getUserAddresses();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isSelectionMode ? 'Select Address' : 'My Addresses',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (!widget.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                final addressProvider = Provider.of<AddressProvider>(
                  context,
                  listen: false,
                );
                addressProvider.refreshAddresses();
              },
            ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return Column(
            children: [
              if (addressProvider.isLoading)
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
                                color: const Color(
                                  0xFFEC6813,
                                ).withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: LinearProgressIndicator(
                            value: (_controller.value + 0.2) % 1.0,
                            color: const Color(0xFFEC6813),
                            backgroundColor: const Color(
                              0xFFEC6813,
                            ).withOpacity(0.15),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Expanded(
                child: addressProvider.isLoading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : addressProvider.addresses.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await addressProvider.refreshAddresses();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Default Address Section
                              if (addressProvider.defaultAddress != null) ...[
                                _buildSectionHeader(
                                  'Default Address',
                                  Icons.star,
                                  Colors.amber,
                                ),
                                const SizedBox(height: 12),
                                AddressCard(
                                  address: addressProvider.defaultAddress!,
                                  isDefault: true,
                                  isSelectionMode: widget.isSelectionMode,
                                  onEdit: () => _showEditAddressSheet(
                                    addressProvider.defaultAddress!,
                                  ),
                                  onDelete: () => _showDeleteConfirmation(
                                    addressProvider.defaultAddress!,
                                  ),
                                  onSetDefault: null, // Already default
                                  onSelect: widget.isSelectionMode
                                      ? () {
                                          widget.onAddressSelected?.call(
                                            addressProvider.defaultAddress!,
                                          );
                                          Navigator.pop(
                                            context,
                                            addressProvider.defaultAddress!,
                                          );
                                        }
                                      : null,
                                ),
                                const SizedBox(height: 24),
                              ],
                              // Other Addresses Section
                              if (addressProvider.addresses
                                  .where((addr) => addr.isDefault != true)
                                  .isNotEmpty) ...[
                                _buildSectionHeader(
                                  'Other Addresses',
                                  Icons.location_on,
                                  Colors.blue,
                                ),
                                const SizedBox(height: 12),
                                ...addressProvider.addresses
                                    .where((addr) => addr.isDefault != true)
                                    .map(
                                      (address) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: AddressCard(
                                          address: address,
                                          isDefault: false,
                                          isSelectionMode:
                                              widget.isSelectionMode,
                                          onEdit: () =>
                                              _showEditAddressSheet(address),
                                          onDelete: () =>
                                              _showDeleteConfirmation(address),
                                          onSetDefault: () =>
                                              _setAsDefault(address),
                                          onSelect: widget.isSelectionMode
                                              ? () {
                                                  widget.onAddressSelected
                                                      ?.call(address);
                                                  Navigator.pop(
                                                    context,
                                                    address,
                                                  );
                                                }
                                              : null,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                              const SizedBox(
                                height: 100,
                              ), // Bottom padding for FAB
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: widget.isSelectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showAddAddressSheet(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressSheet(),
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showAddAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddEditAddressSheet(),
    );
  }

  void _showEditAddressSheet(Address address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditAddressSheet(address: address),
    );
  }

  void _showDeleteConfirmation(Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text(
          'Are you sure you want to delete "${address.displayName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final addressProvider = Provider.of<AddressProvider>(
                context,
                listen: false,
              );
              await addressProvider.deleteAddress(address.sId!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(Address address) async {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final success = await addressProvider.setDefaultAddress(address.sId!);
    if (success) {
      // SnackBarHelper.showSuccessSnackBar('Default address updated');
      initState();
    }
  }
}
