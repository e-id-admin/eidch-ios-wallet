import CryptoKit
import Foundation

public struct SHA256Hasher: BITCrypto.Hashable {

  public init() {}

  public func hash(_ data: Data) -> Data {
    SHA256.hash(data: data).asData
  }

}
