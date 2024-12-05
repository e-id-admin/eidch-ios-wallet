import BITAppAuth
import BITL10n
import BITTheming
import Factory
import PopupView
import SwiftUI

// MARK: - PrivacyView

public struct PrivacyView: View {

  // MARK: Lifecycle

  public init() {
    _viewModel = StateObject(wrappedValue: Container.shared.privacyViewModel())
  }

  // MARK: Public

  public var body: some View {
    ZStack {
      content()
        .font(.custom.body)
        .navigationTitle(L10n.securitySettingsTitle)
    }
    .popup(isPresented: $viewModel.isPinCodeChangedPresented) {
      Text(L10n.tkChangepasswordSuccessfulNotification)
        .font(.custom.footnote)
        .foregroundStyle(ThemingAssets.Brand.Bright.firGreenLabel.swiftUIColor)
        .padding(.horizontal, .x3)
        .padding(.vertical, .x2)
        .background(ThemingAssets.Brand.Bright.firGreen.swiftUIColor)
        .clipShape(.capsule)
    } customize: {
      $0
        .type(.floater())
        .position(.bottom)
        .autohideIn(3)
        .animation(.easeInOut)
    }
  }

  // MARK: Internal

  @StateObject var viewModel: PrivacyViewModel

  // MARK: Private

  @ViewBuilder
  private func content() -> some View {
    ScrollView {
      VStack(spacing: .x10) {
        MenuSection({
          MenuCell(text: L10n.securitySettingsChangePin, disclosureIndicator: .navigation) {
            viewModel.presentPinChangeFlow()
          }

          ToggleMenuCell(text: L10n.securitySettingsBiometrics, isOn: $viewModel.isBiometricEnabled) {
            viewModel.presentBiometricChangeFlow()
          }
          .hasDivider(false)
          .onAppear {
            viewModel.fetchBiometricStatus()
          }
        }, header: {
          MenuHeader(image: "hand.raised", text: L10n.securitySettingsLoginTitle)
        })

        MenuSection({
          MenuCell(text: L10n.securitySettingsDataProtection, disclosureIndicator: .externalLink, {
            openLink(L10n.securitySettingsDataProtectionLink)
          })

          ToggleMenuCell(text: L10n.securitySettingsShareAnalysis, subtitle: L10n.securitySettingsShareAnalysisText, isOn: $viewModel.isAnalyticsEnabled, isLoading: $viewModel.isLoading) {
            Task {
              await viewModel.updateAnalyticsStatus()
            }
          }
          .onAppear {
            viewModel.fetchAnalyticsStatus()
          }

          MenuCell(text: L10n.securitySettingsDataAnalysis, disclosureIndicator: .navigation) {
            viewModel.presentInformationView()
          }
          .hasDivider(false)
        }, header: {
          MenuHeader(image: "chart.pie", text: L10n.securitySettingsAnalysisTitle)
        })

        NavigationLink(destination: ChangePinCodeModuleWrapper(delegate: viewModel), isActive: $viewModel.isChangePinCodePresented) {
          EmptyView()
        }

        NavigationLink(destination: BiometricChangeFlowView(isPresented: $viewModel.isBiometricChangeFlowPresented, isBiometricEnabled: viewModel.isBiometricEnabled), isActive: $viewModel.isBiometricChangeFlowPresented) {
          EmptyView()
        }

        NavigationLink(destination: DataInformationView(), isActive: $viewModel.isInformationPresented) {
          EmptyView()
        }
      }
      .padding(.x4)
    }
    .navigationTitle(L10n.settingsSecurity)
    .navigationBackButtonDisplayMode(.minimal)
  }

  private func openLink(_ link: String) {
    guard let url = URL(string: link) else { return }
    UIApplication.shared.open(url)
  }
}
