import 'package:digitaltwinpoc/models/notification.dart';
import 'package:digitaltwinpoc/screens/widgets/asset_tile_widget.dart';
import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../utils/theme.dart';
import 'asset_detail_screen.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({super.key, required this.assets, required this.notifications});

  final List<Asset> assets;
  final List<AppNotification> notifications;

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  late List<Asset> _filteredAssets;
  String _searchQuery = '';
  String _selectedAssetType = 'All';
  String _selectedLocation = 'All';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _filteredAssets = List.from(widget.assets);
  }

  void _applyFilters() {
    setState(() {
      _filteredAssets =
          widget.assets.where((asset) {
            // Apply search filter
            if (_searchQuery.isNotEmpty &&
                !asset.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) &&
                !asset.type.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                )) {
              return false;
            }

            // Apply type filter
            if (_selectedAssetType != 'All' &&
                asset.type != _selectedAssetType) {
              return false;
            }

            // Apply location filter
            if (_selectedLocation != 'All' &&
                asset.location != _selectedLocation) {
              return false;
            }

            // Apply status filter
            if (_selectedStatus != 'All' &&
                asset.status['health'] != _selectedStatus) {
              return false;
            }

            return true;
          }).toList();

      _filteredAssets.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchAndFilterBar(),
        _buildActiveFilterChips(),
        Expanded(
          child: _filteredAssets.isEmpty ? SizedBox() : _buildAssetList(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search assets...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterOptions,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    final activeFilters = <Widget>[];

    if (_selectedAssetType != 'All') {
      activeFilters.add(
        _buildFilterChip('Type: $_selectedAssetType', () {
          setState(() {
            _selectedAssetType = 'All';
            _applyFilters();
          });
        }),
      );
    }

    if (_selectedLocation != 'All') {
      activeFilters.add(
        _buildFilterChip('Location: $_selectedLocation', () {
          setState(() {
            _selectedLocation = 'All';
            _applyFilters();
          });
        }),
      );
    }

    if (_selectedStatus != 'All') {
      activeFilters.add(
        _buildFilterChip('Status: $_selectedStatus', () {
          setState(() {
            _selectedStatus = 'All';
            _applyFilters();
          });
        }),
      );
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...activeFilters,
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedAssetType = 'All';
                _selectedLocation = 'All';
                _selectedStatus = 'All';
                _applyFilters();
              });
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDelete,
        backgroundColor: Colors.grey.shade100,
        deleteIconColor: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildAssetList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAssets.length,
      itemBuilder: (context, index) {
        final asset = _filteredAssets[index];
        final notifications = widget.notifications
            .where((n) => n.relatedItemId == asset.id)
            .toList();
        // return Text(asset.name);
        return AssetTileWidget(
          asset: asset,
          showNotificationIndicator: notifications.where((n)=> n.type == NotificationType.assetAlert).isNotEmpty,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetDetailScreen(asset: asset, notifications: notifications,),
                ),
              ),
        );
      },
    );
  }

  void _showFilterOptions() {
    final assetTypes = [
      'All',
      ...{...widget.assets.map((a) => a.type)},
    ];
    final locations = [
      'All',
      ...{...widget.assets.map((a) => a.location)},
    ];
    final statuses = ['All', 'Good', 'Warning', 'Critical'];

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Assets',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Asset Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            assetTypes.map((type) {
                              final isSelected = _selectedAssetType == type;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(type),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedAssetType =
                                          selected ? type : 'All';
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            locations.map((location) {
                              final isSelected = _selectedLocation == location;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(location),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedLocation =
                                          selected ? location : 'All';
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            statuses.map((status) {
                              final isSelected = _selectedStatus == status;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedStatus =
                                          selected ? status : 'All';
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilters();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
