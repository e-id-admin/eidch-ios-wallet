import Spyable
import XCTest
@testable import BITCredential
@testable import BITInvitation
@testable import BITTestingCore

final class GetCredentialsCountUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = CredentialRepositoryProtocolSpy()
    useCase = GetCredentialsCountUseCase(repository: repository)
  }

  func testExecuteTrue_Success() async throws {
    repository.countReturnValue = 1

    let count = try await useCase.execute()

    XCTAssertTrue(repository.countCalled)
    XCTAssertEqual(count, 1)
  }

  func testExecuteFalse_Success() async throws {
    repository.countReturnValue = 0

    let count = try await useCase.execute()

    XCTAssertTrue(repository.countCalled)
    XCTAssertEqual(count, 0)
  }

  // MARK: Private

  // swiftlint: disable all
  private var repository: CredentialRepositoryProtocolSpy!
  private var useCase: GetCredentialsCountUseCase!
  // swiftlint: enable all

}
