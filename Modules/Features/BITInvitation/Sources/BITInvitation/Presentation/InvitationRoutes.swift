import AVFoundation
import BITDeeplink
import BITNavigation
import Factory
import Foundation
import UIKit

// MARK: - InvitationRoutes

public protocol InvitationRoutes {
  func invitation()
  func deeplink(url: URL, animated: Bool) -> Bool
  func camera(openingStyle: OpeningStyle)
}

// MARK: - InvitationInternalRoutes

@MainActor
extension InvitationRoutes where Self: RouterProtocol {

  // MARK: Public

  public func deeplink(url: URL, animated: Bool) -> Bool {
    guard let topViewController = UIApplication.topViewController, !topViewController.className.contains("LoginHostingController") else {
      return false
    }

    let deeplinkManager = DeeplinkManager(allowedRoutes: RootDeeplinkRoute.allCases)
    guard let route = try? deeplinkManager.dispatchFirst(url) else { return false }

    switch route {
    case .credential:
      let module = DeeplinkModule(url: url)
      let style = ModalOpeningStyle(animatedWhenPresenting: animated, modalPresentationStyle: .fullScreen)
      module.router.current = style
      let viewController = UINavigationController(rootViewController: module.viewController)

      open(viewController, on: topViewController, as: style)
    }

    return true
  }

  public func deeplink(url: URL) -> Bool {
    deeplink(url: url, animated: true)
  }

  @MainActor
  public func invitation() {
    let style = ModalOpeningStyle(modalPresentationStyle: .fullScreen)
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: camera(openingStyle: style)
    case .denied,
         .notDetermined,
         .restricted: cameraPermission()
    }
  }

  public func camera(openingStyle style: OpeningStyle) {
    let module = CameraModule()
    var viewController = module.viewController

    if style is ModalOpeningStyle {
      viewController = UINavigationController(rootViewController: viewController)
    }

    module.router.current = style
    open(viewController, on: self.viewController, as: style)
  }

  // MARK: Internal

  func cameraPermission() {
    let module = CameraPermissionModule()
    let viewController = UINavigationController(rootViewController: module.viewController)

    let style = ModalOpeningStyle(modalPresentationStyle: .fullScreen)
    module.router.current = style
    open(viewController, on: self.viewController, as: style)
  }

}
