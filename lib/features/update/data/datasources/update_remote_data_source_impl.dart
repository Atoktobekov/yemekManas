import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/models/update_info_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UpdateRemoteDataSourceImpl implements UpdateRemoteDataSource {
  final FirebaseRemoteConfig remoteConfig;
  final Talker talker;

  UpdateRemoteDataSourceImpl({
    required this.remoteConfig,
    required this.talker,
  }) {
    remoteConfig.setDefaults({
      "latest_version": "1.0.0",
      "update_required": false,
      "update_url": "",
      "update_changelog": "Initial release.",
    });

    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  @override
  Future<(UpdateInfoModel, String)?> fetchUpdateInfo() async {
    try {
      await remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final latestVersion = remoteConfig.getString("latest_version");
      final updateRequired = remoteConfig.getBool("update_required");
      final updateUrl = remoteConfig.getString("update_url");
      final changelog = remoteConfig.getString("update_changelog");

      if (latestVersion.isEmpty || updateUrl.isEmpty) return null;

      final model = UpdateInfoModel(
        latestVersion: latestVersion,
        isForceUpdate: updateRequired,
        updateUrl: updateUrl,
        changelog: changelog,
      );

      return (model, currentVersion);
    } catch (e, st) {
      talker.handle(e, st, "[UpdateRemoteDataSourceImpl]");
      rethrow;
    }
  }
}