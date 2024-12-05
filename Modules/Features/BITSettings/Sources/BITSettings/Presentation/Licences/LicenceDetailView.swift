import BITL10n
import SwiftUI

public struct LicenceDetailView: View {

  // MARK: Lifecycle

  public init(package: PackageDependency) {
    self.package = package
  }

  // MARK: Public

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .x6) {
        Text(package.version ?? L10n.licencesNoVersion)
          .font(.custom.headline)
        if let licence = package.license {
          Text(licence)
            .multilineTextAlignment(.leading)
        }
      }
      .padding(.x4)
    }
    .font(.custom.body)
    .navigationTitle(package.name)
    .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Private

  private let package: PackageDependency

}
