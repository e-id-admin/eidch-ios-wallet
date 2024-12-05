import BITEntities

extension CredentialIssuerDisplayEntity {

  // MARK: Lifecycle

  public convenience init(_ issuer: CredentialIssuerDisplay) {
    self.init()
    id = issuer.id
    setValues(from: issuer)
  }

  // MARK: Public

  public func setValues(from issuer: CredentialIssuerDisplay) {
    locale = issuer.locale
    name = issuer.name
    image = issuer.image
  }

}
