import BITCredentialShared
import BITJWT
import BITOpenID
import BITVault
import Factory
import SwiftUI

extension Container {

  public var vaultAccessControlFlags: Factory<SecAccessControlCreateFlags> {
    self { [.privateKeyUsage, .applicationPassword] }
  }

}

extension Container {

  public var vaultProtection: Factory<CFString> {
    self { kSecAttrAccessibleWhenUnlockedThisDeviceOnly }
  }

}

// MARK: - Credential detail

extension Container {

  var credentialDetailRouter: Factory<CredentialDetailRouter> {
    self { CredentialDetailRouter() }
  }

  @MainActor
  var credentialDetailViewModel: ParameterFactory<(Credential, CredentialDetailRouterRoutes), CredentialDetailViewModel> {
    self { CredentialDetailViewModel($0, router: $1) }
  }

  @MainActor
  var credentialDetailModule: ParameterFactory<Credential, CredentialDetailModule> {
    self { CredentialDetailModule(credential: $0) }
  }

}

// MARK: - Credential wrong data

extension Container {

  @MainActor
  var credentialWrongDataModule: Factory<CredentialWrongDataModule> {
    self { CredentialWrongDataModule() }
  }

  var credentialWrongDataViewModel: ParameterFactory<CredentialWrongDataRouterRoutes, CredentialWrongDataViewModel> {
    self { CredentialWrongDataViewModel(router: $0) }
  }

  var credentialWrongDataRouter: Factory<CredentialWrongDataRouter> {
    self { CredentialWrongDataRouter() }
  }
}

// MARK: - Use cases

extension Container {

  public var saveCredentialUseCase: Factory<SaveCredentialUseCaseProtocol> {
    self { SaveCredentialUseCase() }
  }

  public var getCredentialListUseCase: Factory<GetCredentialListUseCaseProtocol> {
    self { GetCredentialListUseCase() }
  }

  public var checkAndUpdateCredentialStatusUseCase: Factory<CheckAndUpdateCredentialStatusUseCaseProtocol> {
    self { CheckAndUpdateCredentialStatusUseCase() }
  }

  public var deleteCredentialUseCase: Factory<DeleteCredentialUseCaseProtocol> {
    self { DeleteCredentialUseCase() }
  }
}

// MARK: - Repositories

extension Container {

  public var databaseCredentialRepository: Factory<CredentialRepositoryProtocol> {
    self { RealmCredentialRepository() }
  }

  public var hasDeletedCredentialRepository: Factory<HasDeletedCredentialRepositoryProtocol> {
    self { UserDefaultHasDeletedCredentialRepository() }
  }
}
