import BITCredentialShared
import BITTheming
import Foundation
import SwiftUI

public struct PresentationRequestClaimList: View {

  // MARK: Lifecycle

  init(_ claims: [CredentialClaim]) {
    self.claims = claims
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading) {
      ForEach(Array(zip(claims.indices, claims)), id: \.0) { index, claim in
        HStack {
          VStack(alignment: .leading, spacing: 0) {
            if let imageData = claim.imageData {
              KeyValueCustomCell(key: claim.preferredDisplay?.name ?? claim.key) {
                Image(data: imageData)?
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(maxWidth: 250, maxHeight: 400)
              }
              .padding(.vertical, .x2)
            } else {
              KeyValueCell(key: claim.preferredDisplay?.name ?? claim.key, value: claim.value)
                .padding(.vertical, .x2)
            }

            if index != claims.count - 1 {
              Rectangle()
                .frame(height: 1)
                .foregroundColor(ThemingAssets.gray3.swiftUIColor)
            }
          }

          Spacer()
        }
      }
    }
    .frame(maxWidth: .infinity)
  }

  // MARK: Private

  private var claims: [CredentialClaim]

}
