import Factory
import Foundation

public class OnboardingContext {

  // MARK: Public

  public weak var onboardingDelegate: OnboardingDelegate?

  // MARK: Internal

  var pincode: String?
  weak var pinCodeDelegate: PinCodeDelegate?
}
