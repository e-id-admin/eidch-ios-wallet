import SwiftUI

// MARK: - ApplyScrollViewIfNeededViewModifier

public struct ApplyScrollViewIfNeededViewModifier: ViewModifier {
  let axis: Axis.Set
  let showsIndicators: Bool

  init(axis: Axis.Set, showsIndicators: Bool) {
    self.axis = axis
    self.showsIndicators = showsIndicators
  }

  public func body(content: Content) -> some View {
    ViewThatFits(in: axis) {
      content
      ScrollView(axis, showsIndicators: showsIndicators) {
        content
      }
    }
  }
}

extension View {
  public func applyScrollViewIfNeeded(_ axis: Axis.Set = .vertical, showsIndicators: Bool = false) -> some View {
    modifier(ApplyScrollViewIfNeededViewModifier(axis: axis, showsIndicators: showsIndicators))
  }
}
