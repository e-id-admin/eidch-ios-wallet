import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - SetupView

struct SetupView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.setupViewModel(router))

    backgroundColor = ThemingAssets.Background.secondary.swiftUIColor
    primary = L10n.tkOnboardingSetupPrimary
    secondary = L10n.tkOnboardingSetupSecondary
  }

  // MARK: Internal

  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @Environment(\.sizeCategory) var sizeCategory

  @Environment(\.dismiss) var dismiss

  var body: some View {
    content()
      .navigationBarBackButtonHidden(true)
      .onFirstAppear {
        Task {
          await viewModel.run()
        }
      }
      .onAppear {
        resetAccessibilityFocus()
      }
  }

  // MARK: Private

  private enum Constants {
    static var cardAccessibilityMaxHeight: CGFloat { 150 }
    static var animation = Animation.easeInOut
    static let errorAnimation = Animation.easeInOut
    static let gradientWidth: CGFloat = 1000
    static let gradientHeight: CGFloat = 1000
    static let animationSequenceSizes: [(size: CGSize, duration: Double, offsetX: CGFloat)] = [
      (CGSize(width: 250, height: 4), 1, offsetX: -20),
      (CGSize(width: 235, height: 28), 1, offsetX: 75),
      (CGSize(width: 235, height: 28), 1, offsetX: -50),
      (CGSize(width: 235, height: 28), 1, offsetX: 120),
    ]
  }

  @AccessibilityFocusState private var errorFocusedState: Bool
  @AccessibilityFocusState private var isCurrentPageFocused: Bool

  @StateObject private var viewModel: SetupViewModel

  @State private var size = CGSize.zero
  @State private var offsetX = CGFloat.zero

  private let primary: String
  private let secondary: String?
  private let backgroundColor: Color

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

extension SetupView {

  @ViewBuilder
  private func card() -> some View {
    Card(background: .color(backgroundColor), content: {
      if viewModel.isAnimating {
        Capsule()
          .overlay(
            ThemingAssets.Gradient.gradient3.swiftUIImage
              .resizable()
              .frame(width: Constants.gradientWidth, height: Constants.gradientHeight)
              .offset(x: offsetX)
          )
          .clipped()
          .clipShape(.capsule)
          .frame(maxWidth: size.width, maxHeight: size.height)
          .onAppear {
            withAnimation(Constants.animation) {
              viewModel.isAnimating = true
              animationSequence()
            }
          }
      } else {
        Capsule()
          .overlay(
            ThemingAssets.Gradient.gradient3.swiftUIImage
              .resizable()
              .frame(width: Constants.gradientWidth, height: Constants.gradientHeight)
              .offset(x: offsetX)
          )
          .clipped()
          .clipShape(.capsule)
          .frame(width: Constants.animationSequenceSizes[0].size.width, height: Constants.animationSequenceSizes[0].size.height)
      }
    })
    .foregroundStyle(ThemingAssets.Brand.Core.white.swiftUIColor)
    .accessibilityHidden(true)
  }

  @ViewBuilder
  private func main() -> some View {
    VStack(alignment: .leading, spacing: .x6) {
      Text(primary)
        .font(.custom.title)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
        .multilineTextAlignment(.leading)
        .accessibilityLabel(primary)
        .accessibilityFocused($isCurrentPageFocused)
        .accessibilityAddTraits(.isHeader)

      if let secondary {
        Text(secondary)
          .font(.custom.body)
          .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
          .multilineTextAlignment(.leading)
          .accessibilityLabel(secondary)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, .x6)
    .padding(.bottom)
  }

  private func animationSequence() {
    var delay = 0.0
    for (newSize, duration, offsetX) in Constants.animationSequenceSizes {
      withAnimation(Constants.animation.delay(delay)) {
        self.size = newSize
        self.offsetX = offsetX
      }
      delay += duration
    }
  }

}

// MARK: - Portrait layout

extension SetupView {

  @ViewBuilder
  private func portraitLayout() -> some View {
    VStack(alignment: .leading) {
      ViewThatFits(in: .vertical) {
        portraitContentLayout()
        portraitScrollableContentLayout()
      }
    }
  }

  @ViewBuilder
  private func portraitContentLayout() -> some View {
    VStack(spacing: 0) {
      portraitMainContent()
      Spacer()
    }
  }

  @ViewBuilder
  private func portraitScrollableContentLayout() -> some View {
    ScrollView {
      VStack(spacing: 0) {
        portraitMainContent()
      }
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

extension SetupView {

  @ViewBuilder
  private func landscapeLayout() -> some View {
    VStack(alignment: .leading) {
      ViewThatFits(in: .vertical) {
        landscapeContentLayout()
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
    }
  }

}

#Preview {
  SetupView(router: OnboardingRouter())
}
