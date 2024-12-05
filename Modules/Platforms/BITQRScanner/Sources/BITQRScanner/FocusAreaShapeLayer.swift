import Foundation
import UIKit

class FocusAreaShapeLayer: CAShapeLayer {

  // MARK: Lifecycle

  override init() {
    super.init()

    strokeColor = UIColor.white.cgColor
    fillColor = UIColor.clear.cgColor
    lineWidth = 5.0
    cornerRadius = 12

    shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    shadowOffset = CGSize(width: 1.0, height: 1)
    shadowOpacity = 1.0
    shadowRadius = 1.0
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Internal

  func move(to coordinates: [CGPoint]) {
    let currentTime = Date().timeIntervalSince1970
    guard currentTime - focusAreaLastUpdateTime > debounceFocusAreaTime else { return }
    focusAreaLastUpdateTime = currentTime

    let path = computePath(from: coordinates)
    guard self.path != path.cgPath else { return }

    removeAnimation(forKey: animationPathKey)

    let animation = CABasicAnimation(keyPath: animationKey)
    animation.duration = animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.fromValue = self.path
    animation.toValue = path.cgPath
    add(animation, forKey: animationPathKey)
    self.path = path.cgPath
  }

  func resetPositionToCenter(of view: UIView) {
    let squareSize: CGFloat = defaultSize

    let centerX = view.bounds.midX
    let centerY = view.bounds.midY

    let topLeftCorner = CGPoint(x: centerX - squareSize / 2, y: centerY - squareSize / 2)

    let coordinates: [CGPoint] = [
      topLeftCorner,
      CGPoint(x: topLeftCorner.x + squareSize, y: topLeftCorner.y),
      CGPoint(x: topLeftCorner.x + squareSize, y: topLeftCorner.y + squareSize),
      CGPoint(x: topLeftCorner.x, y: topLeftCorner.y + squareSize),
    ]

    move(to: coordinates)
  }

  // MARK: Private

  private let animationPathKey: String = "animationPath"
  private let animationKey: String = "path"
  private let animationDuration: TimeInterval = 0.350

  private let defaultSize: CGFloat = 200

  private let focusAreaLineLength: CGFloat = 40
  private let controlPointOffset: CGFloat = -0.1

  private var focusAreaLastUpdateTime: TimeInterval = 0
  private let debounceFocusAreaTime: TimeInterval = 0.2

  private func computePath(from coordinates: [CGPoint]) -> UIBezierPath {
    guard coordinates.count == 4 else { return UIBezierPath() }

    let lineLength: CGFloat = focusAreaLineLength
    let controlPointOffset: CGFloat = controlPointOffset

    let path = UIBezierPath()

    for i in 0..<coordinates.count {
      let startPoint = coordinates[i]
      let nextPoint = coordinates[(i + 1) % 4]
      let previousPoint = coordinates[(i + 3) % 4]

      // Compute the vectors for the edges between the current point and the next/previous points
      let nextVector = CGPoint(x: nextPoint.x - startPoint.x, y: nextPoint.y - startPoint.y)
      let nextLength = hypot(nextVector.x, nextVector.y)
      let normalizedNextVector = CGPoint(x: (nextVector.x / nextLength) * lineLength, y: (nextVector.y / nextLength) * lineLength)

      let previousVector = CGPoint(x: previousPoint.x - startPoint.x, y: previousPoint.y - startPoint.y)
      let previousLength = hypot(previousVector.x, previousVector.y)
      let normalizedPreviousVector = CGPoint(x: (previousVector.x / previousLength) * lineLength, y: (previousVector.y / previousLength) * lineLength)

      // Calculate the end points of the lines extending from the corners
      let nextLineEnd = CGPoint(x: startPoint.x + normalizedNextVector.x, y: startPoint.y + normalizedNextVector.y)
      let previousLineEnd = CGPoint(x: startPoint.x + normalizedPreviousVector.x, y: startPoint.y + normalizedPreviousVector.y)

      path.move(to: previousLineEnd)

      // Calculate the control point at the midpoint between the two line ends
      let controlPoint = CGPoint(
        x: startPoint.x + (normalizedNextVector.x + normalizedPreviousVector.x) * controlPointOffset,
        y: startPoint.y + (normalizedNextVector.y + normalizedPreviousVector.y) * controlPointOffset)

      path.addQuadCurve(to: nextLineEnd, controlPoint: controlPoint)
    }

    return path
  }

}
