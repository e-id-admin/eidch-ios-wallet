#if DEBUG || UITEST || targetEnvironment(simulator)
import Factory
import Foundation
import Moya
import RealmSwift
@testable import BITAppAuth
@testable import BITCredential
@testable import BITDataStore
@testable import BITHome
@testable import BITInvitation
@testable import BITJWT
@testable import BITNetworking
@testable import BITOpenID
@testable import BITVault

enum Argument: String, CaseIterable {
  case disableDevicePin = "-disable-device-pin"
  case disableSecureEnclave = "-disable-secure-enclave"
  case disableUserInactivityTimeout = "-disable-user-inactivity-timeout"
  case disableDelays = "-disable-delays"
  case disableOnboarding = "-disable-onboarding"
  case disableLockWallet = "-disable-lock-wallet"
  case uiTests = "-ui-tests"
}

// MARK: - Container + AutoRegistering

extension Container: AutoRegistering {
  public func autoRegister() {
    #if targetEnvironment(simulator)
    contextManager.register { SimulatorContextManager() }
    #endif

    if ProcessInfo().arguments.contains(Argument.disableDevicePin.rawValue) {
      hasDevicePinUseCase.register { MockHasDevicePinUseCase(true) }
    }

    if ProcessInfo().arguments.contains(Argument.disableSecureEnclave.rawValue) {
      vaultOptions.register { .savePermanently }
    }

    if ProcessInfo().arguments.contains(Argument.disableUserInactivityTimeout.rawValue) {
      userInactivityTimeout.register { 60 * 60 }
    }

    if ProcessInfo().arguments.contains(Argument.disableDelays.rawValue) {
      delayAfterAcceptingCredential.register { 0 }
      loadingDelay.register { 0 }
    }

    if ProcessInfo().arguments.contains(Argument.disableLockWallet.rawValue) {
      lockDelay.register { 0 }
      attemptsLimit.register { 999 }
      lockWalletUseCase.register { MockLockWalletUseCase() }
    }

    if ProcessInfo().arguments.contains(Argument.uiTests.rawValue) {
      NetworkContainer.shared.stubClosure.register { { _ in .immediate } }
      homeRouter.register { MockHomeRouter() }

      let jwtSignatureValidatorSpy = JWTSignatureValidatorProtocolSpy()
      jwtSignatureValidatorSpy.validateDidKidReturnValue = true
      jwtSignatureValidator.register { jwtSignatureValidatorSpy }

      let dataStoreConfigurationSpy = DataStoreConfigurationManagerProtocolSpy()
      dataStoreConfigurationSpy.setEncryptionKeyClosure = { _ in } // skip encryption
      dataStoreConfigurationManager.register { dataStoreConfigurationSpy }

      realmDataStoreConfiguration.register { Realm.Configuration(inMemoryIdentifier: "RealmDataStore") }
    }

  }
}

#endif

extension AppDelegate {

  #if DEBUG || UITEST || targetEnvironment(simulator)
  func setupAdditionalConfigurationsIfNeeded() {
    if ProcessInfo().arguments.contains(Argument.disableOnboarding.rawValue) {
      try? Container.shared.registerPinCodeUseCase().execute(pinCode: "000000")
      UserDefaults.standard.set(false, forKey: "rootOnboardingIsEnabled")
    }
  }
  #else
  func setupAdditionalConfigurationsIfNeeded() {}
  #endif
}
