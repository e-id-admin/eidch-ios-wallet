import BITNetworking
import Foundation
import Moya

// MARK: - OpenIDEndpoint

enum OpenIDEndpoint {
  case metadata(fromIssuerUrl: URL)
  case credential(url: URL, body: CredentialRequestBody, acccessToken: String)
  case accessToken(fromTokenUrl: URL, preAuthorizedCode: String)
  case openIdConfiguration(issuerURL: URL)
  case status(url: URL)
  case publicKeyInfo(jwksUrl: URL)
  case requestObject(url: URL)
  case trustStatements(url: URL, issuerDid: String)
}

// MARK: TargetType

extension OpenIDEndpoint: TargetType {
  var baseURL: URL {
    switch self {
    case .metadata(let issuerUrl):
      issuerUrl
    case .openIdConfiguration(let issuerURL):
      issuerURL
    case .accessToken(let tokenUrl, _):
      tokenUrl
    case .credential(let credentialURL, _, _):
      credentialURL
    case .status(let url):
      url
    case .publicKeyInfo(let jwksUrl):
      jwksUrl
    case .requestObject(let url):
      url
    case .trustStatements(let url, _):
      url
    }
  }

  var path: String {
    switch self {
    case .metadata:
      "/.well-known/openid-credential-issuer"
    case .openIdConfiguration:
      "/.well-known/openid-configuration"
    case .trustStatements(_, let did):
      "/api/v1/truststatements/\(did)"
    case .accessToken,
         .credential,
         .publicKeyInfo,
         .requestObject,
         .status:
      "" // The path is already included in the baseUrl of the tokenUrl
    }
  }

  var method: Moya.Method {
    switch self {
    case .metadata,
         .openIdConfiguration,
         .publicKeyInfo,
         .requestObject,
         .status,
         .trustStatements:
      .get
    case .accessToken,
         .credential:
      .post
    }
  }

  var task: Task {
    switch self {
    case .metadata,
         .openIdConfiguration,
         .publicKeyInfo,
         .requestObject,
         .status,
         .trustStatements:
      .requestPlain

    case .accessToken(_, let preAuthorizedCode):
      .requestParameters(parameters: [
        "grant_type": "urn:ietf:params:oauth:grant-type:pre-authorized_code",
        "pre-authorized_code": preAuthorizedCode,
      ], encoding: URLEncoding.queryString)

    case .credential(_, let credentialBody, _):
      .requestParameters(
        parameters: credentialBody.asDictionary(),
        encoding: JSONEncoding.default)
    }
  }

  var headers: [String: String]? {
    switch self {
    case .accessToken,
         .metadata,
         .openIdConfiguration,
         .publicKeyInfo,
         .requestObject,
         .trustStatements:
      NetworkHeader.standard.raw
    case .credential(_, _, let token):
      NetworkHeader.authorization(token).raw
    case .status:
      NetworkHeader.statusList.raw
    }
  }
}
