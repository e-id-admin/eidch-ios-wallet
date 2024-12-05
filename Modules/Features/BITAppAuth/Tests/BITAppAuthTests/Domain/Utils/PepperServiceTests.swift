import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCrypto
@testable import BITTestingCore

final class PepperServiceTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyPepperRepository = PepperRepositoryProtocolSpy()
    pepperService = PepperService(pepperKeyInitialVectorLength: Self.vectorLength, pepperRepository: spyPepperRepository)
  }

  func testGeneratePepper() throws {
    let mockSecKey: SecKey = SecKeyTestsHelper.createPrivateKey()
    spyPepperRepository.createPepperKeyReturnValue = mockSecKey

    let secKey = try pepperService.generatePepper()
    XCTAssertEqual(mockSecKey, secKey)
    XCTAssertTrue(spyPepperRepository.setPepperInitialVectorCalled)
    XCTAssertTrue(spyPepperRepository.createPepperKeyCalled)

    guard let initialVector = spyPepperRepository.setPepperInitialVectorReceivedInitialVector else {
      XCTFail("No initialVector received in the repo call")
      return
    }
    XCTAssertEqual(Self.vectorLength, initialVector.count)
  }

  // MARK: Private

  private static let vectorLength = 12

  // swiftlint:disable all
  private var spyPepperRepository: PepperRepositoryProtocolSpy!
  private var pepperService: PepperServiceProtocol!
  // swiftlint:enable all

}
