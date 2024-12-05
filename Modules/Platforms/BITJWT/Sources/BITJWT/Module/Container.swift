import Factory
import Foundation

extension Container {

  // MARK: Public

  public var jwkHelper: Factory<JWKHelperProtocol> {
    self { JWKHelper() }
  }

  public var jwtHelper: Factory<JWTHelperProtocol> {
    self { JWTHelper() }
  }

  public var jwtSignatureValidator: Factory<JWTSignatureValidatorProtocol> {
    self { JWTSignatureValidator() }
  }

  // MARK: Internal

  var didResolverHelper: Factory<DidResolverHelperProtocol> {
    self { DidResolverHelper() }
  }

  var didResolverRepository: Factory<DidResolverRepositoryProtocol> {
    self { DidResolverRepository() }
  }

}
