import BITCore
import Factory
import Foundation

// MARK: - NoDevicePinCodeDelegate

public protocol NoDevicePinCodeDelegate: AnyObject {
  func didCompleteNoDevicePinCode()
}

// MARK: - NoDevicePinCodeViewModel

public class NoDevicePinCodeViewModel {

  // MARK: Lifecycle

  public init(router: NoDevicePinCodeRouterRoutes) {
    self.router = router

    configureObservers()
  }

  // MARK: Public

  public weak var delegate: NoDevicePinCodeDelegate?

  // MARK: Internal

  func openSettings() {
    router.settings()
  }

  // MARK: Private

  private let router: NoDevicePinCodeRouterRoutes
  @Injected(\.hasDevicePinUseCase) private var hasDevicePinUseCase: HasDevicePinUseCaseProtocol

  private func configureObservers() {
    NotificationCenter.default.addObserver(forName: .willEnterForeground, object: nil, queue: .main) { [weak self] _ in
      guard let self, hasDevicePinUseCase.execute() else { return }
      router.close(onComplete: nil)
      delegate?.didCompleteNoDevicePinCode()
    }
  }

}
