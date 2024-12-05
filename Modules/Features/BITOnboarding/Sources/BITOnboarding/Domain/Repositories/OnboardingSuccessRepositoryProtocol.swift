import Foundation
import Spyable

// MARK: - OnboardingSuccessRepositoryProtocol

@Spyable
public protocol OnboardingSuccessRepositoryProtocol {
  func setSuccessState() throws
}

// MARK: - StubOnboardingSuccessRepository

public struct StubOnboardingSuccessRepository: OnboardingSuccessRepositoryProtocol {
  public func setSuccessState() throws { fatalError("Not implemented...") }
}
