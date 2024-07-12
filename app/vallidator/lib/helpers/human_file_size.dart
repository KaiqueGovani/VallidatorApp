import 'dart:math' as math;

String humanFileSize(int byteCount, {bool si = false, int dp = 1}) {
  double bytes = byteCount.toDouble();
  final int thresh = si ? 1000 : 1024;

  if (bytes.abs() < thresh) {
    return '$byteCount B';
  }

  final List<String> units = si
      ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
      : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
  int u = -1;
  final double r = math.pow(10, dp).toDouble();

  do {
    bytes /= thresh;
    ++u;
  } while ((bytes.abs() * r).round() / r >= thresh && u < units.length - 1);

  return '${bytes.toStringAsFixed(dp)} ${units[u]}';
}