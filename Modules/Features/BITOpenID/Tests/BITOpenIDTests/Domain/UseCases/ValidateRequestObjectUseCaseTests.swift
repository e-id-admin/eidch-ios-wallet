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
    let mockRequestObject = RequestObject.Mock.VcSdJwt.sample

    let result = await useCase.execute(mockRequestObject)

    XCTAssertTrue(result)
  }

  func testValidationWithUnsupportedResponseType() async {
    let mockRequestObject = RequestObject.Mock.VcSdJwt.unsupportedResponseTypeSample

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithUnsupportedResponseMode() async {
    let mockRequestObject = RequestObject.Mock.VcSdJwt.unsupportedResponseModeSample

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithUnsupportedClientIdScheme() async {
    let mockRequestObject = RequestObject.Mock.VcSdJwt.sampleWithUnsupportedClientIdScheme

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithClientIdButNoClientIdScheme() async {
    let mockRequestObject = RequestObject.Mock.VcSdJwt.sampleWithClientIdAndWithoutClientIdScheme

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithUnsupportedClientId() async {
    let mockRequestObject = RequestObject.Mock.VcSdJwt.sampleWithUnsupportedClientId

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationWithoutAnyConstraintsFields() async {
    let mockRequestObject = RequestObject.Mock.VcSdJwt.sampleWithoutAnyConstraintsFields

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  // MARK: - JWT Request Object

  func testValidationJwtRequestObjectSuccess() async {
    let mockRequestObject = JWTRequestObject.Mock.sample
    jwtSignatureValidator.validateDidKidReturnValue = true

    let result = await useCase.execute(mockRequestObject)

    XCTAssertTrue(result)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt, mockRequestObject.jwt)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockRequestObject.jwt.kid)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockRequestObject.clientId)
  }

  func testValidationJwtRequestObjectWrongAlgorithm() async {
    let mockRequestObject = JWTRequestObject.Mock.sampleWithUnsupportedAlgorithm

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationJwtRequestObjectWithoutKid() async {
    let mockRequestObject = JWTRequestObject.Mock.sampleWithoutKid

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
  }

  func testValidationJwtRequestObjectFailure() async {
    let mockRequestObject = JWTRequestObject.Mock.sample
    jwtSignatureValidator.validateDidKidThrowableError = TestingError.error

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt, mockRequestObject.jwt)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockRequestObject.jwt.kid)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockRequestObject.clientId)
  }

  func testValidationJwtRequestObjectInvalidSignature() async {
    let mockRequestObject = JWTRequestObject.Mock.sample
    jwtSignatureValidator.validateDidKidReturnValue = false

    let result = await useCase.execute(mockRequestObject)

    XCTAssertFalse(result)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.jwt, mockRequestObject.jwt)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.kid, mockRequestObject.jwt.kid)
    XCTAssertEqual(jwtSignatureValidator.validateDidKidReceivedArguments?.did, mockRequestObject.clientId)
  }

  // MARK: Private

  private var jwtSignatureValidator = JWTSignatureValidatorProtocolSpy()
  private var useCase = ValidateRequestObjectUseCase()
}
