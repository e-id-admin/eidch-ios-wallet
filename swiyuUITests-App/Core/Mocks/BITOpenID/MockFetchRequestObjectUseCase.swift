import BITOpenID
import Foundation

struct MockFetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocol {
  func execute(_ url: URL) async throws -> RequestObject {
    RequestObject.Mock.sample
  }
}
