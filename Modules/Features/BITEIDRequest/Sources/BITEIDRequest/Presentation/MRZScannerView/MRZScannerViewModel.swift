import BITNetworking
import Factory
import Foundation

@MainActor
class MRZScannerViewModel: ObservableObject {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes) {
    self.router = router
  }

  // MARK: Internal

  @Published var isErrorPresented = false
  @Published var errorDescription: String? = nil

  func submit(_ payload: EIDRequestPayload) async {
    do {
      let eIDRequestCase = try await submitEIDRequestUseCase.execute(payload)

      guard
        let state = eIDRequestCase.state?.state,
        state == .inQueue,
        let onlineSessionStartOpenAt = eIDRequestCase.state?.onlineSessionStartOpenAt
      else {
        return close()
      }

      return router.queueInformation(onlineSessionStartOpenAt)
    } catch let error as NetworkError {
      if let data = error.response?.data {
        errorDescription = String(data: data, encoding: .utf8)
        isErrorPresented = true
      }
    } catch {
      errorDescription = error.localizedDescription
      isErrorPresented = true
    }
  }

  func close() {
    router.close()
  }

  func resetError() {
    isErrorPresented = false
    errorDescription = nil
  }

  // MARK: Private

  private let router: EIDRequestInternalRoutes

  @Injected(\.submitEIDRequestUseCase) private var submitEIDRequestUseCase: SubmitEIDRequestUseCaseProtocol
}
