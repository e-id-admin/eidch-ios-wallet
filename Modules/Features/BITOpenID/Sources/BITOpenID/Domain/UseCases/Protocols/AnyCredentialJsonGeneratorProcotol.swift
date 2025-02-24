import BITAnyCredentialFormat
import Spyable

// MARK: - AnyCredentialJsonGeneratorProtocol

@Spyable
protocol AnyCredentialJsonGeneratorProtocol {
  func generate(for anyCredential: AnyCredential) throws -> String
}
