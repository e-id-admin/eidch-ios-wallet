import SwiftUI
import SwiftUIIntrospect

// MARK: - NavigationBackButtonDisplayModeModifier

public struct NavigationBackButtonDisplayModeModifier: ViewModifier {

  private var value: UINavigationItem.BackButtonDisplayMode

  public init(value: UINavigationItem.BackButtonDisplayMode = .default) {
    self.value = value
  }

  public func body(content: Content) -> some View {
    content
      .introspect(.navigationView(style: .stack), on: .iOS(.v14, .v15, .v16, .v17), scope: .ancestor) {
        $0.navigationBar.topItem?.backButtonDisplayMode = value
      }
  }

}

extension View {

  public func navigationBackButtonDisplayMode(_ value: UINavigationItem.BackButtonDisplayMode = .default) -> some View {
    modifier(NavigationBackButtonDisplayModeModifier(value: value))
  }

}
