class NavUrl {
  NavUrl._();

  static const home = '/';

  static String gist({
    final String gistId = ':gistId',
  }) =>
      '/gist/$gistId';
}
