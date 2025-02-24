import BITTheming
import Foundation
import SwiftUI
import UIKit

// MARK: - PinCodeInformationController

class PinCodeInformationController: UIHostingController<PinCodeInformationView> {}

// MARK: - PinCodeHostingController

class PinCodeHostingController<Content>: UIHostingController<Content> where Content: View {

  // MARK: Internal

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    apply(customNavigationAppearance())
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    apply(BITAppearance.defaultUINavigationAppearance())
    navigationController?.navigationBar.tintColor = ThemingAssets.accentColor.color
  }

  func customNavigationAppearance() -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()

    appearance.configureWithTransparentBackground()

    appearance.backButtonAppearance = UIBarButtonItemAppearance(style: .plain)

    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
    barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
    barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
    barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
    barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]

    let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
    backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
    backButtonAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
    backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
    backButtonAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.clear]

    let backImage = ThemingAssets.back.image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -.x3, bottom: .x1, right: 0))
    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
    appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

    navigationController?.navigationBar.tintColor = .white

    appearance.buttonAppearance = barButtonItemAppearance
    appearance.backButtonAppearance = backButtonAppearance
    appearance.doneButtonAppearance = barButtonItemAppearance

    return appearance
  }

  // MARK: Private

  private func apply(_ appeareance: UINavigationBarAppearance) {
    navigationController?.navigationBar.scrollEdgeAppearance = appeareance
    navigationController?.navigationBar.compactAppearance = appeareance
    navigationController?.navigationBar.standardAppearance = appeareance
    navigationController?.navigationBar.compactScrollEdgeAppearance = appeareance
  }
}
