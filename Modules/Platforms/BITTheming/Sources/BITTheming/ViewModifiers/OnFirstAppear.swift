import SwiftUI

// MARK: - OnFirstAppear

public struct OnFirstAppear: ViewModifier {
  let perform: () -> Void

  @State public var hasAppeared = false

  public func body(content: Content) -> some View {
    content.onAppear {
      if !hasAppeared {
        hasAppeared.toggle()
        perform()
      }
    }
  }
}

extension View {
  public func onFirstAppear(perform: @escaping () -> Void) -> some View {
    modifier(OnFirstAppear(perform: perform))
  }
}
