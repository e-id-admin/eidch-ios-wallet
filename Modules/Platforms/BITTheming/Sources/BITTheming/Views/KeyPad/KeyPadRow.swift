import SwiftUI

public struct KeyPadRow: View {
  var keys: [KeyPadKey]

  public init(keys: [KeyPadKey]) {
    self.keys = keys
  }

  public var body: some View {
    HStack {
      ForEach(keys, id: \.self) { key in
        KeyPadButton(key: key)
      }
    }
  }
}
