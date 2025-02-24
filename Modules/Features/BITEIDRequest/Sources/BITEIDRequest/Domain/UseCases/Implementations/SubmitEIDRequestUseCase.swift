import Factory

struct SubmitEIDRequestUseCase: SubmitEIDRequestUseCaseProtocol {

  // MARK: Internal

  func execute(_ payload: EIDRequestPayload) async throws -> EIDRequestCase {
    let response = try await remoteEIDRequestRepository.submitRequest(with: payload)

    var eIDRequestCase = EIDRequestCase(id: response.caseId, rawMRZ: payload.mrz, documentNumber: response.identityNumber, lastName: response.lastName, firstName: response.firstName)

    if let status = try? await remoteEIDRequestRepository.fetchRequestStatus(for: response.caseId) {
      eIDRequestCase.state = EIDRequestState(status: status)
    }

    return try await localEIDRequestRepository.create(eIDRequestCase: eIDRequestCase)
  }

  // MARK: Private

  @Injected(\.eIDRequestRepository) private var remoteEIDRequestRepository: EIDRequestRepositoryProtocol
  @Injected(\.localEIDRequestRepository) private var localEIDRequestRepository: LocalEIDRequestRepositoryProtocol
}
