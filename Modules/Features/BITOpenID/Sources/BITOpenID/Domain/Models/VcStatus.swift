import Foundation

// MARK: - VcStatus

public enum VcStatus: String, Codable, CaseIterable {
  case valid
  case revoked
  case suspended
  case expired
  case unsupported
  case unknown
}
