import BITOpenID
import Foundation
import Spyable

@Spyable
public protocol PresentationRepositoryProtocol {
  func submitPresentation(from url: URL, presentationRequestBody: PresentationRequestBody) async throws
  func submitPresentation(from url: URL, presentationErrorRequestBody: PresentationErrorRequestBody) async throws
}
