import BITCredentialShared
import BITL10n
import BITTheming
import Factory
import Refresher
import SwiftUI

// MARK: - CredentialDetailView

struct CredentialDetailView: View {

  // MARK: Lifecycle

  init(credential: Credential, router: CredentialDetailRouterRoutes) {
    _viewModel = StateObject(wrappedValue: Container.shared.credentialDetailViewModel((credential, router)))
  }

  // MARK: Internal

  var body: some View {
    content()
      .alert(isPresented: $viewModel.isDeleteCredentialAlertPresented) {
        Alert(
          title: Text(L10n.tkDisplaydeleteCredentialdeleteTitle),
          message: Text(L10n.tkDisplaydeleteCredentialdeleteBody),
          primaryButton: .destructive(Text(L10n.tkGlobalDelete), action: {
            Task {
              await viewModel.deleteCredential()
            }
          }),
          secondaryButton: .cancel(Text(L10n.tkGlobalCancel)))
      }
      .navigationBarHidden(true)
      .navigationBarBackButtonHidden()
      .task {
        await viewModel.onAppear()
      }
  }

  // MARK: Private

  @State private var topSafeAreaHeight: CGFloat = 0
  @StateObject private var viewModel: CredentialDetailViewModel

  @Orientation private var orientation

  @ViewBuilder
  private func content() -> some View {
    if orientation.isPortrait {
      portraitLayout()
    } else {
      landscapeLayout()
    }
  }
}

// MARK: - Portrait layout

extension CredentialDetailView {
  private func portraitLayout() -> some View {
    GeometryReader { geometry in
      ScrollView(showsIndicators: false) {
        VStack(spacing: .x10) {
          credentialCard()
            .frame(height: geometry.size.height * 0.8)

          claimsList()
        }
      }
      .refresher {
        await viewModel.refresh()
      }
      .onAppear {
        self.topSafeAreaHeight = geometry.safeAreaInsets.top
      }
      .onChange(of: geometry.safeAreaInsets) { newInsets in
        self.topSafeAreaHeight = newInsets.top
      }
      .padding(.top, -topSafeAreaHeight)
    }
  }
}

// MARK: - Landscape layout

extension CredentialDetailView {
  private func landscapeLayout() -> some View {
    HStack {
      credentialCard()

      ScrollView(showsIndicators: false) {
        claimsList()
      }
      .refresher {
        await viewModel.refresh()
      }
    }
  }
}

// MARK: - Components

extension CredentialDetailView {

  @ViewBuilder
  private func claimsList() -> some View {
    VStack(alignment: .leading, spacing: .x5) {
      VStack(alignment: .leading) {
        Text(L10n.tkDisplaydeleteDisplaycredential1Title2)
          .font(.custom.body)
          .padding(.top, .x4)
          .padding(.leading, .x6)
          .accessibilityLabel(L10n.tkDisplaydeleteDisplaycredential1Title2)
          .accessibilitySortPriority(100)

        Divider()

        LazyVStack {
          ClaimListView(viewModel.credentialBody.claims)
        }
        .padding(.leading, .x6)
      }

      VStack(alignment: .leading) {
        Divider()
        IconKeyValueCell(key: "", value: L10n.tkReceiveIncorrectdataTitle, image: Assets.warning.swiftUIImage, disclosureIndicator: Image(systemName: "chevron.right"), onTap: viewModel.openWrongdata)
          .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
          .padding(.leading, .x6)
      }
    }
    .accessibilityElement(children: .contain)
    .accessibilityLabel(L10n.credentialOfferContentSectionTitle)
    .accessibilitySortPriority(10)
  }

  @ViewBuilder
  private func issuerCell() -> some View {
    if let issuer = viewModel.credential.preferredIssuerDisplay {
      let image = if let image = issuer.image {
        Image(data: image) ?? Image(systemName: "circle.fill")
      } else {
        Image(systemName: "circle.fill")
      }

      HStack(alignment: .top, spacing: .x4) {
        Circle()
          .overlay(
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .padding(.x1)
          )
          .frame(width: 30, height: 30)
          .foregroundColor(ThemingAssets.Background.secondary.swiftUIColor)
          .accessibilityHidden(true)

        VStack(alignment: .leading) {
          HStack(spacing: .x2) {
            Text(issuer.name)
              .font(.custom.body)
              .foregroundColor(ThemingAssets.Label.primary.swiftUIColor)
              .accessibilityLabel(issuer.name)
              .multilineTextAlignment(.leading)
          }
          .padding(.trailing, .x6)
        }

        Spacer()
      }
      .padding(.leading, .x6)

      Divider()
        .padding(.leading, 30 + .x4)
    }
  }

  private func credentialCard() -> some View {
    CredentialCard(viewModel.credential) {
      HStack {
        Menu {
          Section {
            Button(action: viewModel.openWrongdata, label: {
              Label(title: { Text(L10n.tkGlobalWrongdata) }, icon: { Assets.warning.swiftUIImage })
            })
            .accessibilityLabel(L10n.tkGlobalWrongdata)
          }

          Button(role: .destructive, action: {
            viewModel.isDeleteCredentialAlertPresented.toggle()
          }, label: {
            Label(L10n.tkDisplaydeleteCredentialmenuPrimarybutton, systemImage: "trash")
          })
          .accessibilityLabel(L10n.tkDisplaydeleteCredentialmenuPrimarybutton)
        } label: {
          ThemingAssets.elipsis.swiftUIImage
            .foregroundColor(.white)
            .frame(width: 32, height: 32)
            .background(.ultraThickMaterial.opacity(0.70))
            .clipShape(.circle)
            .colorScheme(.dark)
        }
        .accessibilitySortPriority(75)
        .accessibilityLabel(L10n.tkGlobalMoreoptionsAlt)

        Spacer()

        Button(action: viewModel.close, label: {
          ThemingAssets.xmark.swiftUIImage
            .foregroundColor(.white)
            .frame(width: 32, height: 32)
            .background(.ultraThickMaterial.opacity(0.70))
            .clipShape(.circle)
            .colorScheme(.dark)
        })
        .accessibilityLabel(L10n.tkGlobalCloseelfaAlt)
        .accessibilitySortPriority(50)
      }
      .padding(.top, self.topSafeAreaHeight)
    }
    .controlSize(.large)
  }
}

#if DEBUG
#Preview {
  CredentialDetailView(credential: .Mock.sample, router: CredentialDetailRouter())
}
#endif
