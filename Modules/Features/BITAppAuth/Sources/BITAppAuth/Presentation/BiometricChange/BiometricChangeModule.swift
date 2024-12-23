import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - BiometricChangeModule

@MainActor
public class BiometricChangeModule {

  // MARK: Lifecycle

  public init() {
    router = Container.shared.biometricChangeRouter()
    let viewController = UIHostingController(rootView: BiometricChangeView(router))
    router.viewController = viewController
    self.viewController = viewController
  }

  // MARK: Public

  public let viewController: UIViewController
  public var router: BiometricChangeRouter
}

// MARK: - BiometricChangeModuleWrapper

public struct BiometricChangeModuleWrapper: UIViewControllerRepresentable {

  public init(delegate: BiometricChangeDelegate) {
    self.delegate = delegate
  }

  public func makeUIViewController(context: Context) -> UIViewController {
    module.router.delegate = delegate
    return module.viewController
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  weak var delegate: BiometricChangeDelegate?
  @Injected(\.biometricChangeModule) private var module: BiometricChangeModule
}
