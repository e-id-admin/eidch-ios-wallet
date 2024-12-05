#if DEBUG
import Foundation

@testable import BITTestingCore

extension JWTPayload: Mockable {
  struct Mock {
    static let sample: JWTPayload = .decode(fromFile: "jwt-payload", bundle: Bundle.module)
  }
}
#endif
