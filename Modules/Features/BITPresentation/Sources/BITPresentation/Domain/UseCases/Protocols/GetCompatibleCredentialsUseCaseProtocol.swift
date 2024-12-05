import BITOpenID
import Spyable

@Spyable
public protocol GetCompatibleCredentialsUseCaseProtocol {
  func execute(using requestObject: RequestObject) async throws -> [InputDescriptorID: [CompatibleCredential]]
}
