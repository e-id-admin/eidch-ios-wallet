import Foundation
import SwiftUI

extension View {
  public func border(width: CGFloat = 1.0, edges: [Edge] = [.bottom, .trailing, .top, .leading], color: Color) -> some View {
    overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
  }
}

// MARK: - EdgeBorder

// https://stackoverflow.com/a/58632759

public struct EdgeBorder: Shape {
  private var width: CGFloat
  private var edges: [Edge]

  public init(width: CGFloat = 1, edges: [Edge]) {
    self.width = width
    self.edges = edges
  }

  public func path(in rect: CGRect) -> Path {
    edges.map { edge -> Path in
      switch edge {
      case .top: Path(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: width))
      case .bottom: Path(CGRect(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
      case .leading: Path(CGRect(x: rect.minX, y: rect.minY, width: width, height: rect.height))
      case .trailing: Path(CGRect(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
      }
    }.reduce(into: Path()) { $0.addPath($1) }
  }
}
