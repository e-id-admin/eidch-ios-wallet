import Factory

struct IsEIDRequestAfterOnboardingEnabledUseCase: IsEIDRequestAfterOnboardingEnabledUseCaseProtocol {
  func execute() -> Bool {
    eIDRequestAfterOnboardingEnabledRepository.get()
  }

  @Injected(\.eIDRequestAfterOnboardingEnabledRepository) private var eIDRequestAfterOnboardingEnabledRepository: EIDRequestAfterOnboardingEnabledRepositoryProcotol
}
