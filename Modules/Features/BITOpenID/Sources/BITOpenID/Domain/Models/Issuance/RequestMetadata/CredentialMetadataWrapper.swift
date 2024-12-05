import Foundation

/**
 - Description: CredentialMetadataWrapper handles the mapping between the selectedCredential coming from the metadata and the metadata themselves. That selectedCredentialID will allow us to find later on the correct rawCredential payload and map the corresponding claims.
 */

public struct CredentialMetadataWrapper {

  public var credentialMetadata: CredentialMetadata
  public var selectedCredential: (any CredentialMetadata.AnyCredentialConfigurationSupported)?

  public init(selectedCredentialSupportedId: String, credentialMetadata: CredentialMetadata) {
    self.credentialMetadata = credentialMetadata
    if let selectedCredential = credentialMetadata.credentialConfigurationsSupported.first(where: { $0.key == selectedCredentialSupportedId })?.value {
      self.selectedCredential = selectedCredential
    }
  }

}
