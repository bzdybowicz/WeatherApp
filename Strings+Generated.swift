// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum CurrentWeather {
    /// Localizable.strings
    ///   WeatherApp
    /// 
    ///   Created by Bartlomiej Zdybowicz on 26/10/2023.
    internal static let title = L10n.tr("Localizable", "currentWeather.title", fallback: "Current temperature")
    internal enum CustomLocationButton {
      /// Select location
      internal static let title = L10n.tr("Localizable", "currentWeather.customLocationButton.title", fallback: "Select location")
    }
    internal enum Default {
      /// Presenting temperature for current user location
      internal static let description = L10n.tr("Localizable", "currentWeather.default.description", fallback: "Presenting temperature for current user location")
    }
    internal enum KeyAlert {
      /// Ok
      internal static let confirmText = L10n.tr("Localizable", "currentWeather.keyAlert.confirmText", fallback: "Ok")
      /// It is inconvenient, but since this is secret, it is necessarily.
      internal static let description = L10n.tr("Localizable", "currentWeather.keyAlert.description", fallback: "It is inconvenient, but since this is secret, it is necessarily.")
      /// Enter your api key
      internal static let title = L10n.tr("Localizable", "currentWeather.keyAlert.title", fallback: "Enter your api key")
    }
    internal enum LocationDisabled {
      /// You need to enable location services in system settings
      internal static let message = L10n.tr("Localizable", "currentWeather.locationDisabled.message", fallback: "You need to enable location services in system settings")
    }
    internal enum LocationError {
      /// Location cannot be obtained. Try again later.
      internal static let message = L10n.tr("Localizable", "currentWeather.locationError.message", fallback: "Location cannot be obtained. Try again later.")
    }
    internal enum NetworkError {
      /// Cannot fetch weather. Try again later.
      internal static let message = L10n.tr("Localizable", "currentWeather.networkError.message", fallback: "Cannot fetch weather. Try again later.")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
