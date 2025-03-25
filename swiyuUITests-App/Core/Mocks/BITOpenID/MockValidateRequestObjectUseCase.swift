import BITOpenID

struct MockValidateRequestObjectUseCase: ValidateRequestObjectUseCaseProtocol {
  func execute(_ requestObject: RequestObject) async -> Bool {
    true
  }
}
