import BITNetworking
import Factory
import Spyable
import XCTest
@testable import BITOpenID
@testable import BITTestingCore

final class FetchRequestObjectUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    Container.shared.openIDRepository.register { self.repository }
    useCase = FetchRequestObjectUseCase()
  }

  func testFetchJwtRequestObject_Success() async throws {
    repository.fetchRequestObjectFromReturnValue = JWTRequestObject.Mock.jwtSampleData

    let requestObject = try await useCase.execute(mockUrl)

    XCTAssertEqual(requestObject.nonce, mockNonce)
    XCTAssertTrue(requestObject is JWTRequestObject)
    XCTAssertNotNil((requestObject as? JWTRequestObject)?.jwt)
    XCTAssertEqual(repository.fetchRequestObjectFromReceivedUrl, mockUrl)
  }

  func testFetchJsonRequestObject_Success() async throws {
    repository.fetchRequestObjectFromReturnValue = RequestObject.Mock.VcSdJwt.jsonSampleData

    let requestObject = try await useCase.execute(mockUrl)

    XCTAssertEqual(requestObject.nonce, mockNonce)
    XCTAssertFalse(requestObject is JWTRequestObject)
    XCTAssertEqual(repository.fetchRequestObjectFromReceivedUrl, mockUrl)
  }

  func testFetchRequestObject_DecodingError_Failure() async throws {
    repository.fetchRequestObjectFromReturnValue = "invalid".data(using: .utf8)

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch FetchRequestObjectError.invalidPresentationInvitation {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  func testFetchRequestObject_PresentationProcessClosed_Failure() async throws {
    repository.fetchRequestObjectFromThrowableError = OpenIdRepositoryError.presentationProcessClosed

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch FetchRequestObjectError.invalidPresentationInvitation {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
    } catch {
      XCTFail("No the expected execution")
    }
  }

  func testFetchRequestObject_Failure() async throws {
    repository.fetchRequestObjectFromThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  // swiftlint: disable all
  private let mockUrl = URL(string: "some://url")!
  // swiftlint: enable all
  private let mockNonce = "nonce"
  private var useCase = FetchRequestObjectUseCase()
  private var repository = OpenIDRepositoryProtocolSpy()
}
