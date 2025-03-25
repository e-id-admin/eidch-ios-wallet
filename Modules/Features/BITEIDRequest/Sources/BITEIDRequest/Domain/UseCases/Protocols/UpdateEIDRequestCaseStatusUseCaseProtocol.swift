import Spyable

@Spyable
public protocol UpdateEIDRequestCaseStatusUseCaseProtocol {
  @discardableResult
  func execute(_ requestCases: [EIDRequestCase]) async throws -> [EIDRequestCase]
  func execute(for requestCase: EIDRequestCase) async throws -> EIDRequestCase
}
