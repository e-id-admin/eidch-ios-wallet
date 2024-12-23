import BITL10n
import SwiftUI

// MARK: - InformationView

public struct InformationView: View {

  // MARK: Lifecycle

  public init(
    primary: String,
    primaryAlt: String? = nil,
    secondary: String? = nil,
    secondaryAlt: String? = nil,
    tertiary: String? = nil,
    tertiaryAlt: String? = nil,
    tertiaryAction: (() -> Void)? = nil,
    isTertiaryTapable: Bool = false,
    image: Image,
    imageId: String? = nil,
    backgroundImage: Image = ThemingAssets.Gradient.gradient4.swiftUIImage,
    buttonLabel: String? = nil,
    onNextAction: (() -> Void)? = nil)
  {
    self.init(
      primary: primary,
      primaryAlt: primaryAlt,
      secondary: secondary,
      secondaryAlt: secondaryAlt,
      tertiary: tertiary,
      tertiaryAlt: tertiaryAlt,
      tertiaryAction: tertiaryAction,
      isTertiaryTapable: isTertiaryTapable,
      image: image,
      backgroundImage: backgroundImage,
      backgroundColor: nil,
      buttonLabel: buttonLabel,
      onNextAction: onNextAction)
  }

  public init(
    primary: String,
    primaryAlt: String? = nil,
    secondary: String? = nil,
    secondaryAlt: String? = nil,
    tertiary: String? = nil,
    tertiaryAlt: String? = nil,
    tertiaryAction: (() -> Void)? = nil,
    isTertiaryTapable: Bool = false,
    image: Image,
    backgroundColor: Color,
    buttonLabel: String? = nil,
    onNextAction: (() -> Void)? = nil)
  {
    self.init(
      primary: primary,
      primaryAlt: primaryAlt,
      secondary: secondary,
      secondaryAlt: secondaryAlt,
      tertiary: tertiary,
      tertiaryAlt: tertiaryAlt,
      tertiaryAction: tertiaryAction,
      isTertiaryTapable: isTertiaryTapable,
      image: image,
      backgroundImage: nil,
      backgroundColor: backgroundColor,
      buttonLabel: buttonLabel,
      onNextAction: onNextAction)
  }

  private init(
    primary: String,
    primaryAlt: String?,
    secondary: String?,
    secondaryAlt: String?,
    tertiary: String?,
    tertiaryAlt: String?,
    tertiaryAction: (() -> Void)?,
    isTertiaryTapable: Bool,
    image: Image,
    backgroundImage: Image?,
    backgroundColor: Color?,
    buttonLabel: String?,
    onNextAction: (() -> Void)?)
  {
    self.primary = primary
    self.primaryAlt = primaryAlt ?? primary
    self.secondary = secondary
    self.secondaryAlt = secondaryAlt ?? secondary
    self.tertiary = tertiary
    self.tertiaryAlt = tertiaryAlt ?? tertiary
    self.tertiaryAction = tertiaryAction
    self.isTertiaryTapable = isTertiaryTapable
    self.image = image
    self.backgroundImage = backgroundImage
    self.backgroundColor = backgroundColor
    self.buttonLabel = buttonLabel
    self.onNextAction = onNextAction
  }

  // MARK: Public

  public var body: some View {
    content()
      .onAppear {
        resetAccessibilityFocus()
      }
  }

  // MARK: Internal

  enum AccessibilityIdentifier: String {
    case primaryText
    case secondaryText
    case tertiaryText
    case image
    case continueButton
  }

  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @Environment(\.sizeCategory) var sizeCategory

  @Environment(\.dismiss) var dismiss

  // MARK: Private

  private enum Constants {
    static var cardAccessibilityMaxHeight: CGFloat { 150 }
  }

  @AccessibilityFocusState private var isCurrentPageFocused: Bool

  @State private var nextScreenPresented: Bool = false

  private let primary: String
  private let primaryAlt: String
  private let secondary: String?
  private let secondaryAlt: String?
  private let tertiary: String?
  private let tertiaryAlt: String?
  private let tertiaryAction: (() -> Void)?
  private let isTertiaryTapable: Bool
  private let image: Image
  private let backgroundImage: Image?
  private let backgroundColor: Color?
  private let buttonLabel: String?
  private let onNextAction: (() -> Void)?

  @ViewBuilder
  private func content() -> some View {
    switch (horizontalSizeClass, verticalSizeClass) {
    case (.compact, .regular):
      portraitLayout()
    default:
      landscapeLayout()
    }
  }

  private func resetAccessibilityFocus() {
    DispatchQueue.main.async {
      isCurrentPageFocused = false
      isCurrentPageFocused = true
    }
  }
}

// MARK: - Components

extension InformationView {

