class AppLink {
  // 1
  static const String kHomePath = '/inicio';
  static const String kOnboardingPath = '/onboarding';
  static const String kLoginPath = '/login';
  static const String kProfilePath = '/profile';
  static const String kItemPath = '/item';
  // 2
  static const String kIdParam = 'id';
  // 3
  String? location;
  // 5
  String? itemId;
  // 6
  AppLink({
    this.location,
    this.itemId,
  });
  static AppLink fromLocation(String? location) {
    // 1
    location = Uri.decodeFull(location ?? '');
    // 2
    final uri = Uri.parse(location);
    final params = uri.queryParameters;
    // 4
    final itemId = params[AppLink.kIdParam];
    // 5
    final link = AppLink(
      location: uri.path,
      itemId: itemId,
    );
    // 6
    return link;
  }

  String toLocation() {
    // 1
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '${key}=$value&';
    // 2
    switch (location) {
      // 3
      case kLoginPath:
        return kLoginPath;
      // 4
      case kOnboardingPath:
        return kOnboardingPath;
      // 5
      case kProfilePath:
        return kProfilePath;
      // 6
      case kItemPath:
        var loc = '$kItemPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      // 7
      default:
        var loc = '$kHomePath?';
        return Uri.encodeFull(loc);
    }
  }
}
