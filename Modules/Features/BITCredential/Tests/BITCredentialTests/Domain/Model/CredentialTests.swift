import BITCore
import Factory
import XCTest
@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCredentialShared
@testable import BITCrypto
@testable import BITJWT
@testable import BITOpenID
@testable import BITTestingCore

// MARK: - CredentialTests

final class CredentialTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    Container.shared.preferredUserLocales.reset()

    mockKeyPair = KeyPair(identifier: mockKeyIdentifier, algorithm: mockKeyAlgorithm, privateKey: mockPrivateKey)
  }

  func testInitFromAnyCredential_happyPath() throws {
    let mockAnyCredential = AnyCredentialSpy()
    mockAnyCredential.format = "some-format"
    mockAnyCredential.issuer = mockDemoIssuerDid
    let mockCredentialWithKeyBinding = CredentialWithKeyBinding(anyCredential: mockAnyCredential, boundTo: mockKeyPair)

    let mockAnyClaim = AnyClaimSpy()
    mockAnyClaim.key = "firstName"
    mockAnyClaim.value = .string("John")
    mockAnyCredential.claims = [
      mockAnyClaim,
    ]

    let mockCredential = Credential.Mock.sample
    let mockMetadataWrapper = CredentialMetadataWrapper.Mock.sample

    guard let rawCredential = String(data: mockCredential.payload, encoding: .utf8) else {
      XCTFail("Can not decode raw credential")
      return
    }

    mockAnyCredential.raw = rawCredential

    let credential = try Credential(credentialWithKeyBinding: mockCredentialWithKeyBinding, metadataWrapper: mockMetadataWrapper)

    XCTAssertEqual(mockCredential.payload, credential.payload)
    XCTAssertEqual(mockCredentialWithKeyBinding.keyPair?.algorithm, credential.keyBindingAlgorithm)
    XCTAssertEqual(mockCredentialWithKeyBinding.keyPair?.identifier, credential.keyBindingIdentifier)
    XCTAssertEqual(mockAnyCredential.format, credential.format)
    XCTAssertEqual(1, credential.claims.count)

    XCTAssertEqual(mockAnyClaim.key, credential.claims.first?.key)
    XCTAssertEqual(mockAnyClaim.value?.rawValue, credential.claims.first?.value)
    XCTAssertEqual(credential.id, credential.claims.first?.credentialId)

    XCTAssertEqual(credential.environment, .demo)
  }

  func testInitFromAnyCredential_NotDemoCredential() throws {
    let mockAnyCredential = AnyCredentialSpy()
    mockAnyCredential.format = "some-format"
    mockAnyCredential.issuer = mockIssuerDid
    let mockCredentialWithKeyBinding = CredentialWithKeyBinding(anyCredential: mockAnyCredential, boundTo: mockKeyPair)

    let mockAnyClaim = AnyClaimSpy()
    mockAnyClaim.key = "firstName"
    mockAnyClaim.value = .string("John")
    mockAnyCredential.claims = [
      mockAnyClaim,
    ]

    let mockCredential = Credential.Mock.sample
    let mockMetadataWrapper = CredentialMetadataWrapper.Mock.sample

    guard let rawCredential = String(data: mockCredential.payload, encoding: .utf8) else {
      XCTFail("Can not decode raw credential")
      return
    }

    mockAnyCredential.raw = rawCredential

    let credential = try Credential(credentialWithKeyBinding: mockCredentialWithKeyBinding, metadataWrapper: mockMetadataWrapper)

    XCTAssertEqual(mockCredential.payload, credential.payload)
    XCTAssertEqual(mockCredentialWithKeyBinding.keyPair?.algorithm, credential.keyBindingAlgorithm)
    XCTAssertEqual(mockCredentialWithKeyBinding.keyPair?.identifier, credential.keyBindingIdentifier)
    XCTAssertEqual(mockAnyCredential.format, credential.format)
    XCTAssertEqual(1, credential.claims.count)

    XCTAssertEqual(mockAnyClaim.key, credential.claims.first?.key)
    XCTAssertEqual(mockAnyClaim.value?.rawValue, credential.claims.first?.value)
    XCTAssertEqual(credential.id, credential.claims.first?.credentialId)

    XCTAssertEqual(credential.environment, .none)
  }

  func testInitFromAnyCredential_NoKeyBinding() throws {
    let mockAnyCredential = AnyCredentialSpy()
    mockAnyCredential.format = "some-format"
    mockAnyCredential.issuer = mockIssuerDid
    let mockCredentialWithKeyBinding = CredentialWithKeyBinding(anyCredential: mockAnyCredential, boundTo: nil)

    let mockAnyClaim = AnyClaimSpy()
    mockAnyClaim.key = "firstName"
    mockAnyClaim.value = .string("John")
    mockAnyCredential.claims = [
      mockAnyClaim,
    ]

    let mockCredential = Credential.Mock.sample
    let mockMetadataWrapper = CredentialMetadataWrapper.Mock.sample

    guard let rawCredential = String(data: mockCredential.payload, encoding: .utf8) else {
      XCTFail("Can not decode raw credential")
      return
    }

    mockAnyCredential.raw = rawCredential

    let credential = try Credential(credentialWithKeyBinding: mockCredentialWithKeyBinding, metadataWrapper: mockMetadataWrapper)

    XCTAssertEqual(mockCredential.payload, credential.payload)
    XCTAssertNil(credential.keyBindingAlgorithm)
    XCTAssertNil(credential.keyBindingIdentifier)
    XCTAssertEqual(mockAnyCredential.format, credential.format)
    XCTAssertEqual(1, credential.claims.count)

    XCTAssertEqual(mockAnyClaim.key, credential.claims.first?.key)
    XCTAssertEqual(mockAnyClaim.value?.rawValue, credential.claims.first?.value)
    XCTAssertEqual(credential.id, credential.claims.first?.credentialId)

    XCTAssertEqual(credential.environment, .none)
  }

  func testInitFromAnyCredential_unknownClaim() throws {
    let mockCredential = Credential.Mock.sample

    guard let rawCredential = String(data: mockCredential.payload, encoding: .utf8) else {
      XCTFail("Can not decode raw credential")
      return
    }
    let mockMetadataWrapper = CredentialMetadataWrapper.Mock.sample
    let mockAnyCredential = AnyCredentialSpy()
    mockAnyCredential.format = "some-format"
    mockAnyCredential.raw = rawCredential
    let mockAnyClaim = AnyClaimSpy()
    mockAnyClaim.key = "unknown-claim"
    mockAnyClaim.value = .string("John")
    mockAnyCredential.claims = [
      mockAnyClaim,
    ]
    let mockCredentialWithKeyBinding = CredentialWithKeyBinding(anyCredential: mockAnyCredential, boundTo: nil)

    do {
      _ = try Credential(credentialWithKeyBinding: mockCredentialWithKeyBinding, metadataWrapper: mockMetadataWrapper)
      XCTFail("Should fail instead...")
    } catch CredentialClaimError.invalidCredentialClaim {
      /* expected error ✅ */
    } catch {
      XCTFail("Not the expected error")
    }
  }

  func testFindDisplay_additionalDisplays_notAvailable() {
    let unmanagedCode = "cz"
    Container.shared.preferredUserLocales.register { [unmanagedCode] }
    let credential = Credential.Mock.otherSampleDisplaysAdditional
    let expectedLanguageCode = "en"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_appDefaultDisplays() {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential = Credential.Mock.sampleDisplaysAppDefault
    let expectedLanguageCode = "en"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_fallbackDisplays() {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential = Credential.Mock.sampleDisplaysFallback
    let expectedLanguageCode = "en"

    assertDisplays(credential: credential, expectedLanguageCode: expectedLanguageCode)
  }

  func testFindDisplay_unsupportedDisplays() {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential = Credential.Mock.sampleDisplaysUnsupported

    let display = credential.preferredDisplay
    XCTAssertNotNil(display)
    for claim in credential.claims {
      let claimDisplay = claim.preferredDisplay
      XCTAssertNotNil(claimDisplay)
    }
  }

  func testFindDisplay_emptyDisplays() {
    Container.shared.preferredUserLocales.register { [UserLocale.LocaleIdentifier.swissItalian.rawValue] }
    let credential = Credential.Mock.sampleDisplaysEmpty

    let display = credential.preferredDisplay
    XCTAssertNil(display)
    for claim in credential.claims {
      let claimDisplay = claim.preferredDisplay
      XCTAssertEqual(claimDisplay?.name, claim.key)
    }
  }

  // MARK: Private

  private let mockIssuerDid = "did:tdw:mock=:identifier-reg.trust-infra.swiyu.admin.ch:api:v1:did:123"
  private let mockDemoIssuerDid = "did:tdw:mock=:identifier-reg.trust-infra.swiyu-int.admin.ch:api:v1:did:123"
  private let mockKeyIdentifier = UUID()
  private let mockKeyAlgorithm = "keyAlgorithm"
  private let mockPrivateKey: SecKey = SecKeyTestsHelper.createPrivateKey()
  // swiftlint:disable all
  private var mockKeyPair: KeyPair!

  // swiftlint:enable all

  private func assertDisplays(credential: Credential, expectedLanguageCode: UserLanguageCode) {
    let display = credential.preferredDisplay
    XCTAssertNotNil(display)
    guard let display else { fatalError("display is nil") }
    XCTAssertTrue(display.locale?.starts(with: "\(expectedLanguageCode)-") ?? false)
    XCTAssertEqual(credential.id, display.credentialId)
    for claim in credential.claims {
      let claimDisplay = claim.preferredDisplay
      XCTAssertNotNil(claimDisplay)
      XCTAssertEqual(claim.id, claimDisplay?.claimId)
      guard let claimDisplay else { fatalError("claim display is nil") }
      XCTAssertTrue(claimDisplay.locale?.starts(with: "\(expectedLanguageCode)-") ?? false)
    }
  }

}
