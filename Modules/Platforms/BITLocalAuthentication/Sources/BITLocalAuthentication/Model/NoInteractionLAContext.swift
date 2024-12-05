import LocalAuthentication

public class NoInteractionLAContext: LAContext {
  override public init() {
    super.init()
    interactionNotAllowed = true
  }
}
