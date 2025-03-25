import BITJWT
import Foundation
import XCTest
@testable import BITSdJWT
@testable import BITSdJWTMocks
@testable import BITTestingCore

final class VcSdJwtTests: XCTestCase {

  func testDecodeSample() throws {
    let rawString = VcSdJwt.Mock.sampleRaw

    guard let vcSdJwt = try? VcSdJwt(from: rawString) else {
      XCTFail("init from rawCredential failed")
      return
    }

    XCTAssertFalse(vcSdJwt.raw.isEmpty)
    XCTAssertFalse(vcSdJwt.digests.isEmpty)
    XCTAssertEqual(16, vcSdJwt.disclosableClaims.count)
    XCTAssertEqual(16, vcSdJwt.digests.count)
    XCTAssertNotNil(vcSdJwt.issuedAt)
    XCTAssertNotNil(vcSdJwt.expiredAt)
    XCTAssertNotNil(vcSdJwt.activatedAt)
    XCTAssertNotNil(vcSdJwt.iss)
    XCTAssertTrue((vcSdJwt.iss?.isEmpty) == false)
    XCTAssertNotNil(vcSdJwt.vcIssuer)
    XCTAssertFalse(vcSdJwt.vcIssuer.isEmpty)

    // swiftlint:disable all
    XCTAssertTrue(vcSdJwt.issuedAt! < vcSdJwt.expiredAt!)
    XCTAssertTrue(Date() < vcSdJwt.expiredAt!)

    XCTAssertTrue(vcSdJwt.activatedAt! < vcSdJwt.expiredAt!)
    XCTAssertTrue(Date() < vcSdJwt.expiredAt!)
    // swiftlint:enable all

    XCTAssertNotNil(vcSdJwt.keyBinding)
    XCTAssertNotNil(vcSdJwt.vct)
    XCTAssertNotNil(vcSdJwt.vctIntegrity)
    XCTAssertNotNil(vcSdJwt.statusList)
  }

  func testDecodeFullSample() throws {
    let vcSdJwt = VcSdJwt.Mock.fullSample

    XCTAssertFalse(vcSdJwt.raw.isEmpty)

    XCTAssertNotNil(vcSdJwt.iss)
    XCTAssertNotNil(vcSdJwt.vcIssuer)
    XCTAssertNotNil(vcSdJwt.subject)
    XCTAssertNotNil(vcSdJwt.audience)
    XCTAssertNotNil(vcSdJwt.expiredAt)
    XCTAssertNotNil(vcSdJwt.issuedAt)
    XCTAssertNotNil(vcSdJwt.activatedAt)

    XCTAssertFalse(vcSdJwt.digests.isEmpty)
    XCTAssertEqual(16, vcSdJwt.disclosableClaims.count)
    XCTAssertEqual(16, vcSdJwt.digests.count)

    XCTAssertNotNil(vcSdJwt.keyBinding)
    XCTAssertNotNil(vcSdJwt.vct)
    XCTAssertNotNil(vcSdJwt.statusList)
  }

  func testDecode_NoKeyBinding_ReturnsNil() throws {
    let vcSdJwt = VcSdJwt.Mock.sampleNoKeyBinding

    XCTAssertNil(vcSdJwt.keyBinding)
  }

  func testDecode_NoVct_ReturnsNil() throws {
    let vcSdJwt = VcSdJwt.Mock.sampleNoVct

    XCTAssertNil(vcSdJwt.vct)
  }

  func testDecode_NoStatus_ReturnsNil() throws {
    let vcSdJwt = VcSdJwt.Mock.sampleNoStatus

    XCTAssertNil(vcSdJwt.statusList)
  }

  func testDecode_NoIssuer_ShouldThrow() throws {
    let rawString = VcSdJwt.Mock.sampleNoIssuer

    XCTAssertThrowsError(try VcSdJwt(from: rawString)) { error in
      XCTAssertEqual(error as? VcSdJwtError, .keyNotFound("iss"))
    }
  }

  func testDecode_NonDisclosableClaims_ShouldThrow() throws {
    let rawString = VcSdJwt.Mock.sampleNonDisclosableClaims

    XCTAssertThrowsError(try VcSdJwt(from: rawString)) { error in
      XCTAssertEqual(error as? VcSdJwtError, .nonDisclosableClaimFound)
    }
  }

}
