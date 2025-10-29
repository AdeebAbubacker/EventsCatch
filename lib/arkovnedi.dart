import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



/// Singleton Service for Firebase Analytics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  Map<String, dynamic>? _baseInfo;

  AnalyticsService._internal() {
    _init();
  }

  Future<void> _init() async {
    await _initBaseInfo();
    await _analytics.setAnalyticsCollectionEnabled(true);
    CustomLog.info(this, "Firebase Analytics initialized successfully.");
  }

  /// Initialize base info (device, app, os)
  Future<void> _initBaseInfo() async {
    _baseInfo ??= await _fetchBaseInfo();
  }

  /// Fetch device and app info
  Future<Map<String, dynamic>> _fetchBaseInfo() async {
    try {
      String unknown = "Unknown";
      String os = unknown;
      String osVersion = unknown;
      String device = unknown;

      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        os = "android";
        osVersion = "${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})";
        device = "${androidInfo.brand} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        os = "iOS";
        osVersion = "${iosInfo.systemName} ${iosInfo.systemVersion}";
        device = "${iosInfo.utsname.machine}";
      }

      final packageInfo = await PackageInfo.fromPlatform();

      return {
        "language": Platform.localeName,
        "os": os,
        "os_version": osVersion,
        "device": device,
        "app_name": packageInfo.appName,
        "package_name": packageInfo.packageName,
        "app_version": packageInfo.version,
      };
    } catch (e) {
      CustomLog.error(this, "Failed to fetch base info", e);
      return {};
    }
  }

  /// Log any Firebase custom event
  Future<void> logEvent(String eventName, [Map<String, dynamic>? parameters]) async {
    try {
      await _initBaseInfo();
      await _analytics.logEvent(
        name: eventName,
        parameters: {
          ...?_baseInfo,
          ...?parameters,
        },
      );
      CustomLog.info(this, "✅ Logged event: $eventName with params: $parameters");
    } catch (e) {
      CustomLog.error(this, "❌ Failed to log event: $eventName", e);
    }
  }

  /// Log screen view event
  Future<void> logScreenView(String screenName, [String? screenClass]) async {
    try {
      await _initBaseInfo();
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
        parameters: {
          ...?_baseInfo,
        },
      );
      CustomLog.info(this, "📱 Screen view logged: $screenName");
    } catch (e) {
      CustomLog.error(this, "Failed to log screen view", e);
    }
  }

  /// Log select content event (e.g., clicking a product)
  Future<void> logSelectContent(String contentType, [String? itemName, String? itemId]) async {
    try {
      await _initBaseInfo();
      await _analytics.logEvent(
        name: "select_content",
        parameters: {
          ...?_baseInfo,
          "content_type": contentType,
          "item_name": itemName ?? "",
          "item_id": itemId ?? "",
        },
      );
      CustomLog.info(this, "🛒 Logged select_content: $itemName ($itemId)");
    } catch (e) {
      CustomLog.error(this, "Failed to log select_content", e);
    }
  }

  /// Set Firebase Analytics User ID
  Future<void> setUser(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
      CustomLog.info(this, "👤 User ID set: $userId");
    } catch (e) {
      CustomLog.error(this, "Failed to set user ID", e);
    }
  }

  /// Log app open event
  Future<void> logAppOpen() async {
    await logEvent("app_open", {"opened_at": DateTime.now().toIso8601String()});
  }

  /// Log session start
  Future<void> logSessionStart() async {
    await logEvent("session_start", {"started_at": DateTime.now().toIso8601String()});
  }
}

/// All Analytics Event Names (constants)
class AnalyticEventName {
  AnalyticEventName._();

  // Common keys
  static const String ITEM_NAME = "item_name";
  static const String ITEM_ID = "item_id";
  static const String CATEGORY = "category";
  static const String SUCCESS = "success";
  static const String FAILURE = "failure";

