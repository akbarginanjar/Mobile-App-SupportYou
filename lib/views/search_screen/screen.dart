import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/kategori_controller.dart';
import 'package:mobile_supportyou/controllers/search_controller.dart';
import 'package:mobile_supportyou/views/widgets/kategori_chip.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';

class SearchScreen extends StatefulWidget {
  final int? initialKategoriId;
  final bool autoFocus;

  const SearchScreen({super.key, this.initialKategoriId, this.autoFocus = true});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final PelatihanSearchController _searchController;
  late final KategoriController _kategoriController;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<String> _tempSelectedModes = [];
  List<String> _tempSelectedPrices = [];

  @override
  void initState() {
    super.initState();

    _searchController = Get.put(PelatihanSearchController());
    _kategoriController = Get.put(KategoriController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _kategoriController.loadKategori();

      if (widget.initialKategoriId != null) {
        _searchController.setKategoriId(widget.initialKategoriId);
      }

      _searchController.loadInitialData();

      if (widget.autoFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _searchController.refreshWithCurrentFilters();
  }

  void _performSearch() {
    _searchController.search();
  }

  void _applyFilters() {
    _searchController.setModes(_tempSelectedModes);
    _searchController.setPrices(_tempSelectedPrices);
    _performSearch();
  }

  void _resetFiltersInDialog() {
    setState(() {
      _tempSelectedModes.clear();
      _tempSelectedPrices.clear();
    });
    _applyFilters();
  }

  void _showFilterDialog() {
    _tempSelectedModes = List.from(_searchController.selectedModes);
    _tempSelectedPrices = List.from(_searchController.selectedPrices);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.4,
              maxChildSize: 0.7,
              expand: false,
              builder: (_, scrollController) => Container(
                decoration: BoxDecoration(
                  color: theme,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: textTheme.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Filter Pelatihan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Mode Belajar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textTheme.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _searchController.modeOptions.map((mode) {
                                final isSelected = _tempSelectedModes.contains(mode);
                                return FilterChip(
                                  label: Text(
                                    _searchController.getModeDisplayName(mode),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? theme : textTheme.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setModalState(() {
                                      if (isSelected) {
                                        _tempSelectedModes.remove(mode);
                                      } else {
                                        _tempSelectedModes.add(mode);
                                      }
                                    });
                                  },
                                  backgroundColor: theme,
                                  selectedColor: primary,
                                  checkmarkColor: theme,
                                  showCheckmark: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: isSelected ? primary : textTheme.withValues(alpha: 0.15),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Harga',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textTheme.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _searchController.priceOptions.map((price) {
                                final isSelected = _tempSelectedPrices.contains(price);
                                return FilterChip(
                                  label: Text(
                                    _searchController.getPriceDisplayName(price),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? theme : textTheme.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setModalState(() {
                                      if (isSelected) {
                                        _tempSelectedPrices.remove(price);
                                      } else {
                                        _tempSelectedPrices.add(price);
                                      }
                                    });
                                  },
                                  backgroundColor: theme,
                                  selectedColor: primary,
                                  checkmarkColor: theme,
                                  showCheckmark: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: isSelected ? primary : textTheme.withValues(alpha: 0.15),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme,
                        border: Border(
                          top: BorderSide(color: textTheme.withValues(alpha: 0.1)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  _tempSelectedModes.clear();
                                  _tempSelectedPrices.clear();
                                });
                                _resetFiltersInDialog();
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: textTheme.withValues(alpha: 0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Reset Filter'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _applyFilters();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text('Terapkan', style: TextStyle(color: theme)),
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
        },
      ),
    );
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.3,
          maxChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: theme,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: textTheme.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Urutkan Berdasarkan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ..._searchController.sortOptions.map((sort) {
                          return ListTile(
                            title: Text(_searchController.getSortDisplayName(sort)),
                            trailing: _searchController.selectedSort.value == sort
                                ? Icon(Icons.check, color: primary)
                                : null,
                            onTap: () {
                              _searchController.setSort(sort);
                              _performSearch();
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: textTheme.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.withValues(alpha: 0.95),
      appBar: AppBar(
        backgroundColor: theme,
        surfaceTintColor: theme,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () => Get.back(),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: theme,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: textTheme.withValues(alpha: 0.15)),
          ),
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            autofocus: widget.autoFocus,
            style: TextStyle(fontSize: 14, color: textTheme),
            decoration: InputDecoration(
              hintText: 'Cari pelatihan...',
              hintStyle: TextStyle(color: textTheme.withValues(alpha: 0.4), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              prefixIcon: Icon(Icons.search, size: 20, color: textTheme.withValues(alpha: 0.5)),
              suffixIcon: _textController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 18, color: textTheme.withValues(alpha: 0.5)),
                      onPressed: () {
                        _textController.clear();
                        _searchController.setSearchQuery('');
                        _performSearch();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              _searchController.setSearchQuery(value);
              _performSearch();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: primary),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: primary,
        child: Obx(() {
          final isLoading = _searchController.isLoading.value;
          final pelatihanList = _searchController.pelatihanList;
          final hasQuery = _textController.text.isNotEmpty;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme,
                    border: Border(
                      bottom: BorderSide(color: textTheme.withValues(alpha: 0.05)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kategori',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (_kategoriController.isLoading.value) {
                          return const SizedBox(
                            height: 40,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }
                        final activeCategories = _kategoriController.kategoriList
                            .where((k) => k.status)
                            .toList();
                        return SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: activeCategories.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                final isSelected = _searchController.selectedKategoriId.value == null;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(
                                      'Semua',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected ? theme : textTheme.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    avatar: Icon(Icons.all_inclusive, size: 18,
                                        color: isSelected ? theme : primary),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      _searchController.setKategoriId(null);
                                      _performSearch();
                                    },
                                    backgroundColor: theme,
                                    selectedColor: primary,
                                    showCheckmark: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                        color: isSelected ? primary : textTheme.withValues(alpha: 0.15),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final kategori = activeCategories[index - 1];
                              final isSelected = _searchController.selectedKategoriId.value == kategori.id;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: KategoriChip(
                                  kategori: kategori,
                                  isSelected: isSelected,
                                  onTap: () {
                                    if (isSelected) {
                                      _searchController.setKategoriId(null);
                                    } else {
                                      _searchController.setKategoriId(kategori.id);
                                    }
                                    _performSearch();
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _showSortMenu,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sort, size: 14, color: primary),
                              const SizedBox(width: 4),
                              Obx(() => Text(
                                _searchController.getSortDisplayName(_searchController.selectedSort.value),
                                style: TextStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w500),
                              )),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down, size: 16, color: primary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              if (isLoading && pelatihanList.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ProdukSkeleton(),
                      ),
                      childCount: 6,
                    ),
                  ),
                )
              else if (pelatihanList.isEmpty && hasQuery)
                SliverFillRemaining(
                  child: _buildEmptyState(
                    context,
                    Icons.search_off,
                    'Tidak ada pelatihan ditemukan',
                    'Coba kata kunci lain',
                  ),
                )
              else if (pelatihanList.isEmpty)
                SliverFillRemaining(
                  child: _buildEmptyState(
                    context,
                    Icons.search,
                    'Cari pelatihan favoritmu',
                    'Ketik kata kunci di atas',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pelatihan = pelatihanList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ProdukCard.forPelatihan(pelatihan: pelatihan),
                        );
                      },
                      childCount: pelatihanList.length,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}