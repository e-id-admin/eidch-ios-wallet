enum IdentityType: String, Decodable, Equatable {
  case identityCard = "SWISS_IDK"
  case passport = "SWISS_PASS"
  case foreignerPermit = "FOREIGNER_PERMIT"
}
