import BITCredential
import BITCredentialShared
import BITInvitation
import BITL10n
import BITSettings
import BITTheming
import Factory
import Foundation
import SwiftUI

// MARK: - HomeComposerView

public struct HomeComposerView: View {

  // MARK: Lifecycle

  public init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  @StateObject public var viewModel: HomeViewModel

  public var body: some View {
    content()
      .onAppear {
        UIAccessibility.post(notification: .screenChanged, argument: L10n.tkHomeHomescreenAlt)
        Task {
          await viewModel.send(event: .refresh)
        }
      }
      .accessibilityAction(named: L10n.tkGlobalScanPrimarybutton, {
        viewModel.openScanner()
      })
      .accessibilityAction(named: L10n.tkGlobalMoreoptionsAlt, {
        focus = .menu
      })
  }

  // MARK: Private

  private enum FocusableElement: Hashable {
    case scan, menu, list, emptyState, error
  }

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @Environment(\.sizeCategory) private var sizeCategory
  @Environment(\.accessibilityVoiceOverEnabled) private var isVoiceOverEnabled

  @AccessibilityFocusState
  private var focus: FocusableElement?

  @ViewBuilder
  private func content() -> some View {
    switch (horizontalSizeClass, verticalSizeClass) {
    case (.compact, .regular):
      portraitLayout()
    default:
      landscapeLayout()
    }
  }

}

// MARK: - Components

extension HomeComposerView {

  @ViewBuilder
  private func mainContent() -> some View {
    VStack {
      switch viewModel.state {
      case .results:
        credentialsList()
          .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor, ThemingAssets.Label.primary.swiftUIColor)
          .accessibilityFocused($focus, equals: .list)
          .accessibilitySortPriority(10)
      case .error:
        errorView()
      case .empty:
        emptyView()
      }

      NavigationLink(destination: PrivacyView(), isActive: $viewModel.isSecurityPresented) {
        EmptyView()
      }

      NavigationLink(destination: ImpressumView(), isActive: $viewModel.isImpressumPresented) {
        EmptyView()
      }

      NavigationLink(destination: LicencesListView(), isActive: $viewModel.isLicensesPresented) {
        EmptyView()
      }
    }
    .safeAreaInset(edge: .bottom) {
      if !isLandscape {
        portraitFooter()
      }
    }
  }

  @ViewBuilder
  private func emptyView() -> some View {
    if #available(iOS 16, *) {
      ViewThatFits(in: .vertical) {
        VStack {
          Spacer()
          CredentialsEmptyStateView()
            .padding(.horizontal, .x6)
          Spacer()
        }

        ScrollView {
          CredentialsEmptyStateView()
            .padding(.horizontal, .x6)
        }
      }
    } else {
      ScrollView {
        CredentialsEmptyStateView()
          .padding(.horizontal, .x6)
      }
    }
  }

  @ViewBuilder
  private func errorView() -> some View {
    if #available(iOS 16, *) {
      ViewThatFits(in: .vertical) {
        VStack {
          Spacer()
          EmptyStateView(.error(error: viewModel.stateError)) { Text("Refresh") } action: { await viewModel.send(event: .refresh) }
            .padding(.horizontal, .x6)
          Spacer()
        }

        ScrollView {
          EmptyStateView(.error(error: viewModel.stateError)) { Text("Refresh") } action: { await viewModel.send(event: .refresh) }
            .padding(.horizontal, .x6)
        }
      }
    } else {
      ScrollView {
        EmptyStateView(.error(error: viewModel.stateError)) { Text("Refresh") } action: { await viewModel.send(event: .refresh) }
          .padding(.horizontal, .x6)
      }
    }
  }

  @ViewBuilder
  private func menuButton() -> some View {
    Menu {
      Section {
        Button { viewModel.openSecurity() } label: { Label(L10n.settingsSecurity, systemImage: "lock") }
      }
      Section {
        Button { viewModel.openSettings() } label: { Label(L10n.settingsLanguage, systemImage: "globe") }

        Button { viewModel.openHelp() } label: { Label(L10n.settingsHelp, systemImage: "questionmark.circle") }

        Button { viewModel.openContact() } label: { Label(L10n.settingsContact, systemImage: "envelope") }
      }
      Section {
        Button { viewModel.openImpressum() } label: { Label(L10n.settingsImpressum, systemImage: "info.circle") }

        Button { viewModel.openLicenses() } label: { Label(L10n.settingsLicences, systemImage: "doc") }
      }
    } label: {
      HomeAssets.menuButton.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 60)
        .accessibilityHidden(true)
    }
    .accessibilityLabel(L10n.tkGlobalMoreoptionsAlt)
    .accessibilitySortPriority(50)
    .accessibilityFocused($focus, equals: .menu)
    .accessibilityAddTraits(.isButton)
  }

  @ViewBuilder
  private func scannerButton() -> some View {
    if sizeCategory.isAccessibilityCategory || isLandscape {
      Button(action: viewModel.openScanner) {
        HomeAssets.scannerButton.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 60)
      }
      .accessibilityLabel(L10n.tkGlobalScanPrimarybuttonAlt)
      .accessibilitySortPriority(100)
      .accessibilityFocused($focus, equals: .scan)
    } else {
      Button(action: viewModel.openScanner, label: {
        Label(title: { Text(L10n.tkGlobalScanPrimarybutton) }, icon: { Image(systemName: "qrcode") })
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      })
      .buttonStyle(.filledPrimary)
      .accessibilityLabel(L10n.tkGlobalScanPrimarybuttonAlt)
      .accessibilitySortPriority(100)
      .frame(height: 60)
      .accessibilityFocused($focus, equals: .scan)
    }
  }

  @ViewBuilder
  private func credentialsList() -> some View {
    List(viewModel.credentials) { credential in
      Button(action: { viewModel.openDetail(for: credential) }, label: {
        CredentialCell(credential)
      })
    }
    .listStyle(.plain)
  }
}

