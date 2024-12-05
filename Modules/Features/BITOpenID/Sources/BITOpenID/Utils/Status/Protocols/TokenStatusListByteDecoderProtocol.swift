import Foundation
import Spyable

typealias StatusCode = Int

// MARK: - TokenStatusListByteDecoderProtocol

@Spyable
protocol TokenStatusListByteDecoderProtocol {
  func decode(_ statusList: Data, bits: Int, index: Int) throws -> StatusCode
}
