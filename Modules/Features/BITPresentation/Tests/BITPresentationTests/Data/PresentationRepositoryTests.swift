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

  func testSubmitPresentation_Success() async throws {
    try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
  }

  func testSubmitPresentation_InternalServerError_ReturnsPresentationFailed() async throws {
    mockResponse(code: 500)

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? PresentationError else { return XCTFail("Expected a PresentationError") }
      XCTAssertEqual(error, .presentationFailed)
    }
  }

  func testSubmitPresentation_NotFoundError_ReturnsNetworkError() async throws {
    mockResponse(code: 404)

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .notFound)
    }
  }

  func testSubmitPresentation_UnprocessableEntity_ReturnsPresentationFailed() async throws {
    mockResponse(code: 422)

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? PresentationError else { return XCTFail("Expected a PresentationError") }
      XCTAssertEqual(error, .presentationFailed)
    }
  }

  func testSubmitPresentation_BadRequest_ReturnsCredentialInvalid() async throws {
    mockResponse(code: 400)

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? PresentationError else { return XCTFail("Expected a PresentationError") }
      XCTAssertEqual(error, .credentialInvalid)
    }
  }

  func testSubmitPresentation_InvalidRequest_ReturnsCredentialInvalid() async throws {
    // swiftlint: disable all
    mockResponse(code: 400, data: "{\"error\":\"invalid_request\"}".data(using: .utf8)!)
    // swiftlint: enable all

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? PresentationError else { return XCTFail("Expected a PresentationError") }
      XCTAssertEqual(error, .credentialInvalid)
    }
  }

  func testSubmitPresentation_BadRequestWithUnknownResponse_ReturnsCredentialInvalid() async throws {
    // swiftlint: disable all
    mockResponse(code: 400, data: "{\"foo\":\"bar\"}".data(using: .utf8)!)
    // swiftlint: enable all

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? PresentationError else { return XCTFail("Expected a PresentationError") }
      XCTAssertEqual(error, .credentialInvalid)
    }
  }

  func testSubmitPresentation_ProcessClosed_ReturnsCancelled() async throws {
    // swiftlint: disable all
    mockResponse(code: 400, data: "{\"error\":\"verification_process_closed\"}".data(using: .utf8)!)
    // swiftlint: enable all

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationRequestBody: mockSubmitBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? PresentationError else { return XCTFail("Expected a PresentationError") }
      XCTAssertEqual(error, .presentationCancelled)
    }
  }

  func testSubmitPresentationError_Success() async throws {
    try await repository.submitPresentation(from: mockUrl, presentationErrorRequestBody: mockSubmitErrorBody)
  }

  func testSubmitPresentationError_Failure() async throws {
    mockResponse(code: 500)

    do {
      _ = try await repository.submitPresentation(from: mockUrl, presentationErrorRequestBody: mockSubmitErrorBody)
      XCTFail("Should have thrown an error")
    } catch {
      guard let error = error as? NetworkError else { return XCTFail("Expected a NetworkError") }
      XCTAssertEqual(error.status, .internalServerError)
    }
  }

  // MARK: Private

  // swiftlint: disable all
  private let mockUrl = URL(string: "some://url")!
  // swiftlint: enable all
  private let mockSubmitBody = PresentationRequestBody.Mock.sample()
  private let mockSubmitErrorBody = PresentationErrorRequestBody.Mock.sample()
  private var repository = PresentationRepository()

  private func mockResponse(code: Int, data: Data = Data()) {
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(code, data)
    }
  }
}
