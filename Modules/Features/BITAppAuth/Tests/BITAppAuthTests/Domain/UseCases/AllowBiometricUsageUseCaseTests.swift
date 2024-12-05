import Foundation
import Spyable
import XCTest
@testable import BITAppAuth

final class AllowBiometricUsageUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    mockBiometricRepository = BiometricRepositoryProtocolSpy()
    useCase = AllowBiometricUsageUseCase(repository: mockBiometricRepository)
  }

  func testHappyPath() throws {
    mockBiometricRepository.allowBiometricUsageClosure = { _ in }
    mockBiometricRepository.isBiometricUsageAllowedClosure = { false }

    try useCase.execute(allow: true)
    XCTAssertTrue(mockBiometricRepository.allowBiometricUsageCalled)
    XCTAssertFalse(mockBiometricRepository.isBiometricUsageAllowedCalled)
    XCTAssertEqual(1, mockBiometricRepository.allowBiometricUsageCallsCount)
    XCTAssertEqual(0, mockBiometricRepository.isBiometricUsageAllowedCallsCount)
  }

  func testFailurePath() throws {
    mockBiometricRepository.allowBiometricUsageThrowableError = AuthError.biometricNotAvailable
    useCase = AllowBiometricUsageUseCase(repository: mockBiometricRepository)

    do {
      try useCase.execute(allow: true)
      XCTFail("Should fail instead...")
    } catch {
      XCTAssertTrue(mockBiometricRepository.allowBiometricUsageCalled)
      XCTAssertFalse(mockBiometricRepository.isBiometricUsageAllowedCalled)
      XCTAssertEqual(1, mockBiometricRepository.allowBiometricUsageCallsCount)
      XCTAssertEqual(0, mockBiometricRepository.isBiometricUsageAllowedCallsCount)
    }
  }

  // MARK: Private

  private var mockBiometricRepository = BiometricRepositoryProtocolSpy()
  private lazy var useCase = AllowBiometricUsageUseCase()

}
