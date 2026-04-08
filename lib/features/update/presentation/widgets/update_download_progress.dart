import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';

class UpdateDownloadProgress extends StatelessWidget {
  const UpdateDownloadProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final updateProvider = context.watch<UpdateProvider>();

    return ValueListenableBuilder<double>(
      valueListenable: updateProvider.downloadProgress,
      builder: (_, value, _) {
        final isDownloading = value > 0 && value < 1;

        if (!isDownloading) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          top: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Column(
              key: const ValueKey("update_progress"),
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 7),
                  child: Center(
                    child: Text(
                      "Скачиваем новую версию... ${(value * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}