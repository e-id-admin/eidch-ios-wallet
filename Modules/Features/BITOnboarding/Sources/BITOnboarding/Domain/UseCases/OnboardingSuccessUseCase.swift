import Factory
import Foundation

struct OnboardingSuccessUseCase: OnboardingSuccessUseCaseProtocol {

  let repository: OnboardingSuccessRepositoryProtocol

  init(repository: OnboardingSuccessRepositoryProtocol = Container.shared.onboardingSuccessRepository()) {
    self.repository = repository
  }

  func execute() throws {
    try repository.setSuccessState()
  }

}
