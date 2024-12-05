import BITTheming
import SwiftUI

struct MenuHeader: View {

  // MARK: Lifecycle

  init(image: String, text: String) {
    self.image = Image(systemName: image)
    self.text = Text(text)
  }

  // MARK: Internal

  var body: some View {
    HStack(alignment: .center, spacing: .x4) {
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 12)
        .padding(.x3)
        .background(ThemingAssets.gray4.swiftUIColor)
        .clipShape(Circle())
      text
        .font(.custom.headline)

      Spacer()
    }
  }

  // MARK: Private

  private let image: Image
  private let text: Text

}

#Preview {
  MenuHeader(image: "trash", text: "Text")
}
