import BITAnyCredentialFormat
import BITCredentialShared
import BITOpenID
import Factory
import Foundation

// MARK: - CheckAndUpdateCredentialStatusUseCase

public struct CheckAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol {

  // MARK: Lifecycle

  init(
    createAnyCredentialUseCase: CreateAnyCredentialUseCaseProtocol = Container.shared.createAnyCredentialUseCase(),
    localRepository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository(),
    dateBuffer: TimeInterval = Container.shared.dateBuffer(),
    validators: [AnyStatusType: any AnyStatusCheckValidatorProtocol] = Container.shared.statusValidators())
  {
    self.createAnyCredentialUseCase = createAnyCredentialUseCase
    self.localRepository = localRepository
    self.dateBuffer = dateBuffer
    self.validators = validators
  }

  // MARK: Public

  public func execute(_ credentials: [Credential]) async throws -> [Credential] {
    try await withThrowingTaskGroup(of: Credential.self, returning: [Credential].self) { taskGroup in

      for credential in credentials {
        taskGroup.addTask {
          try await execute(for: credential)
        }
      }

      return try await taskGroup.reduce(into: [Credential]()) { updatedCredentials, credential in
        updatedCredentials.append(credential)
      }
    }
  }

  public func execute(for credential: Credential) async throws -> Credential {
    let status = try await getStatus(of: credential)
    if status != .unknown {
      return try await updateCredentialStatus(credential, to: status)
    } else {
      return credential
    }
  }

  // MARK: Internal

  var validators: [AnyStatusType: any AnyStatusCheckValidatorProtocol]

  // MARK: Private

  private let dateBuffer: TimeInterval
  private let createAnyCredentialUseCase: CreateAnyCredentialUseCaseProtocol
  private let localRepository: CredentialRepositoryProtocol
}

extension CheckAndUpdateCredentialStatusUseCase {
  private func getStatus(of credential: Credential) async throws -> VcStatus {
    let anyCredential = try createAnyCredentialUseCase.execute(from: credential.payload, format: credential.format)
    let dateStatus = checkDateValidity(anyCredential: anyCredential)
    guard dateStatus == .valid else {
      return dateStatus
    }
    guard
      let anyStatus = anyCredential.status,
      let validator = validators[anyStatus.type]
    else { return .unknown }
    let status = await validator.validate(anyStatus, issuer: anyCredential.issuer)
    if status != .unknown {
      return status
    }
    return .unknown
  }

  private func checkDateValidity(anyCredential: AnyCredential) -> VcStatus {
    let now = Date().addingTimeInterval(dateBuffer)


    if let validUntil = anyCredential.validUntil, validUntil < now {
      return .expired
    }

    return .valid
  }

  private func updateCredentialStatus(_ credential: Credential, to status: VcStatus) async throws -> Credential {
    var credentialCopy = credential
    credentialCopy.status = status

    return try await localRepository.update(credentialCopy)
  }

}
