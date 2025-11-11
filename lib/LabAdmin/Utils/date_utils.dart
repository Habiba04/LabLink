import 'package:intl/intl.dart';

String timeAgo(DateTime? dt) {
  if (dt == null) return 'Unknown';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  return DateFormat('MMM d, yyyy').format(dt);
}
