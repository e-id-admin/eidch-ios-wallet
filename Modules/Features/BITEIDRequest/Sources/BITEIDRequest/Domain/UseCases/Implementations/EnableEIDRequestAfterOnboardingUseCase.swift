import Factory

struct EnableEIDRequestAfterOnboardingUseCase: EnableEIDRequestAfterOnboardingUseCaseProtocol {
  func execute(_ enable: Bool) {
    eIDRequestAfterOnboardingEnabledRepository.set(enable)
  }

  @Injected(\.eIDRequestAfterOnboardingEnabledRepository) private var eIDRequestAfterOnboardingEnabledRepository: EIDRequestAfterOnboardingEnabledRepositoryProcotol
}
