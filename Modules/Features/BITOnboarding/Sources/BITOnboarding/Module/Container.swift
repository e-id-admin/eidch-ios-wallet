import BITNavigation
import BITSettings
import Factory

@MainActor
extension Container {

  // MARK: Public

  public var onboardingModule: Factory<OnboardingModule> {
    self { OnboardingModule() }
  }

  // MARK: Internal

  var pinCodeInformationViewModel: ParameterFactory<OnboardingInternalRoutes, PinCodeInformationViewModel> {
    self { PinCodeInformationViewModel(router: $0) }
  }

  var pinCodeConfirmationViewModel: ParameterFactory<OnboardingInternalRoutes, PinCodeConfirmationViewModel> {
    self { PinCodeConfirmationViewModel(router: $0) }
  }

  var pinCodeViewModel: ParameterFactory<OnboardingInternalRoutes, PinCodeViewModel> {
    self { PinCodeViewModel(router: $0) }
  }

  var privacyPermissionViewModel: ParameterFactory<OnboardingInternalRoutes, PrivacyPermissionViewModel> {
    self { PrivacyPermissionViewModel(router: $0) }
  }

  var biometricViewModel: ParameterFactory<OnboardingInternalRoutes, BiometricViewModel> {
    self { BiometricViewModel(router: $0) }
  }

  var setupViewModel: ParameterFactory<OnboardingInternalRoutes, SetupViewModel> {
    self { SetupViewModel(router: $0) }
  }

}

extension Container {

  // MARK: Public

  public var onboardingContext: Factory<OnboardingContext> {
    self { OnboardingContext() }
  }

  public var onboardingRouter: Factory<OnboardingRouter> {
    self { OnboardingRouter() }
  }

  // MARK: Internal

  var autoHideErrorDelay: Factory<Double> { self { 5 } }

  var onboardingSuccessRepository: Factory<OnboardingSuccessRepositoryProtocol> {
    self { UserDefaultsOnboardingSuccessRepository() }
  }

  var onboardingSuccessUseCase: Factory<OnboardingSuccessUseCaseProtocol> {
    self { OnboardingSuccessUseCase() }
  }
}
