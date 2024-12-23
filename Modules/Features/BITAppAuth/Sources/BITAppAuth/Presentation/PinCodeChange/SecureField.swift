import BITTheming
import Foundation
import SwiftUI

public struct SecureField: View {

  // MARK: Lifecycle

  public init(text: Binding<String>, prompt: String, submitLabel: SubmitLabel = .done, onSubmit: @escaping () -> Void) {
    _text = text
    self.prompt = prompt
    self.submitLabel = submitLabel
    self.onSubmit = onSubmit
  }

  // MARK: Public

  public var body: some View {
    SecureTextField(text: $text, prompt: prompt) {
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

  var prompt: String
  var onSubmit: () -> Void
  var submitLabel: SubmitLabel

}
