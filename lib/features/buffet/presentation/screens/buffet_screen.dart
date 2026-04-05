import 'package:ManasYemek/shared/presentation/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_category_entity.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:ManasYemek/features/buffet/presentation/providers/buffet_provider.dart';
import 'package:ManasYemek/features/buffet/presentation/widgets/buffet_header.dart';
import 'package:ManasYemek/features/buffet/presentation/widgets/buffet_body.dart';

class BuffetScreen extends StatefulWidget {
  const BuffetScreen({super.key});

  @override
  State<BuffetScreen> createState() => _BuffetScreenState();
}

class _BuffetScreenState extends State<BuffetScreen> {
  late final ScrollController _scrollController;
  late final ScrollController _categoryScrollController;
  late String _activeCategoryId;

  final Map<String, GlobalKey> _sectionKeys = {};
  final Map<String, GlobalKey> _categoryButtonKeys = {};
  bool _isProgrammaticScroll = false;

  static const double _headerOffset = 100;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _categoryScrollController = ScrollController();
    _activeCategoryId = '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BuffetProvider>().loadMenu();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _initKeys(List<BuffetCategoryEntity> categories) {
    if (_sectionKeys.isNotEmpty) return;
    for (final c in categories) {
      _sectionKeys[c.id] = GlobalKey();
      _categoryButtonKeys[c.id] = GlobalKey();
    }
    if (categories.isNotEmpty) _activeCategoryId = categories.first.id;
  }

  void _handleScroll() {
    if (_isProgrammaticScroll || _sectionKeys.isEmpty) return;
    String? current;
    for (final key in _sectionKeys.entries) {
      final ctx = key.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      if (box.localToGlobal(Offset.zero).dy <= _headerOffset + 20) {
        current = key.key;
      }
    }
    if (current != null && current != _activeCategoryId) {
      setState(() => _activeCategoryId = current!);
      _scrollCategoryToCenter(current);
    }
  }

  Future<void> _scrollToCategory(String id) async {
    final ctx = _sectionKeys[id]?.currentContext;
    if (ctx == null) return;
    setState(() => _activeCategoryId = id);
    _scrollCategoryToCenter(id);
    _isProgrammaticScroll = true;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    final target = _scrollController.offset - _headerOffset + 16;
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        target.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
    _isProgrammaticScroll = false;
  }

  void _scrollCategoryToCenter(String id) {
    final ctx = _categoryButtonKeys[id]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final target = _categoryScrollController.offset +
        box.localToGlobal(Offset.zero).dx -
        MediaQuery.of(context).size.width / 2 +
        box.size.width / 2;
    if (_categoryScrollController.hasClients) {
      _categoryScrollController.animateTo(
        target.clamp(0.0, _categoryScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      appBar: AppBar(
        title: const Text('Buffet Menu', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Consumer<BuffetProvider>(
          builder: (context, provider, _) {
            return switch (provider.status) {
              BuffetStatus.initial || BuffetStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              BuffetStatus.error => ErrorScreen(
                onRetry: () => context.read<BuffetProvider>().loadMenu(),
              ),
              BuffetStatus.loaded => _buildContent(provider.menu!),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuffetMenuEntity menu) {
    _initKeys(menu.categories);
    return Column(
      children: [
        BuffetHeader(
          categories: menu.categories,
          activeCategoryId: _activeCategoryId,
          categoryScrollController: _categoryScrollController,
          categoryButtonKeys: _categoryButtonKeys,
          onCategoryTap: _scrollToCategory,
        ),
        Expanded(
          child: BuffetBody(
            scrollController: _scrollController,
            categories: menu.categories,
            sectionKeys: _sectionKeys,
            currency: menu.currency,
          ),
        ),
      ],
    );
  }
}