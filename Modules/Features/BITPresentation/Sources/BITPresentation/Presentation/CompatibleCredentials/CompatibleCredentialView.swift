import BITCredential
import BITL10n
import BITTheming
import Factory
import SwiftUI

public struct CompatibleCredentialView: View {

  // MARK: Lifecycle

  public init(
    context: PresentationRequestContext,
    inputDescriptorId: String,
    compatibleCredentials: [CompatibleCredential],
    router: PresentationRouterRoutes)
  {
    _viewModel = StateObject(wrappedValue: Container.shared.compatibleCredentialViewModel((context, inputDescriptorId, compatibleCredentials, router)))
  }

  // MARK: Public

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .x6) {
        trustHeader()
          .padding(.top, .x6)
          .padding(.horizontal)

        VStack(alignment: .leading, spacing: .x2) {
          Text(L10n.presentationSelectCredentialTitle)
            .font(.custom.title)
          Text(L10n.presentationSelectCredentialSubtitle)
        }
        .padding(.horizontal)

        VStack(spacing: .x4) {
          CompatibleCredentialListView(credentials: viewModel.compatibleCredentials) { credential in
            viewModel.didSelect(credential: credential)
          }
        }
        .padding(.bottom, listBottomPadding)
      }
    }
  }

  // MARK: Internal

  @StateObject var viewModel: CompatibleCredentialViewModel

  // MARK: Private

  @State private var listBottomPadding: CGFloat = 0

  @ViewBuilder
  private func trustHeader() -> some View {
    if let verifierDisplay = viewModel.verifierDisplay {
      let name = verifierDisplay.name ?? L10n.presentationVerifierNameUnknown

      if let imageData = verifierDisplay.logo {
        TrustHeaderView(name: name, trustStatus: verifierDisplay.trustStatus, subtitle: L10n.tkPresentMultiplecredentialsTitle, imageData: imageData)
      } else if let imageUri = verifierDisplay.logoUri {
        TrustHeaderView(name: name, trustStatus: verifierDisplay.trustStatus, subtitle: L10n.tkPresentMultiplecredentialsTitle, imageUrl: imageUri)
      }
    }
  }

}
