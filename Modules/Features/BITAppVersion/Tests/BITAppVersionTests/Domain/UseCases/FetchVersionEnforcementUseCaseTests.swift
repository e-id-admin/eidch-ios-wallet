import XCTest
@testable import BITAppVersion

final class FetchVersionEnforcementUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = VersionEnforcementRepositoryProtocolSpy()
    appVersionUseCase = GetAppVersionUseCaseProtocolSpy()

    useCase = FetchVersionEnforcementUseCase(repository: repository, getAppVersionUseCase: appVersionUseCase)
  }

  func testGetVersionEnforcement_success() async throws {
    repository.fetchVersionEnforcementsReturnValue = [
      .Mock.sample,
    ]

    appVersionUseCase.executeReturnValue = mockAppVersion

    let versionEnforcement = try await useCase.execute(withTimeout: mockTimeout)

    XCTAssertNil(versionEnforcement)
    XCTAssertTrue(repository.fetchVersionEnforcementsCalled)
    XCTAssertTrue(appVersionUseCase.executeCalled)
  }

  func testGetVersionEnforcement_versionTooLow() async throws {
    repository.fetchVersionEnforcementsReturnValue = [
      .Mock.highMinVersionSample,
    ]

    appVersionUseCase.executeReturnValue = mockAppVersion

    let versionEnforcement = try await useCase.execute(withTimeout: mockTimeout)

    XCTAssertNil(versionEnforcement)
    XCTAssertTrue(repository.fetchVersionEnforcementsCalled)
    XCTAssertTrue(appVersionUseCase.executeCalled)
  }

  func testGetVersionEnforcement_versionTooHigh() async throws {
    repository.fetchVersionEnforcementsReturnValue = [
      .Mock.noMinVersionSample,
    ]

    appVersionUseCase.executeReturnValue = mockAppVersion

    let versionEnforcement = try await useCase.execute(withTimeout: mockTimeout)

    XCTAssertNotNil(versionEnforcement)
    XCTAssertTrue(repository.fetchVersionEnforcementsCalled)
    XCTAssertTrue(appVersionUseCase.executeCalled)
  }

  func testGetVersionEnforcement_wrongPriority() async throws {
    repository.fetchVersionEnforcementsReturnValue = [
      .Mock.lowPrioritySample,
    ]

    appVersionUseCase.executeReturnValue = mockAppVersion

    do {
      _ = try await useCase.execute(withTimeout: mockTimeout)
      XCTFail("High platform should be supported")
    } catch FetchVersionEnforcementUseCase.FetchVersionEnforcementUseCaseError.noValidVersionEnforcement {
      XCTAssertTrue(repository.fetchVersionEnforcementsCalled)
      XCTAssertFalse(appVersionUseCase.executeCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testGetVersionEnforcement_wrongPlatform() async throws {
    repository.fetchVersionEnforcementsReturnValue = [
      .Mock.otherPlatformSample,
    ]

    appVersionUseCase.executeReturnValue = mockAppVersion

    do {
      _ = try await useCase.execute(withTimeout: mockTimeout)
      XCTFail("iOS platform should be supported")
    } catch FetchVersionEnforcementUseCase.FetchVersionEnforcementUseCaseError.noValidVersionEnforcement {
      XCTAssertTrue(repository.fetchVersionEnforcementsCalled)
      XCTAssertFalse(appVersionUseCase.executeCalled)
    } catch {
      XCTFail("Unexpected error")
    }
  }

  func testGetVersionEnforcement_timeout() async throws {
    repository.fetchVersionEnforcementsClosure = {
      try? await Task.sleep(nanoseconds: self.mockTimeout)

      return [.Mock.sample]
    }

    appVersionUseCase.executeReturnValue = mockAppVersion

    do {
      _ = try await useCase.execute(withTimeout: 500_000_000)
      XCTFail("Timeout issue should occured")
    } catch is CancellationError {
      XCTAssertTrue(repository.fetchVersionEnforcementsCalled)
      XCTAssertTrue(appVersionUseCase.executeCalled)
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var repository: VersionEnforcementRepositoryProtocolSpy!
  private var useCase: FetchVersionEnforcementUseCase!
  private var appVersionUseCase: GetAppVersionUseCaseProtocolSpy!
  private let mockAppVersion = AppVersion("1.0.0")
  private let mockTimeout: UInt64 = 1_000_000_000
  // swiftlint:enable all
}
