import BITCredential
import BITTheming
import Foundation
import SwiftUI

public struct CredentialOfferClaimListView: View {

  // MARK: Lifecycle

  public init(_ claims: [CredentialDetailBody.Claim]) {
    self.claims = claims
  }

  // MARK: Public

  public var body: some View {
    ForEach(Array(zip(claims.indices, claims)), id: \.0) { index, claim in
      VStack(alignment: .leading, spacing: 0) {
        if let imageData = claim.imageData {
          KeyValueCustomCell(key: claim.key) {
            Image(data: imageData)?
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: Constants.imageMaxWidth, maxHeight: Constants.imageMaxHeight)
              .accessibilityLabel("Image")
          }
          .padding(.vertical, .x2)
          .padding(.trailing, .x6)
        } else {
          KeyValueCell(key: claim.key, value: claim.value)
            .padding(.vertical, .x2)
            .padding(.trailing, .x6)
        }

        Divider()
          .opacity(index != claims.count - 1 ? 1 : 0)
          .foregroundColor(ThemingAssets.Background.secondary.swiftUIColor)
      }
    }

  }

  // MARK: Private

  private enum Constants {
    static let imageMaxWidth: CGFloat = 120
    static let imageMaxHeight: CGFloat = 101
  }

  private var claims: [CredentialDetailBody.Claim]

}
