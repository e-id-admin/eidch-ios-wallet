import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - PinCodeConfirmationView

struct PinCodeConfirmationView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.pinCodeConfirmationViewModel(router))
  }

  // MARK: Internal

  var body: some View {
    content()
      .navigationTitle(L10n.tkGlobalConfirmpassword)
      .foregroundStyle(ThemingAssets.Grays.white.swiftUIColor)
      .background(
        ThemingAssets.Gradient.gradient4.swiftUIImage
          .resizable()
          .ignoresSafeArea()
          .accessibilityHidden(true))
      .colorScheme(.light)
      .task {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          focus = .input
        }
      }
  }

  // MARK: Private

  private enum Focus: Hashable {
    case input, inputText, loginButton, error
  }

  @StateObject private var viewModel: PinCodeConfirmationViewModel
  @AccessibilityFocusState private var focus: Focus?
  @FocusState private var inputFocused: Bool
  @Environment(\.sizeCategory) private var sizeCategory

  @Orientation private var orientation

  @ViewBuilder
  private func content() -> some View {
    ScrollView {
      VStack {
        if orientation.isLandscape {
          landscapeLayout()
        } else {
          portraitLayout()
        }
      }
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.center)
      .padding(.horizontal, .x6)
      .padding(.vertical, .x2)
    }
    .safeAreaInset(edge: .bottom) {
      if !orientation.isLandscape {
        footerView()
      }
    }
  }

  @ViewBuilder
  private func landscapeLayout() -> some View {
    VStack(alignment: .leading) {
      HStack {
        secureField()

        nextButton()
          .buttonStyle(.filledPrimary)
      }

      if let message = viewModel.inputFieldMessage {
        inputFieldMessage(message)
          .padding(.horizontal, .x3)
      }
    }
  }

  @ViewBuilder
  private func portraitLayout() -> some View {
    VStack(alignment: .leading) {
      secureField()

      if let message = viewModel.inputFieldMessage {
        inputFieldMessage(message)
          .padding(.horizontal, .x3)
      }
    }
    .padding(.top, sizeCategory.isAccessibilityCategory ? 0 : 100)
    .accessibilityElement(children: .combine)

    Spacer()
  }

  @ViewBuilder
  private func footerView() -> some View {
    HStack {
      Spacer()

      nextButton()
        .accessibilitySortPriority(600)
        .accessibilityFocused($focus, equals: .loginButton)
    }
    .padding(.horizontal, .x6)
    .padding(.vertical, .x2)
  }

  @ViewBuilder
  private func secureField() -> some View {
    SecureTextField(text: $viewModel.pinCode, prompt: L10n.tkLoginPasswordNote) {
      viewModel.validate()
    }
    .submitLabel(.done)
    .frame(height: 52)
    .padding(.horizontal, .x3)
    .background(ThemingAssets.Grays.white.swiftUIColor)
    .cornerRadius(10)
    .focused($inputFocused)
    .modifier(ShakeEffect(animatableData: CGFloat(viewModel.attempts)))
    .onAppear {
      inputFocused = false
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        inputFocused = true
      }
    }
    .accessibilitySortPriority(800)
    .accessibilityFocused($focus, equals: .input)
  }

  @ViewBuilder
  private func nextButton() -> some View {
    Button {
      viewModel.validate()
    } label: {
      Text(L10n.tkGlobalContinue)
    }
    .buttonStyle(.filledPrimary)
    .controlSize(.large)
    .accessibilityFocused($focus, equals: .loginButton)
  }

  @ViewBuilder
  private func inputFieldMessage(_ message: String) -> some View {
    Text(message)
      .font(.custom.footnote)
      .multilineTextAlignment(.leading)
      .accessibilitySortPriority(700)
      .accessibilityFocused($focus, equals: .inputText)
  }

}

#Preview {
  PinCodeConfirmationView(router: OnboardingRouter())
}
