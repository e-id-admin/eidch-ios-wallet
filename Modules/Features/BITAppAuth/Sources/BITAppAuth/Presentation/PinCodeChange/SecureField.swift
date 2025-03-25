import BITTheming
import Foundation
import SwiftUI

public struct SecureField: View {

  // MARK: Lifecycle

  public init(
    text: Binding<String>,
    prompt: String,
    submitLabel: SubmitLabel = .done,
    onSubmit: @escaping () -> Void,
    textColor: UIColor? = nil,
    tintColor: UIColor)
  {
    _text = text
    self.prompt = prompt
    self.submitLabel = submitLabel
    self.onSubmit = onSubmit
    self.textColor = textColor
    self.tintColor = tintColor
  }

  // MARK: Public

  public var body: some View {
    SecureTextField(text: $text, prompt: prompt, textColor: textColor, tintColor: tintColor) {
      onSubmit()
    }
    .submitLabel(submitLabel)
    .frame(height: 52)
    .padding(.horizontal, .x3)
    .background(ThemingAssets.Background.primary.swiftUIColor)
    .cornerRadius(10)
  }

  // MARK: Internal

  @Binding var text: String

  // MARK: Private

  private var prompt: String
  private var onSubmit: () -> Void
  private var submitLabel: SubmitLabel
  private let tintColor: UIColor
  private let textColor: UIColor?

}
