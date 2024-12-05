import BITCore
import BITL10n
import SwiftUI

// MARK: - SetupView

public struct SetupView: View {

  // MARK: Lifecycle

  public init(_ title: String, text: String) {
    self.title = title
    self.text = text
  }

  // MARK: Public

  public var body: some View {
    VStack {
      Spacer ()

      HStack {
        Spacer()
        ProgressView()
        Spacer()
      }
      .padding(.bottom, .x10)

      Text(text)
        .multilineTextAlignment(.leading)

      Spacer()
    }
    .transition(.opacity)
    .navigationTitle(title)
  }

  // MARK: Private

  private var text: String
  private var title: String
}

// MARK: - SetupView_Previews

struct SetupView_Previews: PreviewProvider {
  static var previews: some View {
    SetupView(L10n.storageSetupTitle, text: L10n.storageSetupText)
  }
}
