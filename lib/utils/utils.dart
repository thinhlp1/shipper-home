import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static late Size size;

  static double? screenHeight;
  static double? screenWidth;

  static double? productHeight;
  static double? productWidth;

  static double? maxProductHeight;
  static double? maxProductWidth;

  static double? categoryHeight;
  static double? categoryWidth;

  static double? maxCategoryHeight;
  static double? maxCategoryWidth;

  static double? customerHeight;
  static double? customerWidth;

  static double? maxCustomerHeight;
  static double? maxCustomerWidth;

  static const double defaultCustomerHight = 100.0;

  static const SizedBox sizedBoxHeight8 = SizedBox(height: 8);
  static const SizedBox sizedBoWidth16 = SizedBox(width: 16);

  /// Initializes the size properties based on the given [BuildContext].
  ///
  /// This method retrieves the size of the screen using the [MediaQuery]
  /// and assigns the height and width to the respective static variables.
  ///
  /// - Parameter context: The [BuildContext] to retrieve the screen size from.
  static initSize(BuildContext context) {
    size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
  }

  /// Initializes the product size by setting the `productWidth` and `productHeight`
  /// based on the screen width. If `productWidth` and `productHeight` are not already set,
  /// it calculates them using a proportion of the screen width, ensuring they do not exceed
  /// the maximum allowed dimensions (`maxProductWidth` and `maxProductHeight`).
  ///
  /// The maximum dimensions are set to 200 for width and 450 for height.
  /// The product width is calculated as 42% of the screen width, but not exceeding the maximum width.
  /// The product height is calculated as 1.8 times the product width, but not exceeding the maximum height.
  @Deprecated("Not used anymore")
  static initProductSize() {
    if (productWidth == null && productHeight == null) {
      maxProductWidth = 200;
      maxProductHeight = 450;

      productWidth = screenWidth! * 0.42 > maxProductWidth!
          ? maxProductWidth
          : screenWidth! * 0.42;
      productHeight = productWidth! * 1.8 > maxProductHeight!
          ? maxProductHeight
          : productWidth! * 1.8;
    }
  }

  @Deprecated("Not used anymore")
  static initCategorySize() {
    if (categoryWidth == null && categoryHeight == null) {
      maxCategoryWidth = 200;
      maxCategoryHeight = 450;

      categoryWidth = screenWidth! * 0.3 > maxCategoryWidth!
          ? maxCategoryWidth
          : screenWidth! * 0.3;
      categoryHeight = categoryWidth! * 1.4 > maxCategoryHeight!
          ? maxCategoryHeight
          : categoryWidth! * 1.4;
    }
  }

  /// Initializes the customer size by setting the customer width and height
  /// based on the screen width and height.
  ///
  /// The customer width is set to 90% of the screen width, and the customer
  /// height is set to 50% of the screen height.
  static initCustomerSize() {
    customerWidth = screenWidth! * 0.9;
    customerHeight = screenHeight! * 0.5;
  }

  /// Formats a [DateTime] object into a string with the format 'dd/MM/yyyy'.
  ///
  /// The [date] parameter is the [DateTime] object to be formatted.
  ///
  /// Returns a string representation of the [date] in the format 'dd/MM/yyyy'.
  static formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  /// Formats a given number as currency according to the Vietnamese locale.
  ///
  /// This function takes a numeric value and formats it as a currency string
  /// using the 'vi_VN' locale, which is the locale for Vietnam.
  ///
  /// Example:
  /// ```dart
  /// String formatted = Utils.formatCurrency(1234567);
  /// print(formatted); // Outputs: 1.234.567 ₫
  /// ```
  ///
  /// - Parameter number: The numeric value to be formatted as currency.
  /// - Returns: A string representing the formatted currency.
  static formatCurrency(num number) {
    return NumberFormat.currency(locale: 'vi_VN').format(number);
  }
}
