import XCTest

@testable import BITOpenID

final class VcSdJwtDescriptorMapGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    generator = VcSdJwtDescriptorMapGenerator()
  }

  func testExecute_happyPath() throws {
    // swiftlint: disable all
    let inputDescriptor: InputDescriptor = RequestObject.Mock.VcSdJwt.sample.presentationDefinition.inputDescriptors.first!
    // swiftlint: enable all
    let mockFormat = "mock-format"

    let descriptorMap = try generator.generate(using: inputDescriptor, vcFormat: mockFormat)

    XCTAssertFalse(descriptorMap.isEmpty)
    XCTAssertEqual(descriptorMap.count, 1)
    XCTAssertEqual(mockFormat, descriptorMap.first?.format)
  }

  // MARK: Private

  // swiftlint:disable all
  private var generator: VcSdJwtDescriptorMapGenerator!
  // swiftlint:enable all
}
