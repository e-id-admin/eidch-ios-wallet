import Foundation

public typealias UserLocale = String
public typealias UserLanguageCode = String

// MARK: - UserLocale.LocaleIdentifier

extension UserLocale {

  public enum LocaleIdentifier: String {
    case swissGerman = "de-CH"
    case swissFrench = "fr-CH"
    case swissItalian = "it-CH"
    case swissEnglish = "en-CH"
  }

  public static var defaultLocaleIdentifier: UserLocale = LocaleIdentifier.swissGerman.rawValue

}

extension UserLanguageCode {

  public enum LanguageIdentifier: String {
    case german = "de"
    case french = "fr"
    case italian = "it"
    case english = "en"
  }

  public static var defaultAppLanguageCode: UserLanguageCode = LanguageIdentifier.english.rawValue

}
