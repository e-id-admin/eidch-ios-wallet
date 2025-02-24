import XCTest
@testable import BITOpenID
@testable import BITTestingCore

// MARK: - RequestObjectTests

final class RequestObjectTests: XCTestCase {

  func testDecodingVcSdJwtRequestObject() throws {
    let mockRequestObjectData = RequestObject.Mock.VcSdJwt.jsonSampleData
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertNotNil(mockRequestObject.clientMetadata)
    XCTAssertNotNil(mockRequestObject.clientMetadata?.clientName)
    XCTAssertNotNil(mockRequestObject.clientMetadata?.logoUri)

    guard
      let firstInputDescriptor = mockRequestObject.presentationDefinition.inputDescriptors.first
    else {
      XCTFail("No input descriptor")
      return
    }
    XCTAssertFalse(firstInputDescriptor.formats.isEmpty)
  }

  func testDecodingVcSdJwtRequestObjectWithUnsupportedClientMetadata() throws {
    let mockRequestObjectData = RequestObject.Mock.VcSdJwt.sampleWithUnsupportedClientMetadata
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertNotNil(mockRequestObject.clientMetadata)
    XCTAssertNil(mockRequestObject.clientMetadata?.clientName)
    XCTAssertNil(mockRequestObject.clientMetadata?.logoUri)

    guard
      let firstInputDescriptor = mockRequestObject.presentationDefinition.inputDescriptors.first
    else {
      XCTFail("No input descriptor")
      return
    }
    XCTAssertFalse(firstInputDescriptor.formats.isEmpty)
  }

  func testDecodingRequestObjectWithoutClientMetadata() throws {
    let mockRequestObjectData = RequestObject.Mock.VcSdJwt.sampleWithoutClientMetadataData
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertNil(mockRequestObject.clientMetadata)
  }

  func testDecoding_UnknownInputDescriptorFormat_ThrowsInvalidPayload() throws {
    let data = RequestObject.Mock.UnknownFormat.sampleData

    XCTAssertThrowsError(try JSONDecoder().decode(RequestObject.self, from: data)) { error in
      XCTAssertEqual(error as? RequestObjectError, .invalidPayload)
    }
  }

  func testDecoding_NoInputDescriptorFormat_ThrowsInvalidPayload() throws {
    let data = RequestObject.Mock.UnknownFormat.sampleWithoutFormatData

    XCTAssertThrowsError(try JSONDecoder().decode(RequestObject.self, from: data)) { error in
      XCTAssertEqual(error as? RequestObjectError, .invalidPayload)
    }
  }

}
