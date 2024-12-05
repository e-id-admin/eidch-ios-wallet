import Combine
import SwiftUI
import UIKit

// MARK: - Orientation

@propertyWrapper
public struct Orientation: DynamicProperty {
  @StateObject private var manager = OrientationManager.shared

  public init() {}

  public var wrappedValue: UIDeviceOrientation {
    manager.type
  }
}

// MARK: - OrientationManager

fileprivate class OrientationManager: ObservableObject {

  // MARK: Lifecycle

  private init() {
    setupInitialOrientation()
    observeOrientationChanges()
  }

  // MARK: Internal

  static let shared = OrientationManager()

  @Published var type: UIDeviceOrientation = .unknown

  let allowedOrientations: [UIDeviceOrientation] = [.portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight]

  // MARK: Private

  private var cancellables = Set<AnyCancellable>()

  private func setupInitialOrientation() {
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return
    }

    updateOrientation(with: scene.interfaceOrientation)
  }

  private func observeOrientationChanges() {
    NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
      .sink { [weak self] _ in
        guard let self else { return }
        updateOrientation(with: UIDevice.current.orientation)
      }
      .store(in: &cancellables)
  }

  private func updateOrientation(with orientation: UIInterfaceOrientation) {
    switch orientation {
    case .portrait:
      type = .portrait
    case .portraitUpsideDown:
      type = .portraitUpsideDown
    case .landscapeLeft:
      type = .landscapeLeft
    case .landscapeRight:
      type = .landscapeRight
    default:
      return
    }
  }

  private func updateOrientation(with orientation: UIDeviceOrientation) {
    guard allowedOrientations.contains(orientation) else { return }
    type = orientation
  }
}
