import BITOpenID
import BITSdJWT
import Foundation

struct MockTypeMetadataService: TypeMetadataServiceProtocol {
  func fetch(_ vc: VcSdJwt) async throws -> TypeMetadata? {
    .Mock.sample
  }
}
