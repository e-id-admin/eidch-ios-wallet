import Factory

struct UpdateEIDRequestCaseStatusUseCase: UpdateEIDRequestCaseStatusUseCaseProtocol {

  // MARK: Internal

  func execute(_ requestCases: [EIDRequestCase]) async throws -> [EIDRequestCase] {
    try await withThrowingTaskGroup(of: EIDRequestCase.self, returning: [EIDRequestCase].self) { taskGroup in
      for requestCase in requestCases {
        taskGroup.addTask {
          try await execute(for: requestCase)
        }
      }

      let requestCases = try await taskGroup.reduce(into: [EIDRequestCase]()) { updatedRequestCases, requestCase in
        updatedRequestCases.append(requestCase)
      }

      return requestCases
        .sorted { $0.createdAt > $1.createdAt }
        .reorder(by: requestCasePriorityOrder, using: { $0.state?.state ?? .unknown })
    }
  }

  func execute(for requestCase: EIDRequestCase) async throws -> EIDRequestCase {
    do {
      let status = try await checkStatus(for: requestCase)
      return try await updateRequestCase(requestCase, with: status)
    } catch {
      return requestCase
    }
  }

  // MARK: Private

  @Injected(\.requestCasePriorityOrder) private var requestCasePriorityOrder: [EIDRequestStatus.State]
  @Injected(\.eIDRequestRepository) private var remoteEIDRequestRepository: EIDRequestRepositoryProtocol
  @Injected(\.localEIDRequestRepository) private var localEIDRequestRepository: LocalEIDRequestRepositoryProtocol

  private func checkStatus(for eIDRequestCase: EIDRequestCase) async throws -> EIDRequestStatus {
    try await remoteEIDRequestRepository.fetchRequestStatus(for: eIDRequestCase.id)
  }

  private func updateRequestCase(_ eIDRequestCase: EIDRequestCase, with status: EIDRequestStatus) async throws -> EIDRequestCase {
    var requestCaseCopy = eIDRequestCase
    requestCaseCopy.state = EIDRequestState(status: status)

    return try await localEIDRequestRepository.update(requestCaseCopy)
  }

}
