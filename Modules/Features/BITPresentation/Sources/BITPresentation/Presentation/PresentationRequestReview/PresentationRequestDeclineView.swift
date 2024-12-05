import BITL10n
import BITTheming
import SwiftUI

struct PresentationRequestDeclineView: View {

  // MARK: Lifecycle

  init(onComplete: @escaping () -> Void) {
    self.onComplete = onComplete
  }

  // MARK: Internal

  var onComplete: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: .x6) {
      Assets.qrCode.swiftUIImage
      Text(L10n.presentationDeclinedTitle)
        .font(.custom.title)
      Text(L10n.presentationDeclinedMessage)

      Spacer()

      Button {
        onComplete()
      } label: {
        Label(L10n.globalBackHome, systemImage: "arrow.backward")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bezeledLight)
    }
    .padding(.x4)
  }
}
