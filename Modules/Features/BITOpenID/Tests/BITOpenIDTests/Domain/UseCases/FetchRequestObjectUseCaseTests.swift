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
    guard let mockUrl = URL(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromReturnValue = JWTRequestObject.Mock.jwtSampleData

    let requestObject = try await useCase.execute(mockUrl)

    XCTAssertEqual(requestObject.nonce, mockNonce)
    XCTAssertTrue(requestObject is JWTRequestObject)
    XCTAssertNotNil((requestObject as? JWTRequestObject)?.jwt)
    XCTAssertEqual(repository.fetchRequestObjectFromReceivedUrl, mockUrl)
  }

  func testFetchJsonRequestObject_Success() async throws {
    guard let mockUrl = URL(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromReturnValue = RequestObject.Mock.VcSdJwt.jsonSampleData

    let requestObject = try await useCase.execute(mockUrl)

    XCTAssertEqual(requestObject.nonce, mockNonce)
    XCTAssertFalse(requestObject is JWTRequestObject)
    XCTAssertEqual(repository.fetchRequestObjectFromReceivedUrl, mockUrl)
  }

  func testFetchRequestObject_InvalidUrl_Failure() async throws {
    guard let mockUrl = URL(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromThrowableError = NetworkError(status: .hostnameNotFound)

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch is NetworkError {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
      XCTAssertEqual(1, repository.fetchRequestObjectFromCallsCount)
    } catch {
      XCTFail("No the expected execution")
    }
  }

  func testFetchRequestObject_Failure() async throws {
    guard let mockUrl = URL(string: strURL) else {
      fatalError("url generation")
    }

    repository.fetchRequestObjectFromThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(mockUrl)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(repository.fetchRequestObjectFromCalled)
      XCTAssertEqual(1, repository.fetchRequestObjectFromCallsCount)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private let mockNonce = "nonce"
  private var useCase = FetchRequestObjectUseCase()
  private var repository = OpenIDRepositoryProtocolSpy()
}
