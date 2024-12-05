import Foundation
import SwiftUI

public struct ShakeEffect: GeometryEffect {
  public var amount: CGFloat
  public var shakesPerUnit: Int
  public var animatableData: CGFloat

  public init(amount: CGFloat = 10, shakesPerUnit: Int = 3, animatableData: CGFloat) {
    self.amount = amount
    self.shakesPerUnit = shakesPerUnit
    self.animatableData = animatableData
  }

  public func effectValue(size _: CGSize) -> ProjectionTransform {
    ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
  }
}
