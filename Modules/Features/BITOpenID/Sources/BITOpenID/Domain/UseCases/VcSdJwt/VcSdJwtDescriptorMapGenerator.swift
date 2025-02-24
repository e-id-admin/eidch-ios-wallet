import BITAnyCredentialFormat
import Foundation

struct VcSdJwtDescriptorMapGenerator: AnyDescriptorMapGeneratorProtocol {
  func generate(using inputDescriptor: InputDescriptor, vcFormat: String) throws -> [PresentationRequestBody.DescriptorMap] {
    [
      PresentationRequestBody.DescriptorMap(id: inputDescriptor.id, format: vcFormat, path: "$"),
    ]
  }
}
