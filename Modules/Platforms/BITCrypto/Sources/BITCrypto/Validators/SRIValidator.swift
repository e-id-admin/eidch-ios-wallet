import Foundation

// MARK: - SRIError

enum SRIError: Error {
  case malformedIntegrity
  case unsupportedAlgorithm
}

// MARK: - SRIValidator

public struct SRIValidator: SRIValidatorProtocol {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public func validate(_ data: Data, with integrity: String) throws -> Bool {
    let components = integrity.split(separator: separator, maxSplits: componentsSplitMax)

    guard components.count == integrityPartsCount else {
      throw SRIError.malformedIntegrity
    }

    guard
      let algorithm = components.first?.lowercased(),
      let integrityHashAlgorithm = IntegrityHash.Algorithm(rawValue: algorithm)
    else {
      throw SRIError.unsupportedAlgorithm
    }

    let digest = String(components[1])

    let base64hash = integrityHashAlgorithm
      .hash(data: data)
      .base64EncodedString()

    return base64hash == digest
  }

  // MARK: Private

  private let separator = "-"
  private let integrityPartsCount = 2
  private let componentsSplitMax = 1
}
