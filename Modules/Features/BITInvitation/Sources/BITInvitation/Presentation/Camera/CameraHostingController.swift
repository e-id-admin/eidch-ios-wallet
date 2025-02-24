import BITTheming
import SwiftUI

class CameraHostingController: UIHostingController<CameraView> {

  // MARK: Internal

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    apply(customNavigationAppearance())
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    apply(BITAppearance.defaultUINavigationAppearance())
  }

  func customNavigationAppearance() -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = ThemingAssets.Brand.Core.navyBlue.color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))

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
