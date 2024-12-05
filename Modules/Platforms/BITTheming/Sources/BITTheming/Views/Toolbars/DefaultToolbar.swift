import SwiftUI

public struct DefaultToolbar: ToolbarContent {

  public init() {}

  public var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      ThemingAssets.federalOfficeLogo.swiftUIImage
    }
  }

}
