import Spyable

@Spyable
protocol EIDRequestRepositoryProtocol {
  func submitRequest(with payload: EIDRequestPayload) async throws -> EIDRequestResponse
  func fetchRequestStatus(for caseId: String) async throws -> EIDRequestStatus
}
