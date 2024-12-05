import BITCredential
import BITCredentialShared
import BITTheming
import Foundation
import SwiftUI

// MARK: - CompatibleCredentialListView

public struct CompatibleCredentialListView: View {

  // MARK: Lifecycle

  public init(credentials: [CompatibleCredential] = [], _ didSelect: @escaping (CompatibleCredential) -> Void) {
    self.credentials = credentials
    self.didSelect = didSelect
  }

  // MARK: Public

  public var body: some View {
    ForEach(Array(zip(credentials.indices, credentials)), id: \.0) { index, compatibleCredential in
      VStack(spacing: .x4) {
        cell(for: compatibleCredential.credential)
          .contentShape(Rectangle())
          .onTapGesture {
            didSelect(compatibleCredential)
          }
        if index != credentials.count - 1 {
          separator()
        }
      }
    }
    .font(.custom.body)
    .padding(.horizontal, .x4)
  }

  // MARK: Private

  private var credentials: [CompatibleCredential] = []
  private var didSelect: (CompatibleCredential) -> Void
}

extension CompatibleCredentialListView {

  @ViewBuilder
  private func cell(for credential: Credential) -> some View {
    HStack(spacing: .x4) {
      CredentialCard(credential).controlSize(.small)

      VStack(alignment: .leading) {
        if let name = credential.preferredDisplay?.name {
          Text(name)
            .font(.custom.subheadline)
        }
        if let summary = credential.preferredDisplay?.summary {
          Text(summary)
            .font(.custom.footnote)
        }
        CredentialStatusLabel(status: credential.status)
      }

      Spacer()

      Image(systemName: "chevron.right")
    }
  }

  @ViewBuilder
  private func separator() -> some View {
    Rectangle()
      .frame(height: 1)
      .foregroundColor(ThemingAssets.gray3.swiftUIColor)
  }

}
