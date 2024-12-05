import BITCore
import BITL10n
import BITTheming
import Foundation
import SwiftUI

// MARK: - BiometricChangeSettingsView

struct BiometricChangeSettingsView: View {

  // MARK: Internal

  var type: BiometricType

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x4) {

          Text(L10n.biometricSetupTitle(type.text))
            .font(.custom.title)
            .multilineTextAlignment(.leading)

          VStack(spacing: .x6) {
            type.image
              .resizable()
              .scaledToFit()
              .frame(width: 125, height: 125)
              .font(.system(size: 12, weight: .ultraLight))
          }
          .frame(maxWidth: .infinity)
          .padding(.x8)
          .background(ThemingAssets.gray4.swiftUIColor)
          .clipShape(.rect(cornerRadius: .x1))

          Text(L10n.biometricSetupContent(type.text))

          HStack(alignment: .top) {
            Image(systemName: "lock")
              .frame(width: .x2, height: .x2)
              .padding(.x3)
              .background(ThemingAssets.gray4.swiftUIColor)
              .clipShape(Circle())
            Text(L10n.biometricSetupReason)
              .font(.custom.footnote)
              .foregroundStyle(ThemingAssets.secondary.swiftUIColor)
          }

          Spacer()
        }
      }

      Button {
        openSettings()
      } label: {
        HStack {
          Text(L10n.biometricSetupNoClass3ToSettingsButton)
          Image(systemName: "arrow.up.right")
        }
        .frame(maxWidth: .infinity)
      }
      .buttonStyle(.filledPrimary)
    }
    .padding(.horizontal, .x4)
    .padding(.bottom, .x4)
  }

  // MARK: Private

  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
