#if DEBUG
import Foundation

@testable import BITTestingCore

extension CredentialMetadata: Mockable {
  struct Mock {
    static let sample: CredentialMetadata = .decode(fromFile: "uetliberg-credential-metadata", bundle: Bundle.module)
    static let sampleMultipass: CredentialMetadata = .decode(fromFile: "multipass-credential-metadata", bundle: Bundle.module)
    static let sampleUnknownAlgorithm: CredentialMetadata = .decode(fromFile: "credential-metadata-unknown-algo", bundle: Bundle.module)
    static let sampleWithoutProofTypes: CredentialMetadata = .decode(fromFile: "credential-metadata-without-proof-types", bundle: Bundle.module)
    static let sampleUnsupportedProofTypeAlgorithmData: Data = CredentialMetadata.getData(fromFile: "credential-metadata-unsupported-proof-type-algorithm", bundle: Bundle.module) ?? Data()

    static let sampleData: Data = CredentialMetadata.getData(fromFile: "uetliberg-credential-metadata", bundle: Bundle.module) ?? Data()
    static let sampleWithUnknownFormatData: Data = CredentialMetadata.getData(fromFile: "credential-metadata-with-unknown-format", bundle: Bundle.module) ?? Data()
  }
}
#endif
