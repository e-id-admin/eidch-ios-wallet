import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - BiometricView

struct BiometricView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.biometricViewModel(router))

    backgroundImage = ThemingAssets.Gradient.gradient4.swiftUIImage
  }

  // MARK: Internal

  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @Environment(\.sizeCategory) var sizeCategory

  var body: some View {
    content()
      .onAppear {
        resetAccessibilityFocus()
      }
      .popup(isPresented: $viewModel.isErrorPresented) {
        Notification(
          systemImageName: "exclamationmark.triangle",
          imageColor: ThemingAssets.Brand.Core.swissRed.swiftUIColor,
          content: viewModel.error?.localizedDescription ?? L10n.onboardingPinCodeErrorUnknown,
          contentColor: ThemingAssets.Brand.Core.swissRed.swiftUIColor,
          closeAction: {
            viewModel.hideError()
          })
          .padding(.horizontal, .x4)
          .environment(\.colorScheme, .light)
          .accessibilityElement(children: .combine)
          .accessibilityLabel(L10n.biometricSetupErrorAltText(viewModel.error?.localizedDescription ?? L10n.onboardingPinCodeErrorUnknown))
          .accessibilitySortPriority(10)
          .accessibilityHidden(!viewModel.isErrorPresented)
          .accessibilityFocused($errorFocusedState)
          .onAppear {
            errorFocusedState = viewModel.isErrorPresented
          }
      } customize: {
        $0.type(.floater())
          .appearFrom(.bottomSlide)
          .closeOnTap(true)
          .autohideIn(UIAccessibility.isVoiceOverRunning ? nil : viewModel.autoHideErrorDelay)
          .animation(Constants.errorAnimation)
      }
  }

  // MARK: Private

  private enum Constants {
    static var cardAccessibilityMaxHeight: CGFloat { 150 }
    static var errorAnimation: Animation = .interpolatingSpring(stiffness: 500, damping: 30)
  }

  @AccessibilityFocusState private var errorFocusedState: Bool

  @AccessibilityFocusState private var isCurrentPageFocused: Bool

  @StateObject private var viewModel: BiometricViewModel

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

extension BiometricView {

  @ViewBuilder
  private func card() -> some View {
    Card(background: .image(backgroundImage), image: viewModel.image)
      .foregroundStyle(ThemingAssets.Brand.Core.white.swiftUIColor)
      .accessibilityHidden(true)
      .colorScheme(.light)
  }

  @ViewBuilder
  private func main() -> some View {
    VStack(alignment: .leading, spacing: .x6) {
      Text(viewModel.primaryText)
        .font(.custom.title)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(0.5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel(viewModel.primaryText)
        .accessibilityFocused($isCurrentPageFocused)
        .accessibilityAddTraits(.isHeader)

      Text(viewModel.secondaryText)
        .font(.custom.body)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
        .multilineTextAlignment(.leading)
        .accessibilityLabel(viewModel.secondaryText)

      Text(viewModel.tertiaryText)
        .font(.custom.footnote)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
        .multilineTextAlignment(.leading)
        .accessibilityLabel(viewModel.tertiaryText)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, .x6)
    .padding(.bottom)
  }

  @ViewBuilder
  private func footer() -> some View {
    FooterView {
      Button(action: { viewModel.skip() }) {
        Text(L10n.biometricSetupDismissButton)
          .multilineTextAlignment(.center)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bezeledLight)
      .controlSize(.large)
      .accessibilityLabel(L10n.biometricSetupDismissButton)

      if viewModel.hasBiometricAuth {
        Button(action: { Task { await viewModel.registerBiometrics() } }) {
          Text(L10n.biometricSetupActionButton(viewModel.biometricType.text))
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.filledPrimary)
        .controlSize(.large)
        .accessibilityLabel(L10n.biometricSetupActionButton(viewModel.biometricType.text))
      } else {
        Button(action: { Task { viewModel.openSettings() } }) {
          Text(L10n.biometricSetupNoClass3ToSettingsButton)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.filledPrimary)
        .controlSize(.large)
        .accessibilityLabel(L10n.biometricSetupNoClass3ToSettingsButton)
      }
    }
  }

}

// MARK: - Portrait layout

extension BiometricView {

  @ViewBuilder
  private func portraitLayout() -> some View {
    ZStack(alignment: .center) {
      if #available(iOS 16, *) {
        ViewThatFits(in: .vertical) {
          portraitContentLayout()
          portraitScrollableContentLayout()
        }
      } else {
        portraitScrollableContentLayout()
      }
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

extension BiometricView {

  @ViewBuilder
  private func landscapeLayout() -> some View {
    ZStack(alignment: .center) {
      if #available(iOS 16, *) {
        ViewThatFits(in: .vertical) {
          landscapeContentLayout()
          landscapeScrollableContentLayout()
        }
      } else {
        landscapeScrollableContentLayout()
      }
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
  BiometricView(router: OnboardingRouter())
}
