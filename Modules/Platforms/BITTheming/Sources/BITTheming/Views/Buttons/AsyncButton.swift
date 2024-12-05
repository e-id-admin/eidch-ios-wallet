import SwiftUI

// MARK: - AsyncButton

@MainActor
public struct AsyncButton<Label: View>: View {

  // MARK: Lifecycle

  public init(
    action: @escaping () async -> Void,
    actionOptions: Set<ActionOption> = Set(ActionOption.allCases),
    phase: Binding<AsyncButtonPhase> = .constant(.none),
    @ViewBuilder label: @escaping () -> Label)
  {
    self.action = action
    self.actionOptions = actionOptions
    _phase = phase
    self.label = label
  }

  // MARK: Public

  public var body: some View {
    Button(
      action: {
        if actionOptions.contains(.disableButton) {
          isDisabled = true
        }

        Task {
          var progressViewTask: Task<Void, Error>?

          if actionOptions.contains(.showProgressView) {
            progressViewTask = Task {
              try await Task.sleep(nanoseconds: 150_000_000)
              phase = .loading
            }
          }

          await action()
          progressViewTask?.cancel()

          showProgressView = false

          if phase != .error {
            phase = .done
          }

          try await Task.sleep(nanoseconds: 1_500_000_000)
          phase = .none
          isDisabled = false
        }
      },
      label: {
        VStack {
          switch phase {
          case .done:
            Image(systemName: "checkmark.circle")
          case .error:
            Image(systemName: "xmark.circle")
          case .loading:
            ProgressView()
          case .none:
            label()
          }
        }
      })
      .animation(.default, value: phase)
      .disabled(isDisabled)
  }

  // MARK: Internal

  @Binding var phase: AsyncButtonPhase

  var action: () async -> Void
  var actionOptions = Set(ActionOption.allCases)

  @ViewBuilder var label: () -> Label

  // MARK: Private

  @State private var isDisabled = false
  @State private var showProgressView = false

}

// MARK: AsyncButton.ActionOption

extension AsyncButton {
  public enum ActionOption: CaseIterable {
    case disableButton
    case showProgressView
    case handleError
  }
}

// MARK: - AsyncButtonPhase

public enum AsyncButtonPhase: Equatable {
  case none
  case loading
  case done
  case error
}
