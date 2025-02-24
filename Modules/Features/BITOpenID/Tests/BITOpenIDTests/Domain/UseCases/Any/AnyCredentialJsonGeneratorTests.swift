import Factory
import Spyable
import XCTest
@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCore
@testable import BITOpenID

final class AnyCredentialJsonGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    anyCredentialJsonGeneratorProtocolSpy = AnyCredentialJsonGeneratorProtocolSpy()

    Container.shared.anyCredentialJsonGeneratorDispatcher.register { [.vcSdJwt: self.anyCredentialJsonGeneratorProtocolSpy] }

    generator = AnyCredentialJsonGenerator()
  }

  func testExecuteVcSdJwtUseCase() throws {
    let anyCredential: AnyCredential = MockAnyCredential()
    anyCredentialJsonGeneratorProtocolSpy.generateForReturnValue = Self.mockJson

    let json = try generator.generate(for: anyCredential)

    XCTAssertEqual(anyCredentialJsonGeneratorProtocolSpy.generateForReceivedAnyCredential?.raw, anyCredential.raw)
    XCTAssertEqual(json, Self.mockJson)
  }

  func testExecuteUnsupportedFormat() throws {
    let anycredential: AnyCredential = OtherMockAnyCredential()
    anyCredentialJsonGeneratorProtocolSpy.generateForReturnValue = Self.mockJson

    XCTAssertThrowsError(try generator.generate(for: anycredential)) { error in
      XCTAssertEqual(error as? CredentialFormatError, .formatNotSupported)
    }
  }

  // MARK: Private

  private static let mockJson = "json"

  // swiftlint:disable all
  private var generator: AnyCredentialJsonGenerator!
  private var anyCredentialJsonGeneratorProtocolSpy: AnyCredentialJsonGeneratorProtocolSpy!
  // swiftlint:enable all
}
