import BITLocalAuthentication
import Foundation

// MARK: - QueryBuilder

public class QueryBuilder {

  // MARK: Lifecycle

  public init() {
    query = [:]
  }

  // MARK: Public

  public func setService(_ service: String) -> Self {
    self.service = service

    return self
  }

  public func setContext(_ context: LAContextProtocol) -> Self {
    self.context = context

    return self
  }

  public func setProtection(_ protection: CFString) -> Self {
    self.protection = protection

    return self
  }

  public func setAccessControlFlags(_ accessControlFlags: SecAccessControlCreateFlags) -> Self {
    self.accessControlFlags = accessControlFlags

    return self
  }

  public func build() throws -> Query {
    if let service {
      query[kSecAttrService as String] = service
    }

    if protection != nil || accessControlFlags != nil {
      let finalProtection = protection ?? SecAccessControl.defaultProtection
      let finalAccessControlFlags = accessControlFlags ?? SecAccessControl.defaultAccesControlFlags
      let accessControl = try SecAccessControl.create(accessControlFlags: finalAccessControlFlags, protection: finalProtection)
      query[kSecAttrAccessControl as String] = accessControl
    }

    if let context {
      query.setContext(context, reason: reason)
    }

    return query
  }

  // MARK: Private

  private var query: Query
  private var reason: String?
  private var service: String?
  private var protection: CFString?
  private var context: LAContextProtocol?
  private var accessControlFlags: SecAccessControlCreateFlags?

}
