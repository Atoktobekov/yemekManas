class UpdateInfoModel {
  final String latestVersion;
  final bool isForceUpdate;
  final String updateUrl;
  final String changelog;

  UpdateInfoModel({
    required this.latestVersion,
    required this.isForceUpdate,
    required this.updateUrl,
    required this.changelog,
  });
}