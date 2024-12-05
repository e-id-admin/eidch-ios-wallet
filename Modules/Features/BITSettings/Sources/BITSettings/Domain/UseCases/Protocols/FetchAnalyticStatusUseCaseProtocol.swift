import Foundation
import Spyable

@Spyable
protocol FetchAnalyticStatusUseCaseProtocol {
  func execute() -> Bool
}
