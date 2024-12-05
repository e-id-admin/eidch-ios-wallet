import Foundation

public struct UserDefaultsOnboardingSuccessRepository: OnboardingSuccessRepositoryProtocol {

  public init() {}

  public func setSuccessState() throws {
    UserDefaults.standard.set(false, forKey: "rootOnboardingIsEnabled")
  }

}
