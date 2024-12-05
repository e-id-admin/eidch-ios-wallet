import BITL10n
import BITTheming
import Foundation
import SwiftUI

public struct JailbreakView: View {

  public init() {}

  public var body: some View {
    VStack(alignment: .leading, spacing: .x6) {
      Assets.jailbreak.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 300)
      Text(L10n.jailbreakTitle)
        .font(.custom.title)
      Text(L10n.jailbreakText)
      Spacer()
    }
    .padding()
  }

}
