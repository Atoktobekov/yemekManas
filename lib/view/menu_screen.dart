import 'package:ManasYemek/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';
import 'package:ManasYemek/services/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final progressNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MenuViewModel>();
      if (viewModel.status == MenuStatus.initial) {
        viewModel.fetchMenu();
      }
      final checkForUpdateService = CheckForUpdateService(progressNotifier: progressNotifier);
      if (!mounted) return;
      checkForUpdateService.checkForUpdate(context);
      //GetIt.instance<CheckForUpdateService>().checkForUpdate(context);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Yemekhane Menu',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TalkerScreen(talker: GetIt.instance<Talker>()),
                ),
              );
            },
            icon: const Icon(
              Icons.document_scanner_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.status == MenuStatus.loaded) {
            if (!_fadeController.isCompleted) _fadeController.forward();
          } else {
            _fadeController.reset();
          }

          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount: 3,
                separatorBuilder: (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Divider(thickness: 1, color: Colors.grey),
                ),
                itemBuilder: (_, _) => const DayMenuSkeleton(),
              );

            case MenuStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          viewModel.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFAEEDD),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: viewModel.fetchMenu,
                        child: const Text('Try again', style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),),
                      ),
                    ],
                  ),
                ),
              );

            case MenuStatus.loaded:
              //_fadeController.forward();
              return RefreshIndicator(
                onRefresh: () async {
                  _fadeController.reset();
                  await viewModel.fetchMenu();
                },
                child: Column(
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: progressNotifier,
                      builder: (context, value, _) {
                        if (value == 0 || value == 1) return const SizedBox.shrink();
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 4,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        );
                      },
                    )
,
                    if (viewModel.isCached)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 12.0,
                          right: 6.0,
                        ),
                        child: Text(
                          viewModel.message,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        itemCount: viewModel.menus.length,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        itemBuilder: (context, index) {
                          return StaggeredDayMenuWidget(
                            dayMenu: viewModel.menus[index],
                            index: index,
                            animation: _fadeAnimation,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
