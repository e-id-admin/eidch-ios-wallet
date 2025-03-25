#if DEBUG
import Foundation
@testable import BITTestingCore

extension CredentialMetadataWrapper: Mockable {
  struct Mock {
    static var sample = CredentialMetadataWrapper(selectedCredentialSupportedId: "elfa-sdjwt", credentialMetadata: .Mock.sample)
    static var sampleNoClaims = CredentialMetadataWrapper(selectedCredentialSupportedId: "elfa-sdjwt", credentialMetadata: .Mock.sampleNoClaims)
    static var sampleMultipass = CredentialMetadataWrapper(selectedCredentialSupportedId: "sd_elfa_jwt", credentialMetadata: .Mock.sampleMultipass)
    static var sampleUnknownAlgorithm = CredentialMetadataWrapper(selectedCredentialSupportedId: "elfa", credentialMetadata: .Mock.sampleUnknownAlgorithm)
    static var sampleWithoutProofTypes = CredentialMetadataWrapper(selectedCredentialSupportedId: "elfa-sdjwt", credentialMetadata: .Mock.sampleWithoutProofTypes)
  }
}
#endif
