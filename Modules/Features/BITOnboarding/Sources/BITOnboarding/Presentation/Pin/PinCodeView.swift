import BITL10n
import BITTheming
import Factory
import PopupView
import SwiftUI

// MARK: - PinCodeView

struct PinCodeView: View {

  // MARK: Lifecycle

  init(router: OnboardingInternalRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.pinCodeViewModel(router))
  }

  // MARK: Internal

  var body: some View {
    content()
      .navigationTitle(L10n.tkGlobalEnterpassword)
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
      .popup(isPresented: $viewModel.isErrorPresented) {
        Notification(
          systemImageName: "exclamationmark.triangle",
          imageColor: ThemingAssets.Brand.Core.swissRed.swiftUIColor,
          content: viewModel.error?.localizedDescription ?? L10n.onboardingPinCodeErrorUnknown,
          contentColor: ThemingAssets.Brand.Core.swissRed.swiftUIColor,
          closeAction: {
            viewModel.isErrorPresented = false
          })
          .padding(.x4)
          .environment(\.colorScheme, .light)
          .accessibilityElement(children: .combine)
          .accessibilityLabel(L10n.onboardingPinCodeErrorAltText(viewModel.error?.localizedDescription ?? ""))
          .accessibilitySortPriority(10)
          .accessibilityHidden(!viewModel.isErrorPresented)
          .accessibilityFocused($errorFocusedState)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              focus = .error
            }
          }
      } customize: {
        $0.type(.floater())
          .appearFrom(.bottomSlide)
          .closeOnTap(true)
          .autohideIn(UIAccessibility.isVoiceOverRunning ? nil : viewModel.autoHideErrorDelay)
          .animation(Defaults.errorAnimation)
      }
  }

  // MARK: Private

  private enum Defaults {
    static let errorAnimation: Animation = .interpolatingSpring(stiffness: 500, damping: 30)
  }

  private enum Focus: Hashable {
    case input, inputText, loginButton, error
  }

  @StateObject private var viewModel: PinCodeViewModel
  @FocusState private var inputFocused: Bool
  @AccessibilityFocusState private var errorFocusedState: Bool
  @AccessibilityFocusState private var focus: Focus?
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
    .padding(.bottom, .x4)
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
  PinCodeView(router: OnboardingRouter())
}
