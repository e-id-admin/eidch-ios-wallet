import CryptoKit
import Foundation

extension Digest {

  var asData: Data {
    Data(Array(makeIterator()))
  }

}
