class UpdateInfoEntity {
  final String latestVersion;
  final bool isForceUpdate;
  final String updateUrl;
  final String changelog;

  const UpdateInfoEntity({
    required this.latestVersion,
    required this.isForceUpdate,
    required this.updateUrl,
    required this.changelog,
  });
}
