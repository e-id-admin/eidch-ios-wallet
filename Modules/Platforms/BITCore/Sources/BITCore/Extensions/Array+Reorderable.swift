extension Array {

  public func reorder<T: Equatable>(by preferredOrder: [T], using: (Element) -> T) -> [Element] {
    sorted {
      guard let first = preferredOrder.firstIndex(of: using($0)) else {
        return false
      }

      guard let second = preferredOrder.firstIndex(of: using($1)) else {
        return true
      }

      return first < second
    }
  }
}
