import BITCredentialShared
import BITTheming
import SDWebImageSwiftUI
import SwiftUI

// MARK: - TrustHeaderView

public struct TrustHeaderView: View {

  // MARK: Lifecycle

  public init(name: String, trustStatus: TrustStatus, subtitle: String, imageData: Data?) {
    self.name = name
    self.imageData = imageData
    self.trustStatus = trustStatus
    self.subtitle = subtitle
  }

  public init(name: String, trustStatus: TrustStatus, subtitle: String, imageUrl: URL?) {
    self.name = name
    self.imageUrl = imageUrl
    self.trustStatus = trustStatus
    self.subtitle = subtitle
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading, spacing: .x4) {
      HStack(alignment: .top, spacing: .x4) {

        if !sizeCategory.isAccessibilityCategory {
          if let imageData {
            image(imageData)
          } else if let imageUrl {
            webImage(imageUrl)
          }
        }

        VStack(alignment: .leading, spacing: 0) {
          Text(name)
            .lineSpacing(Self.lineSpacing)
            .font(.custom.title3Emphasized)
            .foregroundStyle(ThemingAssets.Label.primary.swiftUIColor)
            .accessibilityLabel(name)

          HStack(alignment: .center, spacing: .x1) {
            trustStatus.icon
            Text(trustStatus.description)
              .font(.custom.body)
              .foregroundStyle(trustStatus.color)
              .accessibilityLabel(trustStatus.description)
          }
        }

        Spacer()
      }

      Text(subtitle)
        .font(.custom.title3)
        .foregroundStyle(ThemingAssets.Label.secondary.swiftUIColor)
        .accessibilityLabel(subtitle)
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(name) \(subtitle)")
    .accessibilityAddTraits(.isHeader)
  }

  // MARK: Internal

  @Environment(\.sizeCategory) var sizeCategory

  // MARK: Private

  private static let lineSpacing: CGFloat = -10
  private static let circleSize: CGFloat = 48
  private static let imageMaxSize: CGFloat = 30
  private static let webImageSize: CGFloat = 50

  private let name: String
  private var imageData: Data? = nil
  private var imageUrl: URL? = nil
  private let subtitle: String
  private let trustStatus: TrustStatus
}

// MARK: - Components

extension TrustHeaderView {

  @ViewBuilder
  private func webImage(_ imageUri: URL) -> some View {
    Circle()
      .fill(ThemingAssets.Background.secondary.swiftUIColor)
      .overlay(
        WebImage(url: imageUri)
          .resizable()
          .placeholder {
            Rectangle().foregroundColor(.gray)
          }
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: Self.imageMaxSize, maxHeight: Self.imageMaxSize)
          .padding(.x1)
      )
      .frame(width: Self.circleSize, height: Self.circleSize)
  }

  @ViewBuilder
  private func image(_ imageData: Data) -> some View {
    let image = Image(data: imageData) ?? Image(systemName: "circle.fill")

    Circle()
      .fill(ThemingAssets.Background.secondary.swiftUIColor)
      .overlay(
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: Self.imageMaxSize, maxHeight: Self.imageMaxSize)
          .padding(.x1)
      )
      .frame(width: Self.circleSize, height: Self.circleSize)
  }
}
