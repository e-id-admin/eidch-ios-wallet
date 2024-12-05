import BITCrypto
import Factory
import Foundation

struct SaltService: SaltServiceProtocol {

  // MARK: Lifecycle

  public init(
    appPinSaltLength: Int = Container.shared.appPinSaltLength(),
    saltRepository: SaltRepositoryProtocol = Container.shared.saltRepository())
  {
    self.appPinSaltLength = appPinSaltLength
    self.saltRepository = saltRepository
  }

  // MARK: Public

  public func generateSalt() throws -> Data {
    let saltData = try Data.random(length: appPinSaltLength)
    try saltRepository.setPinSalt(saltData)
    return saltData
  }

  // MARK: Private

  private let appPinSaltLength: Int
  private let saltRepository: SaltRepositoryProtocol

}
