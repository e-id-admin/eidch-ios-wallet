import Foundation

extension String {

  // MARK: Public

  public var separatedByDisclosures: [SubSequence] {
    split(separator: SdJWT.disclosuresSeparator)
  }

  // MARK: Internal

  func digest(algorithm: StringDigest.Algorithm) throws -> String {
    try StringDigest(content: self).createDigest(algorithm: algorithm)
  }

}
