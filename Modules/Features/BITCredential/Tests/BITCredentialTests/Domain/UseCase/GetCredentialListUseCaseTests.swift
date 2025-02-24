import Factory
import XCTest
@testable import BITCredential
@testable import BITCredentialShared
@testable import BITTestingCore

final class GetCredentialListUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    Container.shared.databaseCredentialRepository.register { self.repository }

    useCase = GetCredentialListUseCase()
  }

  func testExecuteSucces() async throws {
    repository.getAllReturnValue = mockCredentials

    let credentials = try await useCase.execute()

    XCTAssertEqual(credentials.count, mockCredentials.count)
    XCTAssertTrue(repository.getAllCalled)
  }

  func testExecuteWithRepositoryError() async throws {
    repository.getAllThrowableError = TestingError.error

    do {
      _ = try await useCase.execute()
    } catch {
      XCTAssertTrue(repository.getAllCalled)
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: GetCredentialListUseCase!
  private var mockCredentials: [Credential] = [.Mock.sample, .Mock.sampleDisplaysAdditional, .Mock.diploma]
  private var repository = CredentialRepositoryProtocolSpy()
  // swiftlint:enable all

}
