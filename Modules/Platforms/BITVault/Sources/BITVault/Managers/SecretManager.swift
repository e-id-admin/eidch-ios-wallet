import BITLocalAuthentication
import Foundation

public struct SecretManager: SecretManagerProtocol {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func exists(key: String, query: Query?) -> Bool {
    let defaultQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: false,
      kSecUseAuthenticationContext as String: NoInteractionLAContext(),
    ]

    var userQuery: Query = query ?? [:]
    userQuery.mergeWith(defaultQuery)

    var item: CFTypeRef?
    let status = SecItemCopyMatching(userQuery as CFDictionary, &item)
    return status != errSecItemNotFound
  }

  public func double(forKey key: String, query: Query?) -> Double? {
    getSecret(forKey: key, query: query)
  }

  public func string(forKey key: String, query: Query?) -> String? {
    getSecret(forKey: key, query: query)
  }

  public func integer(forKey key: String, query: Query?) -> Int? {
    getSecret(forKey: key, query: query)
  }

  public func bool(forKey key: String, query: Query?) -> Bool? {
    getSecret(forKey: key, query: query)
  }

  public func data(forKey key: String, query: Query?) -> Data? {
    getSecret(forKey: key, query: query)
  }

  public func removeObject(forKey key: String, query: Query?) throws {
    try deleteSecret(forKey: key, query: query)
  }

  public func set(_ value: Any?, forKey key: String, query: Query?) throws {
    guard let value else { return try removeObject(forKey: key, query: query) }
    guard let data = data(from: value) else { throw VaultError.toDataFailed("") }

    try setValue(data, forKey: key, query: query)
  }

  // MARK: Private

  private func value<T: Codable>(forKey key: String, as type: T.Type, query: Query? = nil) -> T? {
    if let data = data(forKey: key, query: query) {
      return value(from: data, as: type)
    }
    return nil
  }

  private func data(from value: Any) -> Data? {
    switch value {
    case let dataValue as Data:
      dataValue
    case let codableValue as Codable:
      try? JSONEncoder().encode(codableValue)
    default:
      nil
    }
  }

  private func value<T: Decodable>(from data: Data, as type: T.Type) -> T? {
    T.self == Data.self ? data as? T : try? JSONDecoder().decode(T.self, from: data)
  }

  private func setValue(_ value: Data, forKey key: String, query: Query?) throws {
    let defaultQuery: Query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: value,
    ]

    var userQuery: Query = query ?? [:]
    userQuery.mergeWith(defaultQuery)

    try deleteSecItem(userQuery)

    let status = SecItemAdd(userQuery as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw VaultError.secretSavingError(reason: "OSStatus error \(status)")
    }
  }

  private func deleteSecItem(_ query: [String: Any]) throws {
    var queryCopy = query
    queryCopy[kSecReturnData as String] = false
    queryCopy.removeValue(forKey: kSecValueData as String)

    let status = SecItemDelete(queryCopy as CFDictionary)
    guard [errSecSuccess, errSecItemNotFound].contains(status) else {
      throw VaultError.secretDeletingError(reason: "OSStatus error \(status)")
    }
  }

  private func getSecret<T: Decodable>(forKey key: String, query: Query?) -> T? {
    let defaultQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
    ]

    var userQuery: Query = query ?? [:]
    userQuery.mergeWith(defaultQuery)

    var item: CFTypeRef?

    let status = SecItemCopyMatching(userQuery as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data, let value = value(from: data, as: T.self) else { return nil }
    return value
  }

  private func deleteSecret(forKey: String, query: Query?) throws {
    let defaultQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: forKey,
      kSecReturnData as String: false,
    ]

    var userQuery: Query = query ?? [:]
    userQuery.mergeWith(defaultQuery)

    let status = SecItemDelete(userQuery as CFDictionary)
    guard [errSecSuccess, errSecItemNotFound].contains(status) else {
      throw VaultError.secretDeletingError(reason: "OSStatus error \(status)")
    }
  }

}
