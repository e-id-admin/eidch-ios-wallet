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
    ForEach(Array(zip(credentials.indices, credentials)), id: \.0) { _, compatibleCredential in
      Button(action: { didSelect(compatibleCredential) }, label: {
        CredentialCell(compatibleCredential.credential, disclosureIndicator: .navigation)
      })
    }
  }

  // MARK: Private

  private var credentials: [CompatibleCredential] = []
  private var didSelect: (CompatibleCredential) -> Void
}
