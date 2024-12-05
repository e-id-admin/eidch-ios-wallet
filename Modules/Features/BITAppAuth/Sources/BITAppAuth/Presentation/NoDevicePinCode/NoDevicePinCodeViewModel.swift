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

  public init(routes: NoDevicePinCodeRouterRoutes, hasDevicePinUseCase: HasDevicePinUseCaseProtocol = Container.shared.hasDevicePinUseCase()) {
    self.routes = routes
    self.hasDevicePinUseCase = hasDevicePinUseCase

    configureObservers()
  }

  // MARK: Public

  public weak var delegate: NoDevicePinCodeDelegate?

  // MARK: Private

  private let routes: NoDevicePinCodeRouterRoutes
  private let hasDevicePinUseCase: HasDevicePinUseCaseProtocol

  private func configureObservers() {
    NotificationCenter.default.addObserver(forName: .willEnterForeground, object: nil, queue: .main) { [weak self] _ in
      guard let self, hasDevicePinUseCase.execute() else { return }
      routes.close(onComplete: nil)
      delegate?.didCompleteNoDevicePinCode()
    }
  }

}
