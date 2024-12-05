import Foundation
import JOSESwift
import Spyable

// MARK: - JWKHelperProtocol

@Spyable
public protocol JWKHelperProtocol {
  func getJwkData(using publicKey: SecKey, identifier: String) throws -> Data?
}

// MARK: - JWKHelper

public struct JWKHelper: JWKHelperProtocol {

  public init() {}

  /// Returns a JWK as Data
  public func getJwkData(using publicKey: SecKey, identifier: String) throws -> Data? {
    try ECPublicKey(publicKey: publicKey, additionalParameters: [Self.kidKey: identifier]).jsonData()
  }

  private static let kidKey: String = "kid"

}
