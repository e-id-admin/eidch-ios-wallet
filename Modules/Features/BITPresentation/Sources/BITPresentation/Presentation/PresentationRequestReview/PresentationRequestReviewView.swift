import BITCredential
import BITCredentialShared
import BITL10n
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - PresentationRequestReviewView

public struct PresentationRequestReviewView: View {

  // MARK: Lifecycle

  public init(context: PresentationRequestContext, router: PresentationRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.presentationRequestReviewViewModel((context, router)))
  }

  // MARK: Public

  public var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack(alignment: .leading, spacing: .x6) {
          trustHeader()
            .padding(.horizontal, .x6)
            .padding(.top, .x3)

          if let credential = viewModel.credential {
            credentialContainer(credential)
            content(credential)
          }
        }
      }
      .onFirstAppear {
        compression = .init(height: proxy.size.height)
      }
    }
    .accessibilityAction(named: L10n.presentationAcceptButtonText, {
      Task { await viewModel.send(event: .submit) }
    })
    .accessibilityAction(named: L10n.presentationDenyButtonText, {
      Task { await viewModel.send(event: .deny) }
    })
    .navigationBarHidden(true)
  }

  // MARK: Internal

  @Environment(\.sizeCategory) var sizeCategory
  @Environment(\.accessibilityVoiceOverEnabled) var isVoiceOverEnabled

  // MARK: Private

  private enum Constants {
    static let issuerLineSpacing: CGFloat = -10
  }

  @State private var compression: UICompressionStyle = .normal
  @State private var viewport: CGRect = .zero

  @StateObject private var viewModel: PresentationRequestReviewViewModel

  @ViewBuilder
  private func credentialContainer(_ credential: CompatibleCredential) -> some View {
    VStack {
      Spacer(minLength: compression.isCompressed ? .x4 : .x12)
      CredentialCard(credential.credential)
        .padding(.horizontal, .x10)
        .accessibilityHidden(true)
      Spacer(minLength: compression.isCompressed ? .x6 : .x12)

      footerButtons()
        .accessibilityElement(children: .contain)
    }
    .padding(.x6)
    .background(
      Color(uiColor: .secondarySystemBackground)
        .ignoresSafeArea(.container, edges: .bottom)
    )
    .clipShape(.rect(cornerRadius: .x8))
    .accessibilityElement(children: .contain)
  }

  @ViewBuilder
  private func content(_ compatibleCredential: CompatibleCredential) -> some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {
        Text(L10n.credentialOfferContentSectionTitle)
          .font(.custom.body)
          .padding(.horizontal, .x6)
          .accessibilityHidden(true)

        Divider()

        LazyVStack {
          PresentationRequestClaimList(compatibleCredential.requestClaims)
            .padding(.leading, .x6)
        }
      }
      .accessibilityElement(children: .contain)
      .accessibilityLabel(L10n.credentialOfferContentSectionTitle)
      .accessibilitySortPriority(10)

      footerButtons()
        .padding(.x6)
        .accessibilityElement(children: .contain)
    }
    .accessibilityElement(children: .contain)
  }

  @ViewBuilder
  private func footerButtons() -> some View {
    if viewModel.isLoading {
      VStack {
        ProgressView()
          .controlSize(.large)
      }
    } else {
      VStack {
        ButtonStackView {
          Button { Task { await viewModel.send(event: .deny) } } label: {
            Label(L10n.credentialOfferRefuseButton, systemImage: "xmark")
              .if(!sizeCategory.isAccessibilityCategory, transform: {
                $0.multilineTextAlignment(.center)
                  .lineLimit(1)
              })
              .frame(maxWidth: .infinity)
              .minimumScaleFactor(0.5)
              .lineLimit(1)
          }
          .buttonStyle(.filledPrimary)
          .controlSize(.large)
          .accessibilityLabel(L10n.credentialOfferRefuseButton)
          .accessibilitySortPriority(50)

          Button { Task { await viewModel.send(event: .submit) } } label: {
            Label(L10n.credentialOfferAcceptButton, systemImage: "checkmark")
              .if(!sizeCategory.isAccessibilityCategory, transform: {
                $0.multilineTextAlignment(.center)
                  .lineLimit(1)
              })
              .frame(maxWidth: .infinity)
              .minimumScaleFactor(0.5)
              .lineLimit(1)
          }
          .buttonStyle(.filledSecondary)
          .controlSize(.large)
          .accessibilityLabel(L10n.credentialOfferAcceptButton)
          .accessibilitySortPriority(100)
        }
      }
    }
  }

  @ViewBuilder
  private func trustHeader() -> some View {
    if let verifierDisplay = viewModel.verifierDisplay {
      let name = verifierDisplay.name ?? L10n.presentationVerifierNameUnknown

      if let imageData = verifierDisplay.logo {
        TrustHeaderView(name: name, trustStatus: verifierDisplay.trustStatus, subtitle: L10n.tkGlobalCheckcredential, imageData: imageData)
      } else if let imageUri = verifierDisplay.logoUri {
        TrustHeaderView(name: name, trustStatus: verifierDisplay.trustStatus, subtitle: L10n.tkGlobalCheckcredential, imageUrl: imageUri)
      }
    }
  }
}

#if DEBUG
#Preview {
  PresentationRequestReviewView(context: .Mock.vcSdJwtSample, router: PresentationRouter())
}
#endif
