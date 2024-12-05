import Factory
import Foundation

extension Container {

  public var createAnyCredentialUseCase: Factory<CreateAnyCredentialUseCaseProtocol> {
    self { CreateAnyCredentialUseCase() }
  }
}
