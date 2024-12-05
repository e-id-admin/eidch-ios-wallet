import Spyable

@Spyable
public protocol ValidateRequestObjectUseCaseProtocol {
  func execute(_ requestObject: RequestObject) async -> Bool
}
