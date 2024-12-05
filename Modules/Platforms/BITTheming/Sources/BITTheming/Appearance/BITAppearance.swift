import BITL10n
import Foundation
import UIKit

// MARK: - BITAppearance

public class BITAppearance {

  public static func setup() {
    BITAppearance.registerFonts()
    BITAppearance.setUIViewAppearance()
    BITAppearance.setUILabels()
    BITAppearance.setUISearchBar()
    BITAppearance.setUINavigationBarAppearance()
  }

}

extension BITAppearance {

  // MARK: Public

  public static func defaultUINavigationAppearance() -> UINavigationBarAppearance {
    let inlineTitleTextAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, font: FontFamily.ABCDiatype.bold)]
    let largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle, font: FontFamily.ABCDiatype.bold)]

    UINavigationBar.appearance().titleTextAttributes = inlineTitleTextAttributes
    UINavigationBar.appearance().largeTitleTextAttributes = largeTitleTextAttributes
    UINavigationBar.appearance().prefersLargeTitles = false

    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()

    appearance.backButtonAppearance = UIBarButtonItemAppearance(style: .plain)

    let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
    barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: ThemingAssets.accentColor.color]
    barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: ThemingAssets.accentColor.color]
    barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: ThemingAssets.accentColor.color]
    barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: ThemingAssets.accentColor.color]

    let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
    backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
    backButtonAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
    backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
    backButtonAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.clear]

    appearance.buttonAppearance = barButtonItemAppearance
    appearance.backButtonAppearance = backButtonAppearance
    appearance.doneButtonAppearance = barButtonItemAppearance

    let backImage = ThemingAssets.back.image
      .withRenderingMode(.alwaysOriginal)
      .withAlignmentRectInsets(
        .init(top: 0, left: -.x3, bottom: .x1, right: 0)
      )
    backImage.accessibilityLabel = L10n.globalBack
    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
    appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

    return appearance
  }

  // MARK: Private

  //MARK: - UI components

  private static func registerFonts() {
    FontFamily.registerAllCustomFonts()
  }

  private static func setUIViewAppearance() {
    let appearance = UIView.appearance()
    appearance.tintColor = ThemingAssets.accentColor.color
  }

  private static func setUILabels() {
    let headerLabels = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
    headerLabels.font = UIFont.preferredFont(forTextStyle: .callout, font: FontFamily.ABCDiatype.regular)
  }

  private static func setUISearchBar() {
    let searchBarAppeareance = UISearchBar.appearance()
    searchBarAppeareance.tintColor = ThemingAssets.accentColor.color
    searchBarAppeareance.searchBarStyle = .default
  }

  private static func setUINavigationBarAppearance() {
    let appearance = defaultUINavigationAppearance()

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
  }

}
