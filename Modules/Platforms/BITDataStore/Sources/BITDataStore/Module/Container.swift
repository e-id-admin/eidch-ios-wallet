import Factory
import Foundation
import OSLog
import RealmSwift

extension Container {

  public var dataStore: Factory<RealmDataStoreProtocol> {
    self {
      RealmDataStore(configuration: self.realmDataStoreConfiguration())
    }
  }

  public var dataStoreConfigurationManager: Factory<DataStoreConfigurationManagerProtocol> {
    self { DataStoreConfiguration() }
  }

  public var realmDataStoreConfiguration: Factory<Realm.Configuration> {
    self { Realm.Configuration() }.singleton
  }

}
