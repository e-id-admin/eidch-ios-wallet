import XCTest
@testable import BITAnyCredentialFormatMocks
@testable import BITJWT
@testable import BITLocalAuthentication
@testable import BITOpenID
@testable import BITTestingCore
@testable import BITVault

final class JWTContextHelperTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    jwtHelper = JWTHelperProtocolSpy()
    jwtContextHelper = JWTContextHelper(jwtHelper: jwtHelper)
  }

  func testJWT_WithValidContext_ShouldReturnJWT() throws {
    let context = FetchCredentialContext.Mock.sample
    jwtHelper.jwtWithKeyPairTypeReturnValue = .Mock.sample
    // swiftlint:disable all
    let keyPair = context.keyPair!
    // swiftlint:enable all

    let jwt = try jwtContextHelper.jwt(using: context, keyPair: keyPair, type: "testType")

    XCTAssertNotNil(jwt.raw)

    guard let actualPayload = jwtHelper.jwtWithKeyPairTypeReceivedArguments?.payload else {
      XCTFail("no payload in the jwt")
      return
    }
    let jwtPayload = try JSONDecoder().decode(JWTPayload.self, from: actualPayload)
    XCTAssertEqual(context.credentialIssuer, jwtPayload.audience)
    XCTAssertEqual(context.accessToken.cNonce, jwtPayload.nonce)
    XCTAssertEqual(UInt64(context.createdAt.timeIntervalSince1970), jwtPayload.issuedAt)
  }

  // MARK: Private

  // swiftlint: disable all
  private var jwtContextHelper: JWTContextHelper!
  private var jwtHelper: JWTHelperProtocolSpy!
  // swiftlint: enable all
}
