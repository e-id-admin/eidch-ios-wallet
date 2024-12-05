#if DEBUG
import BITCore
import Foundation

@testable import BITCredentialShared
@testable import BITTestingCore

// MARK: CredentialDisplay.Mock

extension CredentialDisplay {
  struct Mock {
    static var sample: CredentialDisplay = .init(name: "Some credential", locale: UserLocale.defaultLocaleIdentifier)
    static var arraySample: [CredentialDisplay] = [
      .init(name: "Test", locale: UserLocale.defaultLocaleIdentifier),
      .init(name: "Blob", backgroundColor: "#333333", locale: UserLocale.LocaleIdentifier.swissFrench.rawValue),
      .init(name: "Blob2", backgroundColor: "#333333", locale: UserLocale.LocaleIdentifier.swissGerman.rawValue),
    ]
  }
}
#endif
