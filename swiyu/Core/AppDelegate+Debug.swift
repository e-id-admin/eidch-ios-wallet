#if DEBUG
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
}

// MARK: - Container + AutoRegistering

extension Container: AutoRegistering {
  public func autoRegister() {
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

  }
}

#endif
