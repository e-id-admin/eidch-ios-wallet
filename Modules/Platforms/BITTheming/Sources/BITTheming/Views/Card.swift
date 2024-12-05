import SwiftUI

// MARK: - Card

public struct Card<Content>: View where Content: View {

  // MARK: Lifecycle

  public init(background: CardBackground, @ViewBuilder content: () -> Content) {
    self.content = content()
    lottieView = nil
    image = nil
    self.background = background
  }

  // MARK: Public

  public var body: some View {
    VStack {
      VStack {
        if let lottieView {
          lottieView
            .frame(minWidth: Defaults.minWidthContent, maxWidth: Defaults.maxWidthContent, minHeight: Defaults.minHeightContent, idealHeight: Defaults.maxHeightContent, maxHeight: Defaults.maxHeightContent)
            .colorScheme(colorScheme)
        } else if let content {
          content
            .colorScheme(colorScheme)
        } else if let image {
          image
            .resizable()
            .scaledToFit()
            .frame(minWidth: Defaults.minWidthContent, maxWidth: Defaults.maxWidthContent, minHeight: Defaults.minHeightContent, idealHeight: Defaults.maxHeightContent, maxHeight: Defaults.maxHeightContent)
            .colorScheme(colorScheme)
        }
      }
      .padding(.x8)
    }
    .frame(maxWidth: .infinity, minHeight: Defaults.minHeightCard, idealHeight: Defaults.idealHeightCard, maxHeight: Defaults.maxHeightCard)
    .background(background.view)
    .cornerRadius(.x9)
  }

  // MARK: Internal

  @Environment(\.colorScheme) var colorScheme
  @Environment(\.sizeCategory) var sizeCategory

  // MARK: Private

  private let content: Content?
  private let image: Image?
  private let lottieView: LottieView?
  private let background: CardBackground
}

// MARK: - Defaults

fileprivate enum Defaults {
  static let minWidthContent: CGFloat = 50
  static let maxWidthContent: CGFloat = 120
  static let minHeightContent: CGFloat = 50
  static let maxHeightContent: CGFloat = 180

  static let minHeightCard: CGFloat = 95
  static let maxHeightCard: CGFloat = 355
  static let idealHeightCard: CGFloat = 355
}

extension Card where Content == Image {
  public init(background: CardBackground, imageName: String) {
    image = Image(imageName)
    lottieView = nil
    content = nil
    self.background = background
  }

  public init(background: CardBackground, imageSystemName: String) {
    image = Image(systemName: imageSystemName)
    lottieView = nil
    content = nil
    self.background = background
  }

  public init(background: CardBackground, image: Image) {
    self.image = image
    lottieView = nil
    content = nil
    self.background = background
  }
}

extension Card where Content == LottieView {
  public init(background: CardBackground, lottieView: LottieView) {
    self.lottieView = lottieView
    image = nil
    content = nil
    self.background = background
  }
}

extension Card where Content == EmptyView {

  public init(background: CardBackground) {
    content = nil
    lottieView = nil
    image = nil
    self.background = background
  }

}

// MARK: - CardBackground

public enum CardBackground {
  case color(Color)
  case image(Image)
}

extension CardBackground {
  @ViewBuilder
  var view: some View {
    switch self {
    case .color(let color):
      color
    case .image(let image):
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .clipped()
        .preferredColorScheme(.light)
    }
  }
}
