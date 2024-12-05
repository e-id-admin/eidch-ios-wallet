import BITAnyCredentialFormat
import BITCore
import BITCredential
import BITCredentialShared
import BITOpenID
import Factory

// MARK: - CompatibleCredentialsError

public enum CompatibleCredentialsError: Error {
  case noCredentialsInWallet
  case noCompatibleCredentials
  case notMatchingField
  case invalidCredential
  case jsonPathParsingFailed
  case invalidRequestObject
}

// MARK: - GetCompatibleCredentialsUseCase

/// https://identity.foundation/presentation-exchange/spec/v2.1.0/#presentation-definition

struct GetCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocol {

  // MARK: Lifecycle

  init(
    repository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository(),
    createAnyCredentialUseCase: CreateAnyCredentialUseCaseProtocol = Container.shared.createAnyCredentialUseCase(),
    anyPresentationFieldsValidator: AnyPresentationFieldsValidatorProtocol = Container.shared.anyPresentationFieldsValidator())
  {
    self.repository = repository
    self.createAnyCredentialUseCase = createAnyCredentialUseCase
    self.anyPresentationFieldsValidator = anyPresentationFieldsValidator
  }

  // MARK: Internal

  func execute(using requestObject: RequestObject) async throws -> [InputDescriptorID: [CompatibleCredential]] {
    do {
      let requests = try await withThrowingTaskGroup(of: (inputDescriptorId: String, compatibleCredentials: [CompatibleCredential]).self, returning: [String: [CompatibleCredential]].self) { group in
        for inputDescriptor in requestObject.presentationDefinition.inputDescriptors {
          group.addTask {
            let compatibleCredentials = try await execute(inputDescriptor: inputDescriptor)
            return (inputDescriptor.id, compatibleCredentials)
          }
        }

        var requests: [String: [CompatibleCredential]] = [:]
        for try await (inputDescriptorId, compatibleCredentials) in group {
          requests[inputDescriptorId] = compatibleCredentials
        }

        return requests
      }

      if requests.contains(where: \.value.isEmpty) {
        throw CompatibleCredentialsError.noCompatibleCredentials
      }

      return requests
    } catch {
      throw error
    }
  }

  // MARK: Private

  private let repository: CredentialRepositoryProtocol
  private let createAnyCredentialUseCase: CreateAnyCredentialUseCaseProtocol
  private let anyPresentationFieldsValidator: AnyPresentationFieldsValidatorProtocol

  private func execute(inputDescriptor: InputDescriptor) async throws -> [CompatibleCredential] {
    var credentials = try await getCredentials()
    if let formats = inputDescriptor.formats {
      credentials = try filter(credentials: credentials, withFormats: formats)
    }

    if credentials.isEmpty {
      throw CompatibleCredentialsError.noCompatibleCredentials
    }

    guard let requestedFields = inputDescriptor.constraints.fields else {
      throw CompatibleCredentialsError.invalidRequestObject
    }

    var compatibleCredentials: [CompatibleCredential] = []

    for credential in credentials {
      do {
        let anyCredential = try createAnyCredentialUseCase.execute(from: credential.payload, format: credential.format)
        let matchingFields: [CodableValue] = try anyPresentationFieldsValidator.validate(anyCredential, with: requestedFields)

        guard matchingFields.count == requestedFields.count else { continue }
        compatibleCredentials.append(CompatibleCredential(credential: credential, requestedFields: matchingFields))
      } catch {
        continue
      }
    }

    if compatibleCredentials.isEmpty {
      throw CompatibleCredentialsError.noCompatibleCredentials
    }

    return compatibleCredentials
  }

  private func getCredentials() async throws -> [Credential] {
    let credentials = try await repository.getAll()

    if credentials.isEmpty {
      throw CompatibleCredentialsError.noCredentialsInWallet
    }

    return credentials
  }

  private func filter(credentials: [Credential], withFormats formats: [Format]) throws -> [Credential] {
    guard !formats.isEmpty else { return credentials }

    let filteredCredentialList = credentials.filter { credential in
      let matchingFormats = formats.filter { $0.label == credential.format }
      return !matchingFormats.filter { $0.keyBindingAlgorithm == nil }.isEmpty
        || !matchingFormats.compactMap { f in f.keyBindingAlgorithm }
        .flatMap { $0 }
        .filter {
          credential.keyBindingAlgorithm?.caseInsensitiveCompare($0) == .orderedSame
        }.isEmpty
    }

    if filteredCredentialList.isEmpty {
      throw CompatibleCredentialsError.noCompatibleCredentials
    }

    return filteredCredentialList
  }

}
