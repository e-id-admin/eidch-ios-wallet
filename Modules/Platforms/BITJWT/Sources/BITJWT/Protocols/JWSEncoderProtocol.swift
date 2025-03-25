import BITCrypto
import Foundation

public protocol JWSEncoderProtocol {
  func encode<T>(_ value: T, using keyPair: KeyPair) throws -> Data where T: JWTType & Encodable
}
