import SwiftUI

#Preview {
  ScrollView {
    VStack {
      PreviewHeader()

      ScrollView(.horizontal) {
        HStack(spacing: .x5) {
          Card(background: .color(ThemingAssets.accentColor.swiftUIColor), lottieView: Lotties.lottieBlocks)
            .frame(width: 210, height: 200)
          Card(background: .color(ThemingAssets.gray3.swiftUIColor), image: ThemingAssets.noInternet.swiftUIImage)
            .frame(width: 210, height: 200)
          Card(background: .color(ThemingAssets.red2.swiftUIColor)) {
            PlaceholderIcon()
              .foregroundStyle(ThemingAssets.primaryReversed.swiftUIColor)
              .frame(width: 70, height: 70)
          }.frame(width: 210, height: 200)
        }
      }.padding(.bottom, .x5)

      Card(background: .image(ThemingAssets.Gradient.gradient1.swiftUIImage), lottieView: Lotties.lottieBlocks)
        .padding(.bottom, .x5)

      Card(background: .color(ThemingAssets.red2.swiftUIColor), image: ThemingAssets.noInternet.swiftUIImage)
        .padding(.bottom, .x5)

      Card(background: .color(ThemingAssets.accentColor.swiftUIColor)) {
        PlaceholderIcon()
          .foregroundStyle(ThemingAssets.primaryReversed.swiftUIColor)
      }
      .frame(height: 355)
      .padding(.bottom, .x5)
    }
  }

}

// MARK: - PreviewHeader

fileprivate struct PreviewHeader: View {
  fileprivate var body: some View {
    VStack(alignment: .leading) {
      Text("Card")
        .font(.custom.title)
        .padding(0)
      VStack(alignment: .leading, spacing: 0) {
        Rectangle()
          .frame(height: 0.5)
          .foregroundColor(Color(red: 0.14, green: 0.14, blue: 0.14))
        Text("Component")
          .font(.custom.footnote)
          .padding(.top, .x2)
      }
      .padding(.bottom, .x5)
    }
    .padding(EdgeInsets(top: .x10, leading: .x10, bottom: 0, trailing: .x10))
  }
}

// MARK: - PlaceholderIcon

fileprivate struct PlaceholderIcon: View {
  fileprivate var body: some View {
    Image(systemName: "star")
      .resizable()
      .font(.system(size: 10, weight: .light))
  }
}
