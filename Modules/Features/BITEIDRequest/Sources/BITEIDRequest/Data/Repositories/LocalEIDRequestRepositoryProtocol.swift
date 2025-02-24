import Foundation
import Spyable

@Spyable
protocol LocalEIDRequestRepositoryProtocol {
  func create(eIDRequestCase: EIDRequestCase) async throws -> EIDRequestCase
  func get(id: String) async throws -> EIDRequestCase
}
