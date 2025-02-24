import Spyable
import XCTest
@testable import BITOpenID

final class AnyDescriptorMapGeneratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    generator = AnyDescriptorMapGenerator()
  }

  func testCreateVcSdJwtDescriptorMap() throws {
    let mockFormat = "mock-format"
    let descriptorMap = try generator.generate(using: inputDescriptor, vcFormat: mockFormat)

    XCTAssertEqual(descriptorMap.count, 1)
    XCTAssertEqual(mockFormat, descriptorMap.first?.format)
  }

  // MARK: Private

  // swiftlint:disable all
  private let inputDescriptor: InputDescriptor = RequestObject.Mock.VcSdJwt.sample.presentationDefinition.inputDescriptors.first!
  private var generator: AnyDescriptorMapGenerator!
  // swiftlint:enable all

}