// MARK: - Portrait

extension HomeComposerView {
  @ViewBuilder
  private func portraitLayout() -> some View {
    mainContent()
  }

  @ViewBuilder
  private func portraitFooter() -> some View {
    VStack {
      HStack {
        menuButton()
        scannerButton()
      }
      .padding(.horizontal, .x3)
      .padding(.vertical, 10)
    }
    .background(.ultraThinMaterial)
    .clipShape(.capsule)
    .padding(.horizontal, .x6)
    .padding(.vertical, .x4)
  }
}

// MARK: - Landscape

extension HomeComposerView {
  @ViewBuilder
  private func landscapeLayout() -> some View {
    if #available(iOS 16, *) {
      ViewThatFits(in: .vertical) {
        landscapeContentLayout()
        landscapeScrollableContentLayout()
      }
    } else {
      landscapeScrollableContentLayout()
    }
  }

  @ViewBuilder
  private func landscapeContentLayout() -> some View {
    HStack {
      landscapeFooter()
      Spacer()
      mainContent()
    }
  }

  @ViewBuilder
  private func landscapeScrollableContentLayout() -> some View {
    HStack {
      landscapeFooter()

      mainContent()
        .padding(.x4)
    }
    .padding(.vertical, .x4)
  }

  @ViewBuilder
  private func landscapeFooter() -> some View {
    VStack {
      Spacer()
      menuButton()
      scannerButton()
      Spacer()
    }
    .padding(.x4)
    .ignoresSafeArea(edges: .bottom)
  }
}

extension HomeComposerView {
  fileprivate var isLandscape: Bool {
    switch (horizontalSizeClass, verticalSizeClass) {
    case (.compact, .regular): false
    default: true
    }
  }
}

#if DEBUG
#Preview {
  HomeComposerView(viewModel: .init(.results, router: HomeRouter(), credentials: Credential.Mock.array))
}
#endif
