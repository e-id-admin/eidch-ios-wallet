import AVFoundation

class CheckCardIntroductionViewModel {

  // MARK: Lifecycle

  init(router: EIDRequestInternalRoutes, cameraPermission: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)) {
    self.router = router
    self.cameraPermission = cameraPermission
  }

  // MARK: Internal

  func primaryAction() {
    switch cameraPermission {
    case .authorized:
      router.mrzScanner()
    default:
      router.cameraPermission()
    }
  }

  func close() {
    router.close()
  }

  // MARK: Private

  private let router: EIDRequestInternalRoutes
  private let cameraPermission: AVAuthorizationStatus
}
