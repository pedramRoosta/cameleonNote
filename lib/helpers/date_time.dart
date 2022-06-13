import 'package:cameleon_note/constants/constants.dart';
import 'package:intl/intl.dart';

abstract class Helper {
  static String toDateFormat({required DateTime date}) {
    final dateFormatter = DateFormat(GeneralConstant.dateTimeFormat);
    return dateFormatter.format(date);
  }
}
