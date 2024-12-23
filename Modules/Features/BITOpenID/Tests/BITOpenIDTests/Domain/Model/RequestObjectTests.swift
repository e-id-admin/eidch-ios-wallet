import XCTest

@testable import BITOpenID
@testable import BITTestingCore

// MARK: - RequestObjectTests

final class RequestObjectTests: XCTestCase {

  // MARK: Internal

  func testDecodingVcSdJwtRequestObject() throws {
    let mockRequestObjectData = RequestObject.Mock.VcSdJwt.jsonSampleData
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertNotNil(mockRequestObject.clientMetadata)
    XCTAssertNotNil(mockRequestObject.clientMetadata?.clientName)
    XCTAssertNotNil(mockRequestObject.clientMetadata?.logoUri)

    guard
      let firstInputDescriptor = mockRequestObject.presentationDefinition.inputDescriptors.first,
      let formats = firstInputDescriptor.formats
    else {
      return XCTFail("No input descriptor.formats")
    }

    XCTAssertFalse(formats.isEmpty)
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
      let firstInputDescriptor = mockRequestObject.presentationDefinition.inputDescriptors.first,
      let formats = firstInputDescriptor.formats
    else {
      return XCTFail("No input descriptor.formats")
    }

    XCTAssertFalse(formats.isEmpty)
  }

  func testDecodingRequestObjectWithoutClientMetadata() throws {
    let mockRequestObjectData = RequestObject.Mock.VcSdJwt.sampleWithoutClientMetadataData
    let mockRequestObject = try JSONDecoder().decode(RequestObject.self, from: mockRequestObjectData)

    XCTAssertNotNil(mockRequestObject.presentationDefinition)
    XCTAssertFalse(mockRequestObject.responseUri.isEmpty)
    XCTAssertNil(mockRequestObject.clientMetadata)
  }

  func test_invalidRequestObject_missingFields() throws {
    let data = try loadJSON(from: RequestObject.Mock.VcSdJwt.sampleWithMissingConstraintsFieldsFilename)

    XCTAssertThrowsError(try JSONDecoder().decode(RequestObject.self, from: data)) { error in
      guard let decodingError = error as? DecodingError else {
        return XCTFail("Error is not a DecodingError")
      }

      switch decodingError {
      case .keyNotFound(let key, _):
        XCTAssertEqual(key.stringValue, "fields", "Missing 'fields' key")
      default:
        XCTFail("Expected keyNotFound error for 'fields', but got: \(decodingError)")
      }
    }
  }

  func test_invalidRequestObject_fieldEmpty() throws {
    let data = try loadJSON(from: RequestObject.Mock.VcSdJwt.sampleWithoutAnyConstraintsFieldsFilename)

    XCTAssertThrowsError(try JSONDecoder().decode(RequestObject.self, from: data)) { error in
      guard let decodingError = error as? DecodingError else {
        return XCTFail("Error is not a DecodingError")
      }

      switch decodingError {
      case .dataCorrupted(let context):
        XCTAssertEqual(context.codingPath.last?.stringValue, "fields", "Missing 'fields' key")
      default:
        XCTFail("Expected dataCorrupted error for 'fields', but got: \(decodingError)")
      }
    }
  }

  // MARK: Private

  private func loadJSON(from filename: String) throws -> Data {
    guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "json") else {
      XCTFail("Impossible to read \(filename)")
      throw NSError(domain: "TestErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "File not found"])
    }
    let raw = try String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")
    guard let data = raw.data(using: .utf8) else {
      XCTFail("Unable to parse JSON to Data")
      throw NSError(domain: "TestErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
    }
    return data
  }
}
