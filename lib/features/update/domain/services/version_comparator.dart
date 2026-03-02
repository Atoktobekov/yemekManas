class VersionComparator {
  bool isNewer(String server, String local) {
    try {
      final s = server.split('.').map(int.parse).toList();
      final l = local.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        if (s[i] > l[i]) return true;
        if (s[i] < l[i]) return false;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}