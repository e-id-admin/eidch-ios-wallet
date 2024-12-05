import CryptoKit
import Foundation

public struct SHA384Hasher: BITCrypto.Hashable {

  public init() {}

  public func hash(_ data: Data) -> Data {
    SHA384.hash(data: data).asData
  }

}
