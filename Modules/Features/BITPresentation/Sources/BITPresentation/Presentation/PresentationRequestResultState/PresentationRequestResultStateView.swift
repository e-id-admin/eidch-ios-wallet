import BITCredential
import BITCredentialShared
import BITL10n
import BITTheming
import Factory
import SwiftUI

// MARK: - PresentationRequestResultStateView

struct PresentationRequestResultStateView: View {

  // MARK: Lifecycle

  init(state: PresentationRequestResultState, context: PresentationRequestContext, router: PresentationRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.presentationRequestResultStateViewModel((state, context, router)))
  }

  // MARK: Internal

  var body: some View {
    VStack {
      if let verifierDisplay = viewModel.verifierDisplay {
        ActorHeaderView(verifier: verifierDisplay)
          .padding(.horizontal, .x6)
          .padding(.top, .x3)
          .padding(.bottom, .x4)
      }
      sheetView()
    }
    .applyScrollViewIfNeeded()
    .ignoresSafeArea(edges: .bottom)
    .readSize(onChange: { size in
      compression = sizeCategory.isAccessibilityCategory ? .small : UICompressionStyle(height: size.height)
      availableWidth = size.width
    })
    .readSafeAreaInsets(onChange: { insets in
      bottomSafeAreaInset = insets.bottom
    })
    .onAppear(perform: {
      isAccessibilityTitleFocused = true
    })
  }

  // MARK: Private

  @Environment(\.sizeCategory) private var sizeCategory
  @State private var compression = UICompressionStyle.normal
  @State private var availableWidth: CGFloat = 0
  @State private var bottomSafeAreaInset: CGFloat = 0

  @AccessibilityFocusState(for: .voiceOver)
  private var isAccessibilityTitleFocused: Bool

  @StateObject private var viewModel: PresentationRequestResultStateViewModel

  @ViewBuilder
  private func sheetView() -> some View {
    VStack {
      Spacer()
      if sizeCategory < .accessibilityExtraLarge {
        viewModel.state.icon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 56, height: 56)
          .accessibilityLabel(viewModel.state.sheetAccessibilityLabel)
          .accessibilityRemoveTraits(.isImage)
          .accessibilityFocused($isAccessibilityTitleFocused)
      }
      content()
      Spacer(minLength: compression.isCompressed ? .x4 : .x6)
      buttons()
    }
    .frame(maxWidth: .infinity)
    .padding(.top, compression.isCompressed ? .x4 : .x6)
    .padding(.bottom, .x4 + bottomSafeAreaInset)
    .padding(.horizontal, .x6)
    .background(viewModel.state.backgroundColor)
    .clipShape(RoundedCorner(radius: .x8, corners: [.topLeft, .topRight]))
    .accessibilityElement(children: .contain)
  }

  @ViewBuilder
  private func content() -> some View {
    switch viewModel.state {
    case .success(let claims):
      successView(claims: claims)
    case .deny:
      denyView()
    case .cancelled:
      errorMessages(title: L10n.tkPresentCanceledverificationTitle, subtitle: L10n.tkPresentCanceledverificationSubtitle)
    case .error:
      errorMessages(title: L10n.tkPresentErrorTitle, subtitle: L10n.tkPresentErrorSubtitle)
    }
  }

  @ViewBuilder
  private func successView(claims: [CredentialClaim]) -> some View {
    Text(L10n.tkPresentAcceptTitle)
      .multilineTextAlignment(.center)
      .font(.custom.body)
      .foregroundStyle(ThemingAssets.Brand.Core.firGreenLabel.swiftUIColor)
      .padding(.bottom, compression.isCompressed ? .x2 : .x4)
    claimsList(claims)
  }

  @ViewBuilder
  private func claimsList(_ claims: [CredentialClaim]) -> some View {
    LazyVStack(alignment: .leading, spacing: .x1) {
      ForEach(claims, id: \.id) { claim in
        HStack(alignment: .top, spacing: .x1) {
          if sizeCategory < .accessibilityExtraLarge {
            Assets.presentationSuccessItem.swiftUIImage
              .accessibilityHidden(true)
          }
          Text(claim.preferredDisplay?.name ?? claim.key)
            .font(.custom.body)
            .foregroundStyle(ThemingAssets.Brand.Core.firGreen.swiftUIColor)
        }
      }
    }
    .padding(.x4)
    .frame(maxWidth: 400)
    .background(ThemingAssets.Brand.Core.firGreenLabel.swiftUIColor)
    .clipShape(.rect(cornerRadius: .CornerRadius.xs))
  }

  @ViewBuilder
  private func denyView() -> some View {
    Text(L10n.tkPresentDeclineTitle)
      .multilineTextAlignment(.center)
      .font(.custom.body)
      .foregroundStyle(ThemingAssets.Brand.Core.navyBlueLabel.swiftUIColor)
      .padding(.bottom, compression.isCompressed ? .x2 : .x4)
  }

  @ViewBuilder
  private func errorMessages(title: String, subtitle: String) -> some View {
    VStack(spacing: .x1) {
      Text(title)
        .multilineTextAlignment(.center)
        .font(.custom.body)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
      Text(subtitle)
        .multilineTextAlignment(.center)
        .font(.custom.body)
        .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor.opacity(0.7))
    }
    .padding(.top, .x1)
  }

  @ViewBuilder
  private func buttons() -> some View {
    switch viewModel.state {
    case .success:
      closeButton()
        .buttonStyle(.firGreen)
    case .deny:
      closeButton()
        .buttonStyle(.navyBlue)
    case .cancelled:
      closeButton()
        .buttonStyle(.bezeled)
    case .error:
      errorButtons()
    }
  }

  @ViewBuilder
  private func closeButton() -> some View {
    Button { viewModel.close() } label: {
      Text(L10n.tkGlobalClose)
    }
    .controlSize(.large)
  }

  @ViewBuilder
  private func errorButtons() -> some View {
    ButtonStackView {
      let buttonSize = sizeCategory.isAccessibilityCategory ? .infinity : (min(availableWidth, 450) - .x2) / 2
      Button { viewModel.retry() } label: {
        Text(L10n.tkGlobalRepeatPrimarybutton)
          .frame(maxWidth: buttonSize)
      }
      .buttonStyle(.bezeled)
      .controlSize(.large)

      Button { viewModel.close() } label: {
        Text(L10n.tkGlobalCancel)
          .frame(maxWidth: buttonSize)
      }
      .buttonStyle(.plain)
      .controlSize(.large)
    }
  }

}

extension PresentationRequestResultState {
  fileprivate var backgroundColor: Color {
    switch self {
    case .success:
      ThemingAssets.Brand.Core.firGreen.swiftUIColor
    case .deny:
      ThemingAssets.Brand.Core.navyBlue.swiftUIColor
    case .cancelled,
         .error:
      ThemingAssets.Background.secondary.swiftUIColor
    }
  }

  fileprivate var icon: Image {
    switch self {
    case .success:
      Assets.presentationSuccess.swiftUIImage
    case .deny:
      Assets.presentationDeny.swiftUIImage
    case .cancelled,
         .error:
      Assets.presentationError.swiftUIImage
    }
  }

  fileprivate var sheetAccessibilityLabel: String {
    switch self {
    case .deny,
         .success:
      L10n.tkPresentConfirmAlt
    case .cancelled,
         .error:
      L10n.tkPresentWarningAlt
    }
  }
}

#if DEBUG
#Preview {
  PresentationRequestResultStateView(state: .error, context: .Mock.vcSdJwtSample, router: PresentationRouter())
}
#endif
