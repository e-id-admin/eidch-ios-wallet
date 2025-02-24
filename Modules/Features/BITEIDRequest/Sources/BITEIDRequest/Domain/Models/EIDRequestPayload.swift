struct EIDRequestPayload: Codable, Equatable {
  let mrz: [String]
  let hasLegalRepresentant: Bool

  private let email: String?

  init(mrz: [String], hasLegalRepresentant: Bool = false, email: String? = nil) {
    self.mrz = mrz
    self.hasLegalRepresentant = hasLegalRepresentant
    self.email = email
  }

  enum CodingKeys: String, CodingKey {
    case mrz
    case hasLegalRepresentant = "legalRepresentant"
    case email
  }
}
