import BITL10n
import BITTheming
import Factory
import SwiftUI

// MARK: - LicencesListView

public struct LicencesListView: View {

  // MARK: Lifecycle

  public init() {
    _viewModel = StateObject(wrappedValue: Container.shared.licencesViewModel())
  }

  // MARK: Public

  public var body: some View {
    content()
      .font(.custom.body)
      .onFirstAppear {
        Task { await viewModel.send(event: .fetch) }
      }
      .navigationTitle(L10n.licencesTitle)
  }

  // MARK: Internal

  @StateObject var viewModel: LicencesListViewModel

  // MARK: Private

  @ViewBuilder
  private func content() -> some View {
    VStack {
      switch viewModel.state {
      case .loading:
        ProgressView()

      case .results:
        ScrollView {
          VStack(alignment: .leading, spacing: .x6) {
            header()

            VStack(spacing: .x3) {
              ForEach(viewModel.packages) { package in
                SecondaryMenuCell(primary: package.name, secondary: package.version ?? L10n.licencesNoVersion, disclosureIndicator: .navigation) {
                  Task { await viewModel.send(event: .selectPackage(package)) }
                }
              }
            }
          }
          .padding(.x4)
        }

      case .error:
        EmptyStateView(.error(error: viewModel.stateError)) {}

      case .empty:
        EmptyStateView(.custom(title: nil, message: L10n.licencesEmptyState, image: nil, imageColor: nil)) {}
      }

      if let selectedPackage = viewModel.selectedPackage {
        NavigationLink(destination: LicenceDetailView(package: selectedPackage), isActive: $viewModel.isPackageDetailPresented) {
          EmptyView()
        }
      }

    }
  }

  @ViewBuilder
  private func header() -> some View {
    VStack(alignment: .leading, spacing: .x6) {
      Assets.lizenzen.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 300)

      Text(L10n.licencesText)

      if let url = URL(string: L10n.licencesMoreInformationLink) {
        Link(destination: url) {
          LinkText(L10n.licencesMoreInformationText)
        }
      }
    }
  }

}

#Preview {
  LicencesListView()
}
