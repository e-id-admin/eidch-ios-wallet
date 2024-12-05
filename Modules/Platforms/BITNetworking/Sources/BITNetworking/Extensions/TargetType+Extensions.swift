import Foundation
import Moya

extension URL {

  init(target: some TargetType) {
    self = target.baseURL.appendingPathComponent(target.path)
  }

}
