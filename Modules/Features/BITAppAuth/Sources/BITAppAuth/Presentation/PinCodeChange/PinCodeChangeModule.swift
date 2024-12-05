import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - ChangePinCodeModule

@MainActor
public class ChangePinCodeModule {

  // MARK: Lifecycle

  public init() {
    router = Container.shared.changePinCodeRouter()
    let viewController = UIHostingController(rootView: CurrentPinCodeView(router))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public var router: ChangePinCodeRouter

  // MARK: Internal

  @Injected(\.changePinCodeContext) var context: ChangePinCodeContext
}

// MARK: - ChangePinCodeModuleWrapper

public struct ChangePinCodeModuleWrapper: UIViewControllerRepresentable {

  public init(delegate: ChangePinCodeDelegate) {
    self.delegate = delegate
  }

  public func makeUIViewController(context: Context) -> UIViewController {
    module.router.context.changePinCodeDelegate = delegate
    return module.viewController
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  @Injected(\.changePinCodeModule) private var module: ChangePinCodeModule
  private weak var delegate: ChangePinCodeDelegate?
}
