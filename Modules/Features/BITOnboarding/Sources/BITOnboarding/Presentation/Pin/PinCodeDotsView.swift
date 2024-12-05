import BITAppAuth
import BITTheming
import Factory
import Foundation
import SwiftUI

public struct PinCodeDotsView: View {

  // MARK: Lifecycle

  public init(pinCode: String, pinCodeSize: Int = Container.shared.pinCodeSize()) {
    self.pinCode = pinCode
    self.pinCodeSize = pinCodeSize
  }

  // MARK: Public

  public var body: some View {
    VStack {
      HStack(spacing: .x5) {
        Spacer()
        ForEach(0..<pinCodeSize, id: \.self) { index in
          DotView(isActive: pinCode.count - 1 >= index)
        }
        Spacer()
      }
    }
    .environment(\.colorScheme, .light)
  }

  // MARK: Private

  private var pinCode: String
  private let pinCodeSize: Int

  private func foregroundColor(index: Int) -> Color {
    index < pinCode.count ? ThemingAssets.Brand.Core.white.swiftUIColor : .clear
  }

}
