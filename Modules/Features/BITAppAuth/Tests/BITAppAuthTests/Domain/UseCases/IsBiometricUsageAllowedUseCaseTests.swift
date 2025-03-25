import Factory
import Foundation
import XCTest
@testable import BITAppAuth

final class IsBiometricUsageAllowedUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    mockBiometricRepository = BiometricRepositoryProtocolSpy()
    Container.shared.biometricRepository.register { self.mockBiometricRepository }
    useCase = IsBiometricUsageAllowedUseCase()
  }

  func testHappyPath() {
    mockBiometricRepository.isBiometricUsageAllowedClosure = { true }

    let result = useCase.execute()
    XCTAssertTrue(result)
    XCTAssertTrue(mockBiometricRepository.isBiometricUsageAllowedCalled)
    XCTAssertEqual(1, mockBiometricRepository.isBiometricUsageAllowedCallsCount)
  }

  func testNotAllowedPath() {
    mockBiometricRepository.isBiometricUsageAllowedReturnValue = false

    let result = useCase.execute()
    XCTAssertFalse(result)
    XCTAssertTrue(mockBiometricRepository.isBiometricUsageAllowedCalled)
    XCTAssertEqual(1, mockBiometricRepository.isBiometricUsageAllowedCallsCount)
  }

  func testFailurePath() {
    mockBiometricRepository.allowBiometricUsageClosure = { _ in }
    mockBiometricRepository.isBiometricUsageAllowedThrowableError = AuthError.biometricNotAvailable

    let result = useCase.execute()
    XCTAssertFalse(result)
    XCTAssertTrue(mockBiometricRepository.isBiometricUsageAllowedCalled)
    XCTAssertEqual(1, mockBiometricRepository.isBiometricUsageAllowedCallsCount)
  }

  // MARK: Private

  private var mockBiometricRepository = BiometricRepositoryProtocolSpy()
  private lazy var useCase = IsBiometricUsageAllowedUseCase()

}
