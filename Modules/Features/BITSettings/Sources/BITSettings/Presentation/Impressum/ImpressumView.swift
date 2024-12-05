import BITL10n
import BITTheming
import SwiftUI

// MARK: - ImpressumView

public struct ImpressumView: View {

  // MARK: Lifecycle

  public init() {
    _viewModel = StateObject(wrappedValue: ImpressumViewModel())
  }

  // MARK: Public

  public var body: some View {
    ScrollView {
      Content()
        .padding(.x4)
    }
    .font(.custom.body)
    .navigationTitle(L10n.impressumTitle)
  }

  // MARK: Private

  @StateObject private var viewModel: ImpressumViewModel

  @ViewBuilder
  private func Content() -> some View {
    VStack(alignment: .leading, spacing: .x8) {
      Header()
      AppVersion()
      Informations()
    }
  }

  @ViewBuilder
  private func Header() -> some View {
    Assets.impresum.swiftUIImage
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(maxHeight: 300)
    Text(L10n.impressumHeaderText)
      .multilineTextAlignment(.leading)
  }

  @ViewBuilder
  private func AppVersion() -> some View {
    MenuSection {
      SideNoteMenuCell(text: L10n.impressumBuildNumber, sidenote: viewModel.buildNumber)
      SideNoteMenuCell(text: L10n.impressumAppVersion, sidenote: viewModel.appVersion)
        .hasDivider(false)
    }
  }

  @ViewBuilder
  private func Informations() -> some View {
    VStack(alignment: .leading, spacing: .x6) {
      if let url = URL(string: L10n.impressumGithubLink) {
        Link(destination: url, label: {
          LinkText(L10n.impressumGithubLinkText)
            .multilineTextAlignment(.leading)
        })
      }

      VStack(alignment: .leading, spacing: .x2) {
        Text(L10n.impressumManagerTitle)
          .font(.headline)
          .multilineTextAlignment(.leading)

        Assets.confederation.swiftUIImage
      }
      .padding(.bottom, .x4)

      if let url = URL(string: L10n.impressumMoreInformationLink) {
        VStack(alignment: .leading, spacing: .x2) {
          Text(L10n.impressumMoreInformationTitle)
            .font(.headline)

          Link(destination: url, label: {
            LinkText(L10n.impressumMoreInformationLinkText)
              .multilineTextAlignment(.leading)
          })
        }
      }

      if let url = URL(string: L10n.impressumLegalsLink) {
        VStack(alignment: .leading, spacing: .x2) {
          Text(L10n.impressumLegalsTitle)
            .font(.headline)

          Link(destination: url, label: {
            LinkText(L10n.impressumLegalsLinkText)
              .multilineTextAlignment(.leading)
          })
        }
      }

      VStack(alignment: .leading, spacing: .x2) {
        Text(L10n.impressumDisclaimerTitle)
          .font(.headline)
        Text(L10n.impressumDisclaimerText)
          .multilineTextAlignment(.leading)
      }
    }
  }
}

#Preview {
  ImpressumView()
}
