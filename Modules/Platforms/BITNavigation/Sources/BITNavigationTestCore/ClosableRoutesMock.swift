import BITNavigation

// MARK: - ClosableRoutesMock

public class ClosableRoutesMock: ClosableRoutes {

  // MARK: Lifecycle

  public init() {}

  // MARK: Public

  public var closeWithCompletionCalled = false
  public var closeCalled = false
  public var popCalled = false
  public var popNumberCalled = false
  public var popNumberCalledValue: Int = 0
  public var popToRootCalled = false
  public var dismissCalled = false

  public func close(onComplete: (() -> Void)?) {
    closeWithCompletionCalled = true
    onComplete?()
  }

  public func close() {
    closeCalled = true
  }

  public func pop() {
    popCalled = true
  }

  public func pop(number: Int) {
    popNumberCalledValue = number
    popNumberCalled = true
  }

  public func popToRoot() {
    popToRootCalled = true
  }

  public func dismiss() {
    dismissCalled = true
  }
}
