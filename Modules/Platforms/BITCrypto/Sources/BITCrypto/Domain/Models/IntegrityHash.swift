import Foundation

public typealias IntegrityHash = String

// MARK: - IntegrityHash.Algorithm

extension IntegrityHash {
  enum Algorithm: String {
    case sha256
    case sha384
    case sha512

    func hash(data: Data) -> Data {
      switch self {
      case .sha256:
        SHA256Hasher().hash(data)
      case .sha384:
        SHA384Hasher().hash(data)
      case .sha512:
        SHA512Hasher().hash(data)
      }
    }
  }
}
