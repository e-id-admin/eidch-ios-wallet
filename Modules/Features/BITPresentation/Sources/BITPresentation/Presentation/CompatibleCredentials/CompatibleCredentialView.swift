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
    List {
      VStack {
        trustHeader()
          .padding(.top, .x3)
      }
      .listRowSeparator(.hidden)

      VStack(alignment: .leading) {
        Text(L10n.tkPresentMultiplecredentialsTitle)
          .font(.custom.body)
          .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
          .padding(.bottom, .x1)
        Divider()
          // Stretch the divider to the whole width of the screen (-100 for landscape on trailing)
          .padding(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: -100))
      }
      .padding(.top, .x3)
      .listRowSeparator(.hidden)

      Section {
        CompatibleCredentialListView(credentials: viewModel.compatibleCredentials) { credential in
          viewModel.didSelect(credential: credential)
        }
      }
      .listSectionSeparator(.hidden, edges: .top)
    }
    .navigationBarHidden(true)
    .listStyle(.plain)
    .safeAreaInset(edge: .bottom) {
      footer()
    }
  }

  // MARK: Internal

  @StateObject var viewModel: CompatibleCredentialViewModel

  // MARK: Private

  @Environment(\.sizeCategory) private var sizeCategory

  @State private var listBottomPadding: CGFloat = 0

  @ViewBuilder
  private func footer() -> some View {
    FooterView {
      Spacer()

      Button(action: { viewModel.close() }) {
        Label(L10n.tkGlobalCancelPrimarybutton, systemImage: "xmark")
          .lineLimit(1)
          .if(sizeCategory.isAccessibilityCategory) {
            $0.frame(maxWidth: .infinity)
          }
      }
      .buttonStyle(.filledPrimary)
      .controlSize(.large)

      Spacer()
    }
  }

  @ViewBuilder
  private func trustHeader() -> some View {
    if let verifierDisplay = viewModel.verifierDisplay {
      ActorHeaderView(verifier: verifierDisplay)
    }
  }

}
