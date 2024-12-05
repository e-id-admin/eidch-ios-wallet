import Spyable

@Spyable
public protocol ValidateTrustStatementUseCaseProtocol {
  func execute(_ trustStatement: TrustStatement) async -> Bool
}
