import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - InputFieldState

enum InputFieldState {
  case normal
  case error
}

// MARK: - ChangePinCodeFormView

struct ChangePinCodeFormView: View {

  // MARK: Lifecycle

  init(pinCode: Binding<String>, fieldTitle: String = "", inputFieldState: InputFieldState = .normal, inputFieldMessage: String? = nil, attempts: Int = 0, onPressNext: @escaping () -> Void) {
    _pinCode = pinCode
    self.fieldTitle = fieldTitle
    self.inputFieldState = inputFieldState
    self.attempts = attempts
    self.inputFieldMessage = inputFieldMessage
    self.onPressNext = onPressNext
  }

  // MARK: Internal

  var body: some View {
    content()
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

  @Binding private var pinCode: String
  @FocusState private var inputFocused: Bool
  @AccessibilityFocusState private var errorFocusedState: Bool
  @AccessibilityFocusState private var focus: Focus?
  @Environment(\.sizeCategory) private var sizeCategory

  private var attempts = 0

  private var fieldTitle: String
  private var inputFieldState: InputFieldState
  private var inputFieldMessage: String?
  private var onPressNext: () -> Void

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

      if let message = inputFieldMessage {
        inputFieldMessage(message)
          .padding(.horizontal, .x3)
      }
    }
  }

  @ViewBuilder
  private func portraitLayout() -> some View {
    VStack(alignment: .leading) {
      secureField()

      if let message = inputFieldMessage {
        inputFieldMessage(message)
          .padding(.horizontal, .x3)
      }
    }
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
    .padding(.bottom, .x4)
  }

  @ViewBuilder
  private func secureField() -> some View {
    VStack(alignment: .leading) {
      Text(fieldTitle)
        .font(.footnote)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
      SecureField(text: $pinCode, prompt: L10n.tkLoginPasswordNote, onSubmit: onPressNext)
        .overlay(
          RoundedRectangle(cornerRadius: .x2)
            .inset(by: 1)
            .stroke(inputFieldState == .error ? ThemingAssets.Brand.Core.swissRed.swiftUIColor : ThemingAssets.Label.secondary.swiftUIColor, lineWidth: 1)
        )
        .focused($inputFocused)
        .modifier(ShakeEffect(animatableData: CGFloat(attempts)))
        .onAppear {
          inputFocused = false
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            inputFocused = true
          }
        }
        .accessibilitySortPriority(800)
        .accessibilityFocused($focus, equals: .input)
    }
  }

  @ViewBuilder
  private func nextButton() -> some View {
    Button {
      onPressNext()
    } label: {
      Text(L10n.onboardingContinue)
    }
    .buttonStyle(.filledPrimary)
    .controlSize(.large)
    .accessibilityFocused($focus, equals: .loginButton)
  }

  @ViewBuilder
  private func inputFieldMessage(_ message: String) -> some View {
    Text(message)
      .font(.custom.footnote)
      .foregroundStyle(ThemingAssets.Brand.Core.swissRed.swiftUIColor)
      .multilineTextAlignment(.leading)
      .accessibilitySortPriority(700)
      .accessibilityFocused($focus, equals: .inputText)
  }

}

#Preview {
  ChangePinCodeFormView(pinCode: .constant("123456"), inputFieldMessage: "Something comes here...", onPressNext: {})
}
