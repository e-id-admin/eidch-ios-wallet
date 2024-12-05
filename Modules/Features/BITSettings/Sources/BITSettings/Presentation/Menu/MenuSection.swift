import SwiftUI

// MARK: - MenuSection

struct MenuSection<Content: View, Header: View>: View {

  // MARK: Lifecycle

  private init(@ViewBuilder _ content: @escaping () -> Content, header: (() -> Header)?) {
    self.content = content
    self.header = header
  }

  // MARK: Internal

  let content: () -> Content
  let header: (() -> Header)?

  var body: some View {
    VStack(spacing: .x3) {
      header?()
        .padding(.bottom, .x2)

      content()
    }
  }

}

extension MenuSection {
  init(@ViewBuilder _ content: @escaping () -> Content, @ViewBuilder header: @escaping () -> Header) {
    self.content = content
    self.header = header
  }

  init(@ViewBuilder content: @escaping () -> Content) where Header == EmptyView {
    self.init(content, header: nil)
  }
}
