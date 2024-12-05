import SwiftUI

// MARK: - KeyPad

public struct KeyPad: View {

  // MARK: Lifecycle

  public init(string: Binding<String>) {
    _string = string
  }

  // MARK: Public

  @Binding public var string: String

  public var body: some View {
    VStack {
      KeyPadRow(keys: [.one, .two, .three])
      KeyPadRow(keys: [.four, .five, .six])
      KeyPadRow(keys: [.seven, .eight, .nine])
      KeyPadRow(keys: [leftKey.key, .zero, rightKey.key])
    }
    .environment(\.keyPadPressed, keyPressed(_:))
  }

  // MARK: Private

  @Environment(\.keyPadLeftKey) private var leftKey: KeyPadKeyTuple
  @Environment(\.keyPadRightKey) private var rightKey: KeyPadKeyTuple

  private func keyPressed(_ key: KeyPadKey) {
    switch key {
    case .delete:
      string = ""
    case leftKey.key:
      leftKey.handler?()
    case rightKey.key:
      rightKey.handler?()
    default:
      string += key.value ?? ""
    }
  }

}

// MARK: - KeyPadLeftEnvironmentKey

struct KeyPadLeftEnvironmentKey: EnvironmentKey {
  static var defaultValue: KeyPadKeyTuple = (.none, nil)
}

// MARK: - KeyPadRightEnvironmentKey

struct KeyPadRightEnvironmentKey: EnvironmentKey {
  static var defaultValue: KeyPadKeyTuple = (.delete, nil)
}

typealias KeyPadKeyTuple = (key: KeyPadKey, handler: (() -> Void)?)

extension EnvironmentValues {
  var keyPadLeftKey: KeyPadKeyTuple {
    get { self[KeyPadLeftEnvironmentKey.self] }
    set { self[KeyPadLeftEnvironmentKey.self] = newValue }
  }

  var keyPadRightKey: KeyPadKeyTuple {
    get { self[KeyPadRightEnvironmentKey.self] }
    set { self[KeyPadRightEnvironmentKey.self] = newValue }
  }
}

extension View {
  public func keyPadLeftKey(_ key: KeyPadKey = .none, _ onTap: (() -> Void)? = nil) -> some View {
    environment(\.keyPadLeftKey, (key, onTap))
  }

  public func keyPadRightKey(_ key: KeyPadKey = .none, _ onTap: (() -> Void)? = nil) -> some View {
    environment(\.keyPadRightKey, (key, onTap))
  }
}