  // Fleet Events
  static const String FLEET_PRODUCT_CATALOG_CREATED = "fleet_product_catalog_created";
  static const String FLEET_ORDER_CREATION = "fleet_order_creation";

  // Onboarding
  static const String ONBOARD_MOBILE_ENTERED = "onboard_mobile_entered";
  static const String ONBOARD_OTP_SENT = "onboard_otp_sent";
  static const String ONBOARD_OTP_VERIFIED = "onboard_otp_verified";
  static const String ONBOARD_OTP_FAILED = "onboard_otp_failed";
  static const String ONBOARD_ROLE_SELECTED = "onboard_role_selected";

  // Vehicle Partner (VP)
  static const String VP_HOME = "vp_home";
  static const String VP_MY_LOAD = "vp_my_load";
  static const String ONBOARD_VP_FORM_SUBMITTED = "onboard_vp_form_submitted";
  static const String ACCEPT_LOAD = "accept_load";
  static const String VP_BLUE_MEMBERSHIP_ID = "vp_blue_membership_id";

  // Logistics Partner (LP)
  static const String LP_HOME = "lp_home";
  static const String LP_MY_LOAD = "lp_my_load";
  static const String ONBOARD_LP_FORM_SUBMITTED = "onboard_lp_form_submitted";
  static const String CREATE_LOAD = "create_load";
  static const String LP_BLUE_MEMBERSHIP_ID = "lp_blue_membership_id";

  // Shared
  static const String SWITCH_TO_LP = "switch_to_lp";
  static const String SWITCH_TO_VP = "switch_to_vp";

  // KYC
  static const String AADHAAR_VERIFICATION_SUCCESS = "aadhaar_verification_success";
  static const String AADHAAR_VERIFICATION_FAILED = "aadhaar_verification_failed";
  static const String KYC_FORM_SUBMITTED = "kyc_form_submitted";
  static const String KYC_PENDING = "kyc_pending";
  static const String KYC_IN_PROGRESS = "kyc_in_progress";
  static const String KYC_COMPLETED = "kyc_completed";

  // Master
  static const String ADD_DRIVER = "add_driver";
  static const String ADD_VEHICLE = "add_vehicle";

  // Load Documents
  static const String LORRY_RECEIPT_UPLOADED = "lorry_receipt_uploaded";
  static const String E_WAY_BILL_UPLOADED = "e_way_bill_uploaded";
  static const String MATERIAL_INVOICE_UPLOADED = "material_invoice_uploaded";
  static const String OTHERS_DOCUMENT_UPLOADED = "others_document_uploaded";
  static const String POD_DOCUMENT_UPLOADED = "pod_document_uploaded";

  // POD
  static const String POD_DETAILS_ADDED = "pod_details_added";

  // Damage & Shortage
  static const String DAMAGE_SHORTAGE_ADDED = "damage_shortage_added";
  static const String SETTLEMENT_ADDED = "settlement_added";
}

class CustomLog {

  static final _logger = Logger(printer: PrettyPrinter());

  static void debug(Object instance, String message) {
    if(kDebugMode){
      _logger.d(message = "[${instance.runtimeType.toString()}] $message", time: DateTimeHelper.now());
    }
  }

  static void info(Object instance, String message) {
    if(kDebugMode){
      _logger.i(message = "[${instance.runtimeType.toString()}] $message", time: DateTimeHelper.now());
    }
  }

  static void error(Object instance, String message, Object? exception) {
    if(kDebugMode){
      _logger.e(
          message = "[${instance.runtimeType.toString()}] $message",
          time: DateTime.now(),
          error: exception,
      );
    }
  }

}


class DateTimeHelper {
  DateTimeHelper._();

  /// Get Current Date Time
  static DateTime now() {
    return DateTime.now();
  }

