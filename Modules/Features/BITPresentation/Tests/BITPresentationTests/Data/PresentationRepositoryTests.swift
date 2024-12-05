import BITCore
import BITNetworking
import Moya
import XCTest

@testable import BITOpenID

@testable import BITPresentation

final class PresentationRepositoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    repository = PresentationRepository()
    NetworkContainer.shared.reset()
    NetworkContainer.shared.stubClosure.register {
      { _ in .immediate }
    }
  }

  // MARK: - Metadata

  func testSubmitPresentationSuccess() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let presentationRequestBody = PresentationRequestBody.Mock.sample()

    try await repository.submitPresentation(from: mockUrl, presentationRequestBody: presentationRequestBody)
  }

  func testSubmitPresentationErrorSuccess() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let presentationErrorRequestBody = PresentationErrorRequestBody.Mock.sample()

    try await repository.submitPresentation(from: mockUrl, presentationErrorRequestBody: presentationErrorRequestBody)
  }

  func testSubmitPresentationFailure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let presentationRequestBody = PresentationRequestBody.Mock.sample()

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: presentationRequestBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  func testSubmitPresentationErrorFailure() async throws {
    guard let mockUrl: URL = .init(string: strURL) else { fatalError("url building") }
    let presentationErrorRequestBody = PresentationErrorRequestBody.Mock.sample()

    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationErrorRequestBody: presentationErrorRequestBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: Private

  private let strURL = "some://url"
  private var repository = PresentationRepository()
}
