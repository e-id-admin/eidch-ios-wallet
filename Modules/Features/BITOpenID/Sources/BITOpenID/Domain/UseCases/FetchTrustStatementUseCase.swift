import BITAnyCredentialFormat
import BITCore
import Factory
import Foundation

// MARK: - FetchTrustStatementUseCase

struct FetchTrustStatementUseCase: FetchTrustStatementUseCaseProtocol {

  // MARK: Internal

  func execute(credential: AnyCredential) async throws -> TrustStatement? {
    try await fetchTrustStatement(from: credential.issuer)
  }

  func execute(jwtRequestObject: JWTRequestObject) async throws -> TrustStatement? {
    guard let issuer = jwtRequestObject.jwt.iss else {
      return nil
    }

    return try await fetchTrustStatement(from: issuer)
  }

  // MARK: Private

  private static let vctKey: String = "vct"
  private static let trustStatementMetadataV1Key: String = "TrustStatementMetadataV1"

  @Injected(\.baseRegistryDomainPattern) private var baseRegistryDomainPattern: String
  @Injected(\.openIDRepository) private var openIDRepository: OpenIDRepositoryProtocol
  @Injected(\.trustRegistryRepository) private var trustRegistryRepository: TrustRegistryRepositoryProtocol
  @Injected(\.validateTrustStatementUseCase) private var validateTrustStatementUseCase: ValidateTrustStatementUseCaseProtocol

  private func getBaseRegistryDomain(from did: String) -> String? {
    guard
      let match = RegexHelper.firstMatch(baseRegistryDomainPattern, in: did),
      let domainRange = Range(match.range(at: 1), in: did)
    else {
      return nil
    }

    return String(did[domainRange])
  }

  private func fetchTrustStatement(from issuer: String) async throws -> TrustStatement? {
    guard
      let baseRegistryDomain = getBaseRegistryDomain(from: issuer),
      let trustRegistryDomain = trustRegistryRepository.getTrustRegistryDomain(for: baseRegistryDomain),
      let trustStatementURL = URL(string: "https://\(trustRegistryDomain)")
    else {
      throw FetchTrustStatementUseCaseError.cannotParseTrustRegistryDomain
    }

    let trustStatementJwts = try await openIDRepository.fetchTrustStatements(from: trustStatementURL, issuerDid: issuer)
    let trustStatements: [TrustStatement] = trustStatementJwts
      .compactMap { try? .init(from: $0) }
      .filter {
        $0.disclosableClaims.contains(where: { $0.key == Self.vctKey && $0.value?.rawValue == Self.trustStatementMetadataV1Key })
      }

    for trustStatement in trustStatements where await validateTrustStatementUseCase.execute(trustStatement) {
      return trustStatement
    }

    return nil
  }

}

// MARK: FetchTrustStatementUseCase.FetchTrustStatementUseCaseError

extension FetchTrustStatementUseCase {
  enum FetchTrustStatementUseCaseError: Error {
    case cannotParseTrustRegistryDomain
  }
}
