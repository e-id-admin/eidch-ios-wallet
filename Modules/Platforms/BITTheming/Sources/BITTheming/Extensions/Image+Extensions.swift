import Foundation
import SwiftUI

extension Image {

  // MARK: Lifecycle

  public init?(data: Data) {
    guard let image = UIImage(data: data) else { return nil }
    self = Image(uiImage: image)
  }

  // MARK: Public

  public func applyCircleShape(size: CGFloat = 26, padding: CGFloat = .x3, backgroundColor: Color = ThemingAssets.gray4.swiftUIColor) -> some View {
    resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: size, height: size)
      .padding(padding)
      .background(backgroundColor)
      .clipShape(Circle())
  }

}
