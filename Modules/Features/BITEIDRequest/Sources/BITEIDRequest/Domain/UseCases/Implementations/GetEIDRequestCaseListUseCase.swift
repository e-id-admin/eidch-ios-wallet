import BITCore
import Factory
import Foundation

struct GetEIDRequestCaseListUseCase: GetEIDRequestCaseListUseCaseProtocol {

  // MARK: Internal

  func execute() async throws -> [EIDRequestCase] {
    try await localEIDRequestRepository.getAll()
      .reorder(by: requestCasePriorityOrder, using: { $0.state?.state ?? .unknown })
  }

  // MARK: Private

  @Injected(\.requestCasePriorityOrder) private var requestCasePriorityOrder: [EIDRequestStatus.State]
  @Injected(\.localEIDRequestRepository) private var localEIDRequestRepository: LocalEIDRequestRepositoryProtocol
}
