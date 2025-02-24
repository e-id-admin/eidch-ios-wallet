#if DEBUG
import Foundation
@testable import BITCrypto
@testable import BITTestingCore

extension FetchCredentialContext {

  struct Mock {

    // MARK: Internal

    static let sample = make(format: "some-format")
    static let sampleVcSdJwt = make(format: "vc+sd-jwt")
    static let sampleVcSdJwtWithoutHolderBinding = make(format: "vc+sd-jwt", noHolderBinding: true)
    static let sampleVcInvalid = make(format: "invalid_vc", invalid: true)

    // MARK: Private

    // swiftlint:disable all
    private static let mockEndpointsUrl = URL(string: "http://some.endpoint")!
    private static let mockJwksUrl = URL(string: "http://some.jwks")!

    // swiftlint:enable all

    private static func make(format: String, invalid: Bool = false, noHolderBinding: Bool = false) -> FetchCredentialContext {
      guard let mockCredentialsSupported: any CredentialMetadata.AnyCredentialConfigurationSupported = CredentialMetadata.Mock.sample.credentialConfigurationsSupported.first(where: { $0.key == "elfa-sdjwt" })?.value else {
        fatalError("Mock of CredentialMetadata doesn't contain valid credentialConfigurationSupported")
      }
      let keyPair = noHolderBinding ? nil : KeyPair(identifier: UUID(), algorithm: invalid ? "POKE" : "ES512", privateKey: SecKeyTestsHelper.createPrivateKey())

      return FetchCredentialContext(
        format: format,
        selectedCredential: mockCredentialsSupported,
        credentialOffers: ["credential-offer"],
        credentialIssuer: "credential-issuer",
        keyPair: keyPair,
        accessToken: AccessToken(cNonce: "cNonce", accessToken: "access-token"),
        credentialEndpoint: mockEndpointsUrl)
    }
  }
}
#endif
