#if DEBUG
import Foundation
@testable import BITTestingCore

extension PresentationRequestBody: Mockable {
  enum Mock {
    static let sampleData: Data = Mocker.getData(fromFile: "presentation-request-body", bundle: Bundle.module) ?? Data()
    static func sample() -> PresentationRequestBody {
      Mocker.decode(fromData: sampleData)
    }
  }
}
#endif
