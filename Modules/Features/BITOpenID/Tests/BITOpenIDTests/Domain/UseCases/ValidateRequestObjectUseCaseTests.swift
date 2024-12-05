import Factory
import XCTest

@testable import BITJWT
@testable import BITOpenID
@testable import BITTestingCore

final class ValidateRequestObjectUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    Container.shared.jwtSignatureValidator.register { self.jwtSignatureValidator }

    useCase = ValidateRequestObjectUseCase()
  }

  // MARK: - JSON Request Object

  func testValidationSuccess() async {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sample

    let result = await useCase.execute(mockRequestObject)

    XCTAssertTrue(result)
  }

  func testValidationWithUnsupportedResponseType() async {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.unsupportedResponseTypeSample

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithUnsupportedResponseMode() async {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.unsupportedResponseModeSample

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithUnsupportedClientIdScheme() async {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sampleWithUnsupportedClientIdScheme

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithClientIdButNoClientIdScheme() async {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sampleWithClientIdAndWithoutClientIdScheme

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithUnsupportedClientId() async {
    let mockRequestObject: RequestObject = .Mock.VcSdJwt.sampleWithUnsupportedClientId

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  // MARK: - JWT Request Object

  func testValidationJwtRequestObjectSuccess() async {
    let mockRequestObject: JWTRequestObject = .Mock.sample
    jwtSignatureValidator.validateFromReturnValue = true

    let result = await useCase.execute(mockRequestObject)

    XCTAssertTrue(result)
    XCTAssertEqual(jwtSignatureValidator.validateFromReceivedArguments?.did, mockRequestObject.jwt.kid?.components(separatedBy: "#").first)
  }

  func testValidationJwtRequestObjectWrongAlgorithm() async {
    let mockRequestObject: JWTRequestObject = .Mock.sampleWithUnsupportedAlgorithm

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationJwtRequestObjectWithoutKid() async {
    let mockRequestObject: JWTRequestObject = .Mock.sampleWithoutKid

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationJwtRequestObjectFailure() async {
    let mockRequestObject: JWTRequestObject = .Mock.sample
    jwtSignatureValidator.validateFromThrowableError = TestingError.error

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
    XCTAssertTrue(jwtSignatureValidator.validateFromCalled)
  }

  func testValidationJwtRequestObjectInvalidSignature() async {
    let mockRequestObject: JWTRequestObject = .Mock.sample
    jwtSignatureValidator.validateFromReturnValue = false

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
    XCTAssertEqual(jwtSignatureValidator.validateFromReceivedArguments?.jwt, mockRequestObject.jwt)
  }

  // MARK: Private

  private var jwtSignatureValidator = JWTSignatureValidatorProtocolSpy()
  private var useCase = ValidateRequestObjectUseCase()
}
