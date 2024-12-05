import BITJWT
import Foundation

// MARK: - JWTRequestObject

public class JWTRequestObject: RequestObject {

  // MARK: Lifecycle

  init(jwt: JWT, payload: Data) throws {
    self.jwt = jwt

    let base = try JSONDecoder().decode(RequestObject.self, from: payload)

    super.init(
      presentationDefinition: base.presentationDefinition,
      nonce: base.nonce,
      responseUri: base.responseUri,
      clientMetadata: base.clientMetadata,
      responseType: base.responseType,
      clientId: base.clientId,
      clientIdScheme: base.clientIdScheme,
      responseMode: base.responseMode)
  }

  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let rawJWT = try container.decode(String.self, forKey: .jwt)
    jwt = try JWT(from: rawJWT)

    try super.init(from: decoder)
  }

  // MARK: Internal

  let jwt: JWT

  // MARK: Private

  private enum CodingKeys: String, CodingKey {
    case jwt
  }

}