  @ViewBuilder
  private func card() -> some View {
    if let backgroundImage {
      Card(background: .image(backgroundImage), image: image)
        .foregroundStyle(ThemingAssets.Grays.white.swiftUIColor)
        .accessibilityHidden(true)
        .accessibilityIdentifier(AccessibilityIdentifier.image.rawValue)
    } else if let backgroundColor {
      Card(background: .color(backgroundColor), image: image)
        .foregroundStyle(ThemingAssets.Grays.white.swiftUIColor)
        .accessibilityHidden(true)
        .accessibilityIdentifier(AccessibilityIdentifier.image.rawValue)
    }
  }

  @ViewBuilder
  private func main() -> some View {
    VStack(alignment: .leading, spacing: .x6) {
      Text(primary)
        .font(.custom.title)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(0.5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityIdentifier(AccessibilityIdentifier.primaryText.rawValue)
        .accessibilityLabel(primaryAlt)
        .accessibilityFocused($isCurrentPageFocused)
        .accessibilityAddTraits(.isHeader)

      if let secondary {
        Text(secondary)
          .font(.custom.body)
          .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
          .accessibilityIdentifier(AccessibilityIdentifier.secondaryText.rawValue)
          .accessibilityLabel(secondaryAlt ?? secondary)
      }

      if let tertiary {
        if isTertiaryTapable {
          ButtonLinkText(tertiary, { tertiaryAction?() })
            .font(.custom.footnote)
            .foregroundColor(ThemingAssets.Brand.Core.swissRedLabel.swiftUIColor)
            .accessibilityLabel(tertiary)
        } else {
          Text(tertiary)
            .font(.custom.footnote)
            .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityIdentifier(AccessibilityIdentifier.tertiaryText.rawValue)
            .accessibilityLabel(tertiaryAlt ?? tertiary)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, .x6)
    .padding(.bottom)
  }

  @ViewBuilder
  private func footer() -> some View {
    FooterView {
      if !sizeCategory.isAccessibilityCategory {
        Spacer()
      }

      if let buttonLabel {
        Button(action: { onNextAction?() }) {
          Text(buttonLabel)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .if(sizeCategory.isAccessibilityCategory) {
              $0.frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.filledPrimary)
        .controlSize(.large)
        .accessibilityIdentifier(AccessibilityIdentifier.continueButton.rawValue)
        .accessibilityLabel(buttonLabel)
      }
    }
  }

}

// MARK: - Portrait layout

extension InformationView {

  @ViewBuilder
  private func portraitLayout() -> some View {
    if #available(iOS 16, *) {
      ViewThatFits(in: .vertical) {
        portraitContentLayout()
        portraitScrollableContentLayout()
      }
    } else {
      portraitScrollableContentLayout()
    }
  }

  @ViewBuilder
  private func portraitContentLayout() -> some View {
    VStack(spacing: 0) {
      portraitMainContent()
      Spacer()
      footer()
    }
  }

  @ViewBuilder
  private func portraitScrollableContentLayout() -> some View {
    ScrollView {
      VStack(spacing: 0) {
        portraitMainContent()
        if sizeCategory.isAccessibilityCategory {
          footer()
        }
      }
    }
    .if(!sizeCategory.isAccessibilityCategory, transform: {
      $0.safeAreaInset(edge: .bottom) {
        footer()
      }
    })
    .overlay(alignment: .top) {
      Color.clear
        .background(ThemingAssets.Brand.Core.white.swiftUIColor)
        .ignoresSafeArea(edges: .top)
        .frame(height: 0)
    }
  }

  @ViewBuilder
  private func portraitMainContent() -> some View {
    VStack(spacing: .x6) {
      card()
        .if(sizeCategory.isAccessibilityCategory) {
          $0.frame(maxHeight: Constants.cardAccessibilityMaxHeight)
        }
        .padding(.top, .x3)

      main()

      Spacer()
    }
  }
}

// MARK: - Landscape layout

extension InformationView {

  @ViewBuilder
  private func landscapeLayout() -> some View {
    if #available(iOS 16, *) {
      ViewThatFits(in: .vertical) {
        landscapeContentLayout()
        landscapeScrollableContentLayout()
      }
    } else {
      landscapeScrollableContentLayout()
    }
  }

  @ViewBuilder
  private func landscapeContentLayout() -> some View {
    HStack {
      card()
        .padding(.x3)

      VStack(spacing: .x6) {
        main()
          .padding(.top, .x3)
        Spacer()
        footer()
      }
    }
  }

  @ViewBuilder
  private func landscapeScrollableContentLayout() -> some View {
    HStack {
      card()
        .padding(.x3)

      ScrollView {
        VStack(spacing: .x6) {
          main()
            .padding(.top, .x3)
          Spacer()
        }
      }
      .safeAreaInset(edge: .bottom) {
        footer()
          .background(ThemingAssets.Materials.chrome.swiftUIColor)
      }
    }
  }
}
