import BITTheming
import Foundation
import SwiftUI

struct DotView: View {

  // MARK: Internal

  enum Defaults {
    static let strokeBorderWidth: CGFloat = 2
    static let frameWidth: CGFloat = 18
    static let circleFrameWidth: CGFloat = 14
    static let maxScale: CGFloat = 2
    static let minScale: CGFloat = 1
    static let animation = Animation.interpolatingSpring(stiffness: 750, damping: 20)
  }

  var isActive = false

  var body: some View {
    ZStack {
      Circle()
        .strokeBorder(ThemingAssets.Brand.Core.white.swiftUIColor, lineWidth: Defaults.strokeBorderWidth)
        .background(Circle().foregroundColor(isActive ? ThemingAssets.Brand.Core.white.swiftUIColor : Color.clear))
        .foregroundColor(.blue)
        .frame(width: Defaults.circleFrameWidth)
        .scaleEffect(scale ? Defaults.maxScale : Defaults.minScale)
    }
    .frame(width: Defaults.frameWidth)
    .onChange(of: isActive, perform: { newValue in
      withAnimation(Defaults.animation) {
        scale = newValue
      }
    })
  }

  // MARK: Private

  @State private var scale = false
}
