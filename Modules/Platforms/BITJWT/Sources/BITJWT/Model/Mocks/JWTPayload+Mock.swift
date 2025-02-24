#if DEBUG
import Foundation
@testable import BITTestingCore

extension JWTPayload: Mockable {
  struct Mock {
    static let sample: JWTPayload = Mocker.decode(fromFile: "jwt-payload", bundle: Bundle.module)
  }
}
#endif
