import BITNetworking
import Factory
import Foundation

struct DidResolverRepository: DidResolverRepositoryProtocol {

  func fetchDidLog(from url: URL) async throws -> String {
    try await networkService.request(DidResolverEndpoint.didLog(url: url)).mapString()
  }

  @Injected(\NetworkContainer.service) private var networkService: NetworkService

}
