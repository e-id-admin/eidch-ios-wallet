import SwiftUI

public struct DefaultInformationFooterView: View {

  // MARK: Lifecycle

  public init(
    primaryButtonLabel: String,
    primaryButtonAction: @escaping (() -> Void),
    secondaryButtonLabel: String? = nil,
    secondaryButtonAction: (() -> Void)? = nil,
    secondaryButtonDisabled: Bool = false)
  {
    self.primaryButtonLabel = primaryButtonLabel
    self.primaryButtonAction = primaryButtonAction
    self.secondaryButtonLabel = secondaryButtonLabel
    self.secondaryButtonAction = secondaryButtonAction
    self.secondaryButtonDisabled = secondaryButtonDisabled
  }

  // MARK: Public

  public var body: some View {
    if secondaryButtonLabel == nil {
      Spacer()
    }

    if let secondaryButtonLabel {
      Button(action: { secondaryButtonAction?() }) {
        Text(secondaryButtonLabel)
          .multilineTextAlignment(.center)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
      }
      .disabled(secondaryButtonDisabled)
      .buttonStyle(.bezeledLight)
      .controlSize(.large)
      .accessibilityIdentifier(AccessibilityIdentifier.secondaryButton.rawValue)
      .accessibilityLabel(secondaryButtonLabel)
    }

    Button(action: { primaryButtonAction() }) {
      Text(primaryButtonLabel)
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .if(sizeCategory.isAccessibilityCategory || secondaryButtonLabel != nil) {
          $0.frame(maxWidth: .infinity)
        }
    }
    .buttonStyle(.filledPrimary)
    .controlSize(.large)
    .accessibilityIdentifier(AccessibilityIdentifier.primaryButton.rawValue)
    .accessibilityLabel(primaryButtonLabel)
  }

  // MARK: Internal

  enum AccessibilityIdentifier: String {
    case primaryButton
    case secondaryButton
  }

  // MARK: Private

  @Environment(\.sizeCategory) private var sizeCategory

  private let primaryButtonLabel: String
  private let primaryButtonAction: () -> Void
  private let secondaryButtonLabel: String?
  private let secondaryButtonAction: (() -> Void)?
  private let secondaryButtonDisabled: Bool

}
