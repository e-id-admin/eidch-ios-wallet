import Foundation
import Spyable

@Spyable
public protocol GetEIDRequestCaseListUseCaseProtocol {
  func execute() async throws -> [EIDRequestCase]
}
