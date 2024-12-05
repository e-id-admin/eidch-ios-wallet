import Foundation
import SwiftUI

public struct LabelBadge: View {

  // MARK: Lifecycle

  public init(
    text: String,
    textAlt: String? = nil,
    backgroundColor: Color? = nil,
    backgroundMaterial: Material? = nil,
    foregroundColor: Color? = nil,
    image: String? = nil)
  {
    self.text = text
    self.textAlt = textAlt ?? text
    self.backgroundColor = backgroundColor
    self.backgroundMaterial = backgroundMaterial
    self.foregroundColor = foregroundColor
    self.image = image
  }

  // MARK: Public

  public var body: some View {
    HStack {
      if let image {
        Image(systemName: image)
      }

      Text(text)
        .font(.custom.footnote)
        .accessibilityLabel(text)
    }
    .padding(.horizontal, .x4)
    .padding(.vertical, .x2)
    .background(backgroundView())
    .foregroundColor(foregroundColor)
    .clipShape(.rect(cornerRadius: .x6))
    .accessibilityElement(children: .combine)
  }

  // MARK: Private

  private let text: String
  private let textAlt: String
  private let backgroundColor: Color?
  private let backgroundMaterial: Material?
  private let foregroundColor: Color?
  private let image: String?

  @ViewBuilder
  private func backgroundView() -> some View {
    if let backgroundMaterial {
      Rectangle().fill(backgroundMaterial)
    } else if let backgroundColor {
      backgroundColor
    }
  }

}
