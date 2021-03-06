// Author Agus Widhiyasa

import 'package:flutter/foundation.dart';

class DateCompareValidator {
  DateCompareValidator({
    @required this.dateToCompare,
    @required this.fieldNameCompared
  });
  final String dateToCompare;
  final String fieldNameCompared;

  DateTime get date => DateTime.parse(dateToCompare);
}

class YearComparator {
  final int compareWithYear;
  final String fieldCompareTo;

  YearComparator({
    this.compareWithYear, 
    this.fieldCompareTo
  });
}

/// Input validator for simply validating Input
/// 
/// Example Usage:
/// ```
/// InputValidator.validate(value, "Field Name", isRequired: true, isEmail: true);
/// ```
class InputValidator {

  /// Validate input given [input] value, the error will displayed with [fieldName],
  /// 
  /// Example Error will be when `isRequired: true` the error will be
  /// 
  /// "Field Name tidak boleh kosong"
  /// 
  /// 
  /// [fieldName] nama field untuk error message
  /// 
  /// [isRequired]  Apakah Input harus berisi
  /// 
  /// [isNumber] 
  /// 
  /// [isNomorHandphone] Validasi nomor telepon, namun hanya __Kode Negara Indonesia__
  /// 
  /// [isEmail]
  /// 
  /// [isTanggalLahir] validasi tanggal lahir dengan format __dd-mm-yyyy atau yyyy-mm-dd__
  /// 
  /// [minLength] validasi minimal karakter
  /// 
  /// [exactLength] input karakter harus sama dengan panjang x
  /// 
  /// [minValue] ???
  /// 
  /// [maxLength] input tidak boleh lebih dari jumlah karakter X
  /// 
  static String validate(
    String input,
    String fieldName,
    {
      bool isRequired         = false,
      bool isNumber           = false,
      bool isNomorHandphone   = false,
      bool isEmail            = false,
      bool isTanggalLahir     = false,
      int minLength           = 0,
      int exactLength         = 0,
      // int minValue            = 0,
      int maxLength           = 0,

      // Same field value
      String sameValueAsField = "",
      String sameValueAs      = "",

      DateCompareValidator beforeDate,

      YearComparator greaterThanYear
    }
  ) {
    if (input == null) {
      return "$fieldName tidak boleh kosong";
    }

    var notRequired = !isRequired;

    int inputLength = input.length;

    if (isRequired && (input == null || input.isEmpty)) return "$fieldName tidak boleh kosong";

    if (isNumber) {
      var reg = RegExp("^[0-9]*\$");
      if (!reg.hasMatch(input)) return "$fieldName harus berupa Angka";
    }

    /// Validasi nomor telepon dengan awalan 08XXXXXXXXXX atau +628XXXXXXXXX
    /// hanya kode nomor Indonesia
    if (isNomorHandphone) {
      var telpRegex = RegExp(r'(\+(62)|08)[\d]{10,13}');
      if (!telpRegex.hasMatch(input)) return "$fieldName tidak valid";
    }

    if (isTanggalLahir) {
      var regexTanggalLahir = RegExp(r'(^[\d]{4}-[\d]{2}-[\d]{2}$|^[\d]{2}-[\d]{2}-[\d]{4}$)');
      bool isMatch = regexTanggalLahir.hasMatch(input);
      if(!isMatch) return "$fieldName tidak valid";
    }

    /// HEHEHE
    if (isEmail && !input.contains("@")) return "$fieldName tidak valid";

    // If not required, skip validation but 
    // when input greater than 0, validate input
    if (notRequired && inputLength > 0 && minLength > 0) {
      if (inputLength < minLength) 
          return "$fieldName tidak boleh kurang dari $minLength karakter";
    } 
    
    if (isRequired && inputLength >= 0 && minLength > 0) {
      if (inputLength < minLength) 
          return "$fieldName tidak boleh kurang dari $minLength karakter";
    }

    if (beforeDate != null) {
      // parse input as date
      try {
        DateTime inputAsDate = DateTime.parse(input);
        int differenceInDays = inputAsDate.difference(beforeDate.date).inDays;
        if (differenceInDays <= 0) {
          return "$fieldName harus lebih besar dari ${beforeDate.fieldNameCompared}";
        }
      } catch (e) {
        print("Cant parse string as date");
      }
    }

    if (maxLength > 0 && inputLength > maxLength)
      return "$fieldName tidak boleh lebih dari $maxLength karakter";

    if (inputLength > 0 && exactLength > 0 && inputLength != exactLength)
      return "$fieldName harus sama dengan $exactLength karakter";

    if (greaterThanYear != null) {
      // convert input to integer
      int currentYear = int.parse(input);
      if (currentYear < greaterThanYear.compareWithYear) {
        return "$fieldName harus lebih besar dari ${greaterThanYear.fieldCompareTo}";
      }
    }

    return null;
  }
}