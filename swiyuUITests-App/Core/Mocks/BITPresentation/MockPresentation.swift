import BITCore
import BITOpenID
import BITPresentation

// MARK: - CompatibleCredential.Mock

extension CompatibleCredential {
  struct Mock {
    static let array: [CompatibleCredential] = [BIT]
    static let fieldFirstName = PresentationField(jsonPath: "$.firstName", value: CodableValue(value: "Fritz", as: "string"))
    static let fieldLastName = PresentationField(jsonPath: "$.lastName", value: CodableValue(value: "Test", as: "string"))

    static var BIT = CompatibleCredential(credential: .Mock.sample, requestedFields: [fieldFirstName, fieldLastName])
  }
}

// MARK: - PresentationRequestContext.Mock

extension PresentationRequestContext {

  enum Mock {
    static let vcSdJwtSample = PresentationRequestContext(requestObject: .Mock.sample, compatibleCredentials: CompatibleCredential.Mock.array)
  }
}
