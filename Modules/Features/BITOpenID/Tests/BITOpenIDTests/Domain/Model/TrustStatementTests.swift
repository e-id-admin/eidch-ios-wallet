import XCTest
@testable import BITOpenID
@testable import BITTestingCore

final class TrustStatementTests: XCTestCase {

  func testInit_success() {
    let rawSdJwt = TrustStatement.Mock.sdJwtSample

    XCTAssertNoThrow(try TrustStatement(from: rawSdJwt))
  }

  func testInit_incorrectHeaderType() {
    let rawSdJwt = TrustStatement.Mock.noTypeSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("typ"))
    }
  }

  func testInit_incorrectHeaderAlgorithm() {
    let rawSdJwt = TrustStatement.Mock.incorrectAlgorithmSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("alg"))
    }
  }

  func testInit_subMissing() {
    let rawSdJwt = TrustStatement.Mock.noSubSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("sub"))
    }
  }

  func testInit_vctMissing() {
    let rawSdJwt = TrustStatement.Mock.noVctSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("vct"))
    }
  }

  func testInit_iatMissing() {
    let rawSdJwt = TrustStatement.Mock.noIssuingDateSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("iat"))
    }
  }

  func testInit_nbfMissing() {
    let rawSdJwt = TrustStatement.Mock.noActivationDateSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("nbf"))
    }
  }

  func testInit_expMissing() {
    let rawSdJwt = TrustStatement.Mock.noExpirationDateSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("exp"))
    }
  }

  func testInit_statusMissing() {
    let rawSdJwt = TrustStatement.Mock.noStatusSample

    XCTAssertThrowsError(try TrustStatement(from: rawSdJwt)) { error in
      XCTAssertEqual(error as? TrustStatementError, .keyNotFound("status"))
    }
  }
}
