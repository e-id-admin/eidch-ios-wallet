import BITJWT
import Factory
import Foundation

// MARK: - TokenStatusListDecoder

struct TokenStatusListDecoder: TokenStatusListDecoderProtocol {

  // MARK: Internal

  enum DecoderError: Error {
    case invalidStatusJWT
  }

  func decode(_ rawJWT: String, index: Int) throws -> StatusCode {
    guard
      let jwtPayload = jwtDecoder.decodePayload(from: rawJWT),
      let json = try JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any],
      let statusList = json["status_list"] as? [String: Any],
      let bits = statusList["bits"] as? Int,
      let encodedList = statusList["lst"] as? String,
      let listData = Data(base64URLEncoded: encodedList)
    else {
      throw DecoderError.invalidStatusJWT
    }

    let nsData = listData.dropFirst(2) as NSData // first two header bytes are not used

    let decompressedData = try nsData.decompressed(using: .zlib) as Data
    return try tokenStatusListByteDecoder.decode(decompressedData, bits: bits, index: index)
  }

  // MARK: Private

  @Injected(\.tokenStatusListByteDecoder) private var tokenStatusListByteDecoder: TokenStatusListByteDecoderProtocol
  @Injected(\.jwtDecoder) private var jwtDecoder: JWTDecoderProtocol

}
