import XCTest
@testable import BITOpenID

final class PresentationRequestBodyTests: XCTestCase {

  // MARK: Internal

  func test_acceptPresentation() {
    let presentationRequestBody = PresentationRequestBody(vpToken: vpToken, presentationSubmission: presentationSubmission)
    let dictionary = presentationRequestBody.asDictionary()

    XCTAssertFalse(dictionary.isEmpty)
    XCTAssertEqual(dictionary.count, 2)
    XCTAssertTrue(dictionary.contains(where: { $0.key == "vp_token" }))
    XCTAssertTrue(dictionary.contains(where: { $0.key == "presentation_submission" }))

    XCTAssertEqual(dictionary["vp_token"] as? String, vpToken)
    XCTAssertTrue(dictionary["presentation_submission"] is String)
  }

  // MARK: Private

  private static let definitionId = UUID().uuidString

  private static let id = UUID().uuidString

  private let vpToken = "vpToken"
  private let presentationSubmission = PresentationRequestBody.PresentationSubmission(id: id, definitionId: definitionId, descriptorMap: [])

}
