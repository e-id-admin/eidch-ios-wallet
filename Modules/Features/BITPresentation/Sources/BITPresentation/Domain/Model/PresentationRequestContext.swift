import BITOpenID
import Foundation
import Spyable

public typealias InputDescriptorID = String

// MARK: - PresentationRequestContext

public class PresentationRequestContext {

  // MARK: Lifecycle

  public init(requestObject: RequestObject) {
    self.requestObject = requestObject
  }

  // MARK: Public

  public let requestObject: RequestObject

  public var trustStatement: TrustStatement?
  public var requests: [InputDescriptorID: [CompatibleCredential]] = [:]
  public var selectedCredentials: [InputDescriptorID: CompatibleCredential] = [:]
}

#if DEBUG
@testable import BITOpenID

extension PresentationRequestContext {

  // MARK: Lifecycle

  fileprivate convenience init(requestObject: RequestObject, compatibleCredentials: [CompatibleCredential], trustStatement: TrustStatement? = nil) {
    self.init(requestObject: requestObject)
    let inputDescriptors = requestObject.presentationDefinition.inputDescriptors.map(\.id)
    var requests: [InputDescriptorID: [CompatibleCredential]] = [:]
    for inputDescriptorID in inputDescriptors {
      // swiftlint: disable all
      requests[inputDescriptorID] = compatibleCredentials
      // swiftlint: enable all
    }

    self.trustStatement = trustStatement
  }

  // MARK: Internal

  enum Mock {
    static let vcSdJwtSample: PresentationRequestContext = .init(requestObject: .Mock.VcSdJwt.sample, compatibleCredentials: CompatibleCredential.Mock.array)
    static let vcSdJwtJwtSample: PresentationRequestContext = .init(requestObject: JWTRequestObject.Mock.sample, compatibleCredentials: CompatibleCredential.Mock.array, trustStatement: .Mock.validSample)
    static let vcSdJwtSampleWithoutInputDescriptors: PresentationRequestContext = .init(requestObject: .Mock.VcSdJwt.sampleWithoutInputDescriptors, compatibleCredentials: CompatibleCredential.Mock.array)
    static let unsupportedResponseTypeVcSdJwtSample: PresentationRequestContext = .init(requestObject: .Mock.VcSdJwt.unsupportedResponseTypeSample, compatibleCredentials: CompatibleCredential.Mock.array)
  }
}
#endif
