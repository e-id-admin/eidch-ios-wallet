import BITNetworking
import Factory
import Foundation

struct EIDRequestRepository: EIDRequestRepositoryProtocol {

  func submitRequest(with payload: EIDRequestPayload) async throws -> EIDRequestResponse {
    try await networkService.request(EIDRequestEndpoint.submit(payload: payload), decoder: eIDRequestResponseDecoder)
  }

  func fetchRequestStatus(for caseId: String) async throws -> EIDRequestStatus {
    try await networkService.request(EIDRequestEndpoint.getStatus(caseId: caseId))
  }

  @Injected(\NetworkContainer.service) private var networkService: NetworkService
  @Injected(\.eIDRequestResponseDecoder) private var eIDRequestResponseDecoder: JSONDecoder
}
