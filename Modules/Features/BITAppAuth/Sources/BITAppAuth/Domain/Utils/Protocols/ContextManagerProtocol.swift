import BITLocalAuthentication
import Foundation
import Spyable

@Spyable
public protocol ContextManagerProtocol {
  func setCredential(_ data: Data, context: LAContextProtocol) throws
}
