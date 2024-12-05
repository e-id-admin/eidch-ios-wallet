import BITJWT
import Factory
import Foundation

// MARK: - ValidateTrustStatementUseCase

struct ValidateTrustStatementUseCase: ValidateTrustStatementUseCaseProtocol {

  // MARK: Internal

  func execute(_ trustStatement: TrustStatement) async -> Bool {
    do {
      guard
        let issuer = trustStatement.iss,
        try isDidTrusted(issuer),
        let statusList = trustStatement.statusList
      else {
        return false
      }

      if try await jwtSignatureValidator.validate(trustStatement) {
        return await tokenStatusListValidator.validate(statusList, issuer: issuer) == .valid
      }

      return false
    } catch {
      return false
    }
  }

  // MARK: Private

  @Injected(\.jwtSignatureValidator) private var jwtSignatureValidator: JWTSignatureValidatorProtocol
  @Injected(\.trustRegistryRepository) private var trustRegistryRepository: TrustRegistryRepositoryProtocol
  @Injected(\.tokenStatusListValidator) private var tokenStatusListValidator: AnyStatusCheckValidatorProtocol

  private func isDidTrusted(_ did: String) throws -> Bool {
    try trustRegistryRepository.getTrustedDids().contains(did)
  }

}
