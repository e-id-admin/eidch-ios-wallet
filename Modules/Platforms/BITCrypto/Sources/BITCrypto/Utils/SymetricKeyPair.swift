import Foundation

struct SymetricKeyPair {
  let privateKey: SecKey
  let publicKey: SecKey

  init(privateKey: SecKey, publicKey: SecKey) {
    self.privateKey = privateKey
    self.publicKey = publicKey
  }
}
