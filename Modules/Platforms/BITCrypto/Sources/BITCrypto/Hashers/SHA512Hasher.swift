import CryptoKit
import Foundation

public struct SHA512Hasher: BITCrypto.Hashable {

  public init() {}

  public func hash(_ data: Data) -> Data {
    SHA512.hash(data: data).asData
  }

}
