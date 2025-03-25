import Factory
import Foundation

extension Container {

  public var vaultOptions: Factory<VaultOption> {
    self { [.secureEnclavePermanently] }
  }

  public var vaultAccessControlFlags: Factory<SecAccessControlCreateFlags> {
    self { [.privateKeyUsage, .applicationPassword] }
  }

  public var vaultProtection: Factory<CFString> {
    self { kSecAttrAccessibleWhenUnlockedThisDeviceOnly }
  }

  public var keyManager: Factory<KeyManagerProtocol> {
    self { KeyManager() }
  }

  public var secretManager: Factory<SecretManagerProtocol> {
    self { SecretManager() }
  }

}
