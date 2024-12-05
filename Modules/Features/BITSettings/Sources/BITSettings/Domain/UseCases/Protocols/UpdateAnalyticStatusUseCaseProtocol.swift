import Foundation
import Spyable

@Spyable
public protocol UpdateAnalyticStatusUseCaseProtocol {
  func execute(isAllowed: Bool) async
}
