#if DEBUG
import Foundation

@testable import BITTestingCore

// MARK: AccessToken.Mock

extension AccessToken: Mockable {
  struct Mock {
    static let sample: AccessToken = .decode(fromFile: "access-token", bundle: Bundle.module)
    static let sampleData: Data = AccessToken.getData(fromFile: "access-token", bundle: Bundle.module) ?? Data()
  }
}
#endif
