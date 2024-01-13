import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

formatDate(Timestamp? timestamp) {
  final date = timestamp!.toDate();
  final formatDate = DateFormat("yyyy-MM-dd").format(date);
  return formatDate;
}
