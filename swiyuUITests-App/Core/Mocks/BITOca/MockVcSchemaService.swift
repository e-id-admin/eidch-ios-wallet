import BITOpenID
import BITSdJWT
import Foundation

struct MockVcSchemaService: VcSchemaServiceProtocol {
  func fetch(for vc: VcSdJwt, with typeMetadata: TypeMetadata) async throws -> VcSchema? {
    VcSchema()
  }

  func validate(_ vcSchema: VcSchema, with vcSdJwt: VcSdJwt) -> Bool {
    true
  }
}
