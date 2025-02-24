import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - PrivacyPermissionView

struct PrivacyPermissionView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.privacyPermissionViewModel(router))

    image = Assets.verifyCross.swiftUIImage
    backgroundImage = ThemingAssets.Gradient.gradient6.swiftUIImage
    primary = L10n.tkOnboardingImprovementTitle
    secondary = L10n.tkOnboardingImprovementBody
    tertiary = L10n.tkOnboardingImprovementLinkText
  }

  // MARK: Internal

  enum AccessibilityIdentifier: String {
    case image
    case primaryText
    case secondaryText
    case privacyLink
    case acceptButton
    case declineButton
  }

  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @Environment(\.sizeCategory) var sizeCategory

  @Environment(\.dismiss) var dismiss

  var body: some View {
    content()
      .onAppear {
        resetAccessibilityFocus()
      }
  }

  // MARK: Private

  private enum Constants {
    static var cardAccessibilityMaxHeight: CGFloat { 150 }
  }

  @AccessibilityFocusState private var isCurrentPageFocused: Bool

  @StateObject private var viewModel: PrivacyPermissionViewModel

  private let primary: String
  private let secondary: String
  private let tertiary: String
  private let image: Image
  private let backgroundImage: Image

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

extension PrivacyPermissionView {

  @ViewBuilder
  private func card() -> some View {
    Card(background: .image(backgroundImage), image: image)
      .foregroundStyle(ThemingAssets.Brand.Core.white.swiftUIColor)
      .accessibilityHidden(true)
      .accessibilityIdentifier(AccessibilityIdentifier.image.rawValue)
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
        .accessibilityLabel(primary)
        .accessibilityFocused($isCurrentPageFocused)
        .accessibilityAddTraits(.isHeader)
        .accessibilityIdentifier(AccessibilityIdentifier.primaryText.rawValue)

      Text(secondary)
        .font(.custom.body)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
        .multilineTextAlignment(.leading)
        .accessibilityLabel(secondary)

      ButtonLinkText(tertiary, {
        viewModel.openPrivacyPolicy()
      })
      .font(.custom.footnote)
      .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
      .multilineTextAlignment(.leading)
      .accessibilityLabel(tertiary)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, .x6)
    .padding(.bottom)
  }

  @ViewBuilder
  private func footer() -> some View {
    FooterView {
      Button(action: { Task { await viewModel.updatePrivacyPolicy(to: false) } }) {
        Text(L10n.tkGlobalNotallow)
          .multilineTextAlignment(.center)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bezeledLight)
      .controlSize(.large)
      .accessibilityLabel(L10n.onboardingPrivacyDeclineLoggingButton)
      .accessibilityIdentifier(AccessibilityIdentifier.acceptButton.rawValue)

      Button(action: { Task { await viewModel.updatePrivacyPolicy(to: true) } }) {
        Text(L10n.tkGlobalAllow)
          .multilineTextAlignment(.center)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.filledPrimary)
      .controlSize(.large)
      .accessibilityIdentifier(AccessibilityIdentifier.declineButton.rawValue)
    }
  }

}

// MARK: - Portrait layout

extension PrivacyPermissionView {

  @ViewBuilder
  private func portraitLayout() -> some View {
    ViewThatFits(in: .vertical) {
      portraitContentLayout()
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

extension PrivacyPermissionView {

  @ViewBuilder
  private func landscapeLayout() -> some View {
    ViewThatFits(in: .vertical) {
      landscapeContentLayout()
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

#Preview {
  PrivacyPermissionView(router: OnboardingRouter())
}
