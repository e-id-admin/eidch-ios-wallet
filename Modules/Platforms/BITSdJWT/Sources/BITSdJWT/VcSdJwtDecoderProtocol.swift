import BITJWT
import Foundation
import Spyable

@Spyable
public protocol VcSdJwtDecoderProtocol {
  func decodeKeyBinding(from rawVcSdJwt: String) -> VcSdJwt.KeyBinding?
  func decodeVct(from rawVcSdJwt: String) -> (vct: String?, vctIntegrity: String?)
  func decodeTokenStatusList(from rawVcSdJwt: String) -> TokenStatusList?
  func decodeNonDisclosableClaims(from rawVcSdJwt: String) -> [String: Any]
}