  /// Get Date Time Format
  static String getDateTimeFormat(DateTime date) {
    final istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));
    var formatter = DateFormat('dd/MM/yyyy - hh:mm a');
    return formatter.format(istDate);
  }

  /// Get Time Format With Am or Pm
  static String getTimeFormatWithAmOrPm(DateTime date) {
    var formatter = DateFormat('hh:mm a');
    return formatter.format(date.toLocal());
  }

  /// Get Format Date
  static String getFormattedDate(DateTime date) {
    var formatter = DateFormat("dd-MM-yyyy");
    return formatter.format(date.toLocal());
  }

  /// Get Date With Short Name
  static String getFormattedDateWithShortMonthName(DateTime date) {
    var formatter = DateFormat("dd MMM yyyy");
    return formatter.format(date.toLocal());
  }

  /// Convert to AM or Pm
  static String convertToAmPm(String time, BuildContext context) {
    DateTime parsedTime = DateTime.parse('1970-01-01 $time:00');
    String formattedTime = TimeOfDay.fromDateTime(parsedTime).format(context);
    return formattedTime;
  }

  /// Convert to API/database format: "2025-06-14T20:00:00.000Z"
  static String convertToDatabaseFormat(String date) {
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      // Convert to UTC and format as ISO 8601
      return parsedDate.toUtc().toIso8601String(); // e.g., "2025-06-14T00:00:00.000Z"
    } catch (e) {
      return "Invalid Date";
    }
  }


  /// Convert to database format
  static String convertToDatabaseFormat2(String date) {
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      return DateFormat("yyyy-MM-dd").format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// Output: 14 Jul, 2025, 7.30 PM
  static String formatCustomDate(DateTime date) {
    try {
    return DateFormat("d MMM y, hh:mm a").format(date.toLocal());
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// convert to IST format
  static String formatCustomDateTimeIST(DateTime? date) {
    try {
      if (date == null) return "Invalid Date";
      final istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateFormat("d MMM y, hh:mm a").format(istDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// convert to IST format
  static String formatCustomDateIST(DateTime? date) {
    try {
      if (date == null) return "Invalid Date";
      final istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateFormat("d MMM y").format(istDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  static DateTime? convertStringToDateTime(String dateString) {
    try {
      // Define input format (DD/MM/YYYY)
      final DateFormat format = DateFormat("dd/MM/yyyy");
      return format.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Input Date Format : dd/MM/yyyy
  static DateTime convertToDateTimeWithCurrentTime(String date) {
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(date);
      DateTime now = DateTime.now();
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, now.hour, now.minute, now.second);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Input Format hh : mm a , example- 05 : 15 PM
  static TimeOfDay convertStringToTimeOfDay(String timeString) {
    try {
      final DateFormat format = DateFormat("hh : mm a");
      final DateTime parsedDateTime = format.parse(timeString);
      return TimeOfDay(hour: parsedDateTime.hour, minute: parsedDateTime.minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }



  /// Converts date and time strings into ISO8601 UTC format for API
  static String convertToApiDateTime(String date, String time) {
    try {
      // Combine date and time strings
      String input = "$date , $time";

      // Expected format
      final inputFormat = DateFormat("dd/MM/yyyy , hh : mm a");

      // Parse to DateTime in local time
      final localDateTime = inputFormat.parse(input);

      // Convert to UTC
      final utcDateTime = localDateTime.toUtc();

      // Return ISO 8601 format string
      return utcDateTime.toIso8601String();
    } catch (e) {
      return ""; // or throw an error/log it
    }


  }

  /// Converts ISO8601 string to "dd-MM-yyyy | hh:mm a" format in IST
  static String formatToDateTimeWithTime(String isoDateString) {
    try {
      final dateTime = DateTime.parse(isoDateString).toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateFormat("dd-MM-yyyy | hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// Returns current date and time plus given duration (in seconds) formatted as "dd-MM-yyyy, hh:mm a"
  static String getCurrentDateTimeWithAddedDuration(int durationInSeconds) {
    try {
      final dateTime = DateTime.now().add(Duration(seconds: durationInSeconds));
      return DateFormat("d MMM y, hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }





}
