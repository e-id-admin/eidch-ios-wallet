import Factory

extension Container {

  public var jailbreakDetector: Factory<JailbreakDetectorProtocol> {
    self {
      #if targetEnvironment(simulator)
      SimulatorJailbreakDetector()
      #else
      JailbreakDetector()
      #endif
    }
  }

}
