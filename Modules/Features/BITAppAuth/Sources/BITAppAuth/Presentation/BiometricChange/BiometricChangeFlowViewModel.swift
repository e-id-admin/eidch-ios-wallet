import Combine
import Factory
import Foundation
import SwiftUI

// MARK: - BiometricChangeStep

enum BiometricChangeStep: Int, CaseIterable {
  case settings = 0
  case currentPin = 1
}

// MARK: - PinCodeState

enum PinCodeState {
  case normal
  case error
}

// MARK: - BiometricChangeFlowViewModel

@MainActor
class BiometricChangeFlowViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    isPresented: Binding<Bool> = .constant(true),
    isBiometricEnabled: Bool,
    getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol = Container.shared.getUniquePassphraseUseCase(),
    getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol = Container.shared.getBiometricTypeUseCase(),
    changeBiometricStatusUseCase: ChangeBiometricStatusUseCaseProtocol = Container.shared.changeBiometricStatusUseCase(),
    hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol = Container.shared.hasBiometricAuthUseCase(),
    pinCodeSize: Int = Container.shared.pinCodeSize(),
    pinCodeObserverDelay: CGFloat = Container.shared.pinCodeObserverDelay(),
    animationDuration: CGFloat = Container.shared.pinCodeErrorAnimationDuration())
  {
    self.getUniquePassphraseUseCase = getUniquePassphraseUseCase
    self.pinCodeSize = pinCodeSize
    self.pinCodeObserverDelay = pinCodeObserverDelay
    self.animationDuration = animationDuration
    self.changeBiometricStatusUseCase = changeBiometricStatusUseCase
    self.getBiometricTypeUseCase = getBiometricTypeUseCase
    self.hasBiometricAuthUseCase = hasBiometricAuthUseCase
    self.isBiometricEnabled = isBiometricEnabled
    biometricType = getBiometricTypeUseCase.execute()

    _isPresented = isPresented

    updateCurrentIndex()
    configureObservers()
  }

  // MARK: Internal

  @Binding var isPresented: Bool

  @Published var currentIndex: Int = 0
  @Published var pinCode: String = ""
  @Published var pinCodeState: PinCodeState = .normal

  var biometricType: BiometricType

  let isBiometricEnabled: Bool

  var hasBiometricType: Bool {
    biometricType != .none
  }

  func viewDidAppear() {
    updateCurrentIndex()
  }

  // MARK: Private

  private var bag = Set<AnyCancellable>()
  private let animationDuration: CGFloat
  private let pinCodeSize: Int
  private let pinCodeObserverDelay: CGFloat
  private var getUniquePassphraseUseCase: GetUniquePassphraseUseCaseProtocol
  private var getBiometricTypeUseCase: GetBiometricTypeUseCaseProtocol
  private let changeBiometricStatusUseCase: ChangeBiometricStatusUseCaseProtocol
  private let hasBiometricAuthUseCase: HasBiometricAuthUseCaseProtocol

  private func updateCurrentIndex() {
    currentIndex = hasBiometricAuthUseCase.execute() ?
      BiometricChangeStep.currentPin.rawValue : BiometricChangeStep.settings.rawValue
  }

  private func configureObservers() {
    $pinCode
      .filter { $0.count == self.pinCodeSize }
      .delay(for: .seconds(pinCodeObserverDelay), scheduler: DispatchQueue.main)
      .map { String($0.prefix(self.pinCodeSize)) }
      .sink { [weak self] value in
        Task {
          try await self?.validatePinCode(value)
        }
      }.store(in: &bag)
  }

  private func validatePinCode(_ pin: PinCode) async throws {
    guard let uniquePassphrase = try? getUniquePassphraseUseCase.execute(from: pin) else {
      return retry()
    }

    do {
      try await changeBiometricStatusUseCase.execute(with: uniquePassphrase)
      pinCode = ""
      isPresented = false
    } catch ChangeBiometricStatusError.userCancel {
      retry(animated: false)
    }
  }

  private func retry(animated: Bool = true) {
    if animated {
      withAnimation(.easeInOut(duration: animationDuration)) {
        self.pinCodeState = .error
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
      withAnimation {
        if animated {
          self.pinCodeState = .normal
        }

        self.pinCode = ""
      }
    }
  }

}
