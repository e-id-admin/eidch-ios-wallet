import BITNavigation
import BITTheming
import SwiftUI


public protocol EIDRequestRoutes {
  func eIDRequest()
}


protocol EIDRequestInternalRoutes: ClosableRoutes, ExternalRoutes {
  func dataPrivacy()
  func checkCardIntroduction()
  func cameraPermission()
  func mrzScanner()
  func queueInformation(_ onlineSessionStartDate: Date)
}

extension EIDRequestInternalRoutes where Self: RouterProtocol {

  func dataPrivacy() {
    let viewController = UIHostingController(rootView: DataPrivacyView(router: self))
    open(viewController, as: NavigationPushOpeningStyle())
  }

  func checkCardIntroduction() {
    let viewController = UIHostingController(rootView: CheckCardIntroductionView(router: self))
    open(viewController, as: NavigationPushOpeningStyle())
  }

  func cameraPermission() {
    let viewController = UIHostingController(rootView: CameraPermissionView(router: self))
    open(viewController, as: NavigationPushOpeningStyle())
  }

  func mrzScanner() {
    let viewController = HideBackButtonHostingController(rootView: MRZScannerView(router: self))
    open(viewController, as: NavigationPushOpeningStyle())
  }

  func queueInformation(_ onlineSessionStartDate: Date) {
    let viewController = HideBackButtonHostingController(rootView: QueueInformationView(router: self, onlineSessionStartDate: onlineSessionStartDate))
    open(viewController, as: NavigationPushOpeningStyle())
  }
}

@MainActor
extension EIDRequestRoutes where Self: RouterProtocol {

  public func eIDRequest() {
    let module = IntroductionModule()
    let viewController = module.viewController
    let style = ModalOpeningStyle(animatedWhenPresenting: true, modalPresentationStyle: .fullScreen)

    module.router.current = style
    open(viewController, on: self.viewController, as: style)
  }
}
