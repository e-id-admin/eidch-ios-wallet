import BITDataStore
import Foundation
import RealmSwift

class MockDataStoreConfigurationManager: DataStoreConfigurationManagerProtocol {
  var configuration = RealmSwift.Realm.Configuration.defaultConfiguration

  func reset() {
    // nothing
  }

  func setEncryption(key: Data) {
    // nothing
  }

}
