import Foundation
import Spyable

// MARK: - TokenStatusListDecoderProtocol

@Spyable
protocol TokenStatusListDecoderProtocol {
  func decode(_ rawJWT: String, index: Int) throws -> StatusCode
}
