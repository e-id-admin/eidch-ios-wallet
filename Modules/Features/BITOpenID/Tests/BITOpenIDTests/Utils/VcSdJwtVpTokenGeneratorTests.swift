import Spyable
import XCTest

@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCrypto
@testable import BITJWT
@testable import BITLocalAuthentication
@testable import BITOpenID
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore
@testable import BITVault

final class VcSdJwtVpTokenGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    jwtHelper = JWTHelperProtocolSpy()
    sha2656Hasher = HashableSpy()
    mockKeyPair = KeyPair(identifier: mockIdentifier, algorithm: mockAlgorithm, privateKey: mockPrivateKey)

    jwtHelper.jwtWithKeyPairTypeReturnValue = mockKeyBindingJwt
    sha2656Hasher.hashReturnValue = Data()

    generator = VcSdJwtVpTokenGenerator(sha256Hasher: sha2656Hasher, jwtHelper: jwtHelper)
  }

  func testGenerate_oneClaimRequested() throws {
    let requestedClaims = [ "firstName" ]

    let vpToken = try generator.generate(requestObject: .Mock.VcSdJwt.sample, credential: mockCredential, keyPair: mockKeyPair, fields: requestedClaims)

    asserts(vpToken, nbOfDisclosures: 1, hasKeyBinding: true)
  }

  func testGenerate_severalClaimsRequested() throws {
    let requestedClaims: [String] = ["firstName", "lastName"]

    let vpToken = try generator.generate(requestObject: .Mock.VcSdJwt.sample, credential: mockCredential, keyPair: mockKeyPair, fields: requestedClaims)

    asserts(vpToken, nbOfDisclosures: 2, hasKeyBinding: true)
  }

  func testGenerate_noClaimsRequested() throws {
    let requestedClaims: [String] = []

    let vpToken = try generator.generate(requestObject: .Mock.VcSdJwt.sample, credential: mockCredential, keyPair: mockKeyPair, fields: requestedClaims)

    asserts(vpToken, nbOfDisclosures: 0, hasKeyBinding: true)
  }

  func testGenerate_noKeyBinding() throws {
    let mockCredentialNoKeyBinding = VcSdJwt.Mock.sampleNoKeyBinding
    let requestedClaims = [ "firstName" ]

    let vpToken = try generator.generate(requestObject: .Mock.VcSdJwt.sample, credential: mockCredentialNoKeyBinding, keyPair: nil, fields: requestedClaims)

    asserts(vpToken, nbOfDisclosures: 1, hasKeyBinding: false)
  }

  func testGenerate_missingClaim() throws {
    let requestedClaims: [String] = [
      "firstName",
      "special-claim",
    ]

    do {
      _ = try generator.generate(requestObject: .Mock.VcSdJwt.sample, credential: mockCredential, keyPair: mockKeyPair, fields: requestedClaims)
    } catch {
      XCTAssertFalse(jwtHelper.jwtWithKeyPairTypeCalled)
      XCTAssertFalse(sha2656Hasher.hashCalled)
    }
  }

  // MARK: Private

  private let mockPrivateKey: SecKey = SecKeyTestsHelper.createPrivateKey()
  private let mockIdentifier = UUID()
  private let mockAlgorithm: String = "ES256"
  private let mockKeyBindingJwt: JWT = .Mock.sampleKeyBinding
  private let mockReason = "mockReason"

  // swiftlint:disable all
  private var jwtHelper: JWTHelperProtocolSpy!
  private var generator: VcSdJwtVpTokenGenerator!
  private var sha2656Hasher = HashableSpy()
  private var mockCredential: VcSdJwt = .Mock.sample
  private var mockKeyPair: KeyPair!

  private func asserts(_ vpToken: VpToken, nbOfDisclosures: Int, hasKeyBinding: Bool) {
    XCTAssertFalse(vpToken.isEmpty)
    let disclosures = vpToken.split(separator: "~")
    if hasKeyBinding {
      XCTAssertEqual(2 + nbOfDisclosures, disclosures.count)
      XCTAssertTrue(sha2656Hasher.hashCalled)
      XCTAssertEqual(jwtHelper.jwtWithKeyPairTypeReceivedArguments?.keyPair.privateKey, mockPrivateKey)
      XCTAssertEqual(mockKeyBindingJwt.raw, String(disclosures.last ?? ""))
    } else {
      XCTAssertEqual(1 + nbOfDisclosures, disclosures.count)
      XCTAssertFalse(sha2656Hasher.hashCalled)
      XCTAssertFalse(jwtHelper.jwtWithKeyPairTypeCalled)
    }
  }

}
