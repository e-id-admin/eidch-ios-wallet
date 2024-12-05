import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCrypto
@testable import BITTestingCore

final class SaltServiceTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spySaltRepository = SaltRepositoryProtocolSpy()
    saltService = SaltService(appPinSaltLength: Self.saltLength, saltRepository: spySaltRepository)
  }

  func testGenerateSalt() throws {
    spySaltRepository.setPinSaltClosure = { _ in }
    let salt = try saltService.generateSalt()
    XCTAssertEqual(salt.count, Self.saltLength)
    XCTAssertTrue(spySaltRepository.setPinSaltCalled)
  }

  // MARK: Private

  private static let saltLength = 64

  // swiftlint:disable all
  private var spySaltRepository: SaltRepositoryProtocolSpy!
  private var saltService: SaltService!
  // swiftlint:enable all
}
