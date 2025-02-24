import BITJWT
import BITNetworking
import Factory
import Foundation

// MARK: - FetchRequestObjectError

public enum FetchRequestObjectError: Error {
  case invalidPresentationInvitation
}

// MARK: - FetchRequestObjectUseCase

public struct FetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocol {

  // MARK: Public

  public func execute(_ url: URL) async throws -> RequestObject {
    do {
      let requestObjectData: Data = try await repository.fetchRequestObject(from: url)
      return try createRequestObject(from: requestObjectData)
    } catch is DecodingError {
      throw FetchRequestObjectError.invalidPresentationInvitation
    } catch {
      throw error
    }
  }

  // MARK: Private

  @Injected(\.jwtDecoder) private var jwtDecoder: JWTDecoderProtocol
  @Injected(\.openIDRepository) private var repository: OpenIDRepositoryProtocol

  private func createRequestObject(from requestObjectData: Data) throws -> RequestObject {
    guard
      let strRequestObject = String(data: requestObjectData, encoding: .utf8),
      let requestObjectJWT = try? JWT(from: strRequestObject),
      let payload = jwtDecoder.decodePayload(from: requestObjectJWT.raw)
    else {
      return try JSONDecoder().decode(RequestObject.self, from: requestObjectData)
    }

    return try JWTRequestObject(jwt: requestObjectJWT, payload: payload)
  }

}
