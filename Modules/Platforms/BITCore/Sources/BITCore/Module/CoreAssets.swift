// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#elseif os(tvOS) || os(watchOS)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - CoreAssets

// Deprecated typealiases

// swiftlint:disable superfluous_disable_command file_length implicit_return

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum CoreAssets {
}

// MARK: - BundleToken

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

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
