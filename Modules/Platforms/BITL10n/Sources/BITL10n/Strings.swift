// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - L10n

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// PublicBetaWallet
  public static let appName = L10n.tr("Localizable", "app_name", fallback: "PublicBetaWallet")
  /// Wenn Sie sich schneller anmelden möchten, aktivieren Sie Ihre biometrischen Daten, um dies zu tun.
  public static let biometricSetupDisabledContent = L10n.tr("Localizable", "biometricSetup _disabled_content", fallback: "Wenn Sie sich schneller anmelden möchten, aktivieren Sie Ihre biometrischen Daten, um dies zu tun.")
  /// Zugriff auf Ihre Einstellungen und Konfiguration Ihrer biometrischen Daten
  public static let biometricSetupDisabledDetail = L10n.tr("Localizable", "biometricSetup _disabled_detail", fallback: "Zugriff auf Ihre Einstellungen und Konfiguration Ihrer biometrischen Daten")
  /// Biometrics deaktiviert
  public static let biometricSetupDisabledTitle = L10n.tr("Localizable", "biometricSetup_disabled_title", fallback: "Biometrics deaktiviert")
  /// Überspringen
  public static let biometricSetupDismissButton = L10n.tr("Localizable", "biometricSetup_dismissButton", fallback: "Überspringen")
  /// FaceID
  public static let biometricSetupFaceidText = L10n.tr("Localizable", "biometricSetup_faceid_text", fallback: "FaceID")
  /// Biometrics registrieren
  public static let biometricSetupNoClass3ToSettingsButton = L10n.tr("Localizable", "biometricSetup_noClass3_toSettingsButton", fallback: "Biometrics registrieren")
  /// Sie können weiterhin Ihren Code verwenden, sollte es mit den Biometrics mal nicht klappen.
  public static let biometricSetupReason = L10n.tr("Localizable", "biometricSetup_reason", fallback: "Sie können weiterhin Ihren Code verwenden, sollte es mit den Biometrics mal nicht klappen.")
  /// TouchID
  public static let biometricSetupTouchidText = L10n.tr("Localizable", "biometricSetup_touchid_text", fallback: "TouchID")
  /// Licht an
  public static let cameraQrcodeLight = L10n.tr("Localizable", "camera_qrcode_light", fallback: "Licht an")
  /// Bitte warten
  public static let cameraQrcodeScannerLoader = L10n.tr("Localizable", "camera_qrcode_scanner_loader", fallback: "Bitte warten")
  /// QR Code scannen
  public static let cameraQrcodeScannerPrimary = L10n.tr("Localizable", "camera_qrcode_scanner_primary", fallback: "QR Code scannen")
  /// Zum Ausweisen oder zum Hinzufügen von Nachweisen.
  public static let cameraQrcodeScannerSecondary = L10n.tr("Localizable", "camera_qrcode_scanner_secondary", fallback: "Zum Ausweisen oder zum Hinzufügen von Nachweisen.")
  /// Fortfahren
  public static let cameraPermissionContinueButton = L10n.tr("Localizable", "cameraPermission_continue_button", fallback: "Fortfahren")
  /// Verweigerter Kamerazugriff
  public static let cameraPermissionDeniedPrimary = L10n.tr("Localizable", "cameraPermission_denied_primary", fallback: "Verweigerter Kamerazugriff")
  /// Bitte ändern Sie die notwendigen Berechtigungen in den Geräteeinstellungen.
  ///
  /// Um QR-Codes zu scannen, muss die pilotWallet auf die Kamera zugreifen.
  public static let cameraPermissionDeniedSecondary = L10n.tr("Localizable", "cameraPermission_denied_secondary", fallback: "Bitte ändern Sie die notwendigen Berechtigungen in den Geräteeinstellungen.\n\nUm QR-Codes zu scannen, muss die pilotWallet auf die Kamera zugreifen.")
  /// Zu den Einstellungen
  public static let cameraPermissionDeniedSettingsButton = L10n.tr("Localizable", "cameraPermission_denied_settingsButton", fallback: "Zu den Einstellungen")
  /// Kamerazugriff
  public static let cameraPermissionPrimary = L10n.tr("Localizable", "cameraPermission_primary", fallback: "Kamerazugriff")
  /// Erlauben Sie den Zugriff auf die Kamera für das Scannen von QR-Codes, um Ausweise zu empfangen oder eine Überprüfung durchzuführen.
  public static let cameraPermissionSecondary = L10n.tr("Localizable", "cameraPermission_secondary", fallback: "Erlauben Sie den Zugriff auf die Kamera für das Scannen von QR-Codes, um Ausweise zu empfangen oder eine Überprüfung durchzuführen.")
  /// Wert:
  public static let cellValueAccessibilityLabel = L10n.tr("Localizable", "cell_value_accessibility_label", fallback: "Wert:")
  /// Los
  public static let changeBiometricsActivateButton = L10n.tr("Localizable", "change_biometrics_activate_button", fallback: "Los")
  /// Möchten Sie Biometrics zum Entsperren der pilotWallet aktivieren?
  public static let changeBiometricsContentText = L10n.tr("Localizable", "change_biometrics_content_text", fallback: "Möchten Sie Biometrics zum Entsperren der pilotWallet aktivieren?")
  /// Zu den Einstellungen
  public static let changeBiometricsGoToSettingsButton = L10n.tr("Localizable", "change_biometrics_goToSettings_button", fallback: "Zu den Einstellungen")
  /// Biometrics verwenden
  public static let changeBiometricsHeaderText = L10n.tr("Localizable", "change_biometrics_header_text", fallback: "Biometrics verwenden")
  /// Sie können weiterhin Ihren Code verwenden, sollte es mit den Biometrics mal nicht klappen.
  public static let changeBiometricsInfoText = L10n.tr("Localizable", "change_biometrics_info_text", fallback: "Sie können weiterhin Ihren Code verwenden, sollte es mit den Biometrics mal nicht klappen.")
  /// Einloggen, um die Biometrics Aktivierung zu bestätigen.
  public static let changeBiometricsPinActivationContentText = L10n.tr("Localizable", "change_biometrics_pin_activation_content_text", fallback: "Einloggen, um die Biometrics Aktivierung zu bestätigen.")
  /// Einloggen, um die Biometrics Deaktivierung zu bestätigen.
  public static let changeBiometricsPinDeactivationContentText = L10n.tr("Localizable", "change_biometrics_pin_deactivation_content_text", fallback: "Einloggen, um die Biometrics Deaktivierung zu bestätigen.")
  /// Biometrie
  public static let changeBiometricsTitle = L10n.tr("Localizable", "change_biometrics_title", fallback: "Biometrie")
  /// Akzeptieren
  public static let credentialOfferAcceptButton = L10n.tr("Localizable", "credential_offer_acceptButton", fallback: "Akzeptieren")
  /// Inhalt
  public static let credentialOfferContentSectionTitle = L10n.tr("Localizable", "credential_offer_content_section_title", fallback: "Inhalt")
  /// Möchte 1 Nachweis ausstellen
  public static let credentialOfferHeaderSecondary = L10n.tr("Localizable", "credential_offer_header_secondary", fallback: "Möchte 1 Nachweis ausstellen")
  /// Anfrage ablehnen
  public static let credentialOfferRefuseButton = L10n.tr("Localizable", "credential_offer_refuseButton", fallback: "Anfrage ablehnen")
  /// Fehlermeldungen teilen
  public static let dataAnalysisScreenTitle = L10n.tr("Localizable", "dataAnalysis_screenTitle", fallback: "Fehlermeldungen teilen")
  /// Helfen Sie mit, die pilotWallet zu verbessern, indem Sie erlauben, dass folgende anonymisierte Fehlermeldungen dem Entwicklungsteam zur Verfügung stehen:
  ///
  ///
  /// ✓ Allgemeine Fehlermeldungen
  /// ✓ Kommunikationsfehler
  /// ✓ App Absturz
  ///
  ///
  /// Es werden nur anonymisierte Daten analysiert, die keinen Rückschluss auf Ihre Person erlauben.
  public static let dataAnalysisText = L10n.tr("Localizable", "dataAnalysis_text", fallback: "Helfen Sie mit, die pilotWallet zu verbessern, indem Sie erlauben, dass folgende anonymisierte Fehlermeldungen dem Entwicklungsteam zur Verfügung stehen:\n\n\n✓ Allgemeine Fehlermeldungen\n✓ Kommunikationsfehler\n✓ App Absturz\n\n\nEs werden nur anonymisierte Daten analysiert, die keinen Rückschluss auf Ihre Person erlauben.")
  /// Analyse & Verbesserung
  public static let dataAnalysisTitle = L10n.tr("Localizable", "dataAnalysis_title", fallback: "Analyse & Verbesserung")
  /// Es wurden keine Daten gefunden…
  public static let emptyStateEmptyTitle = L10n.tr("Localizable", "emptyState_emptyTitle", fallback: "Es wurden keine Daten gefunden…")
  /// Ups, irgendetwas ist schief gelaufen!
  public static let emptyStateErrorTitle = L10n.tr("Localizable", "emptyState_errorTitle", fallback: "Ups, irgendetwas ist schief gelaufen!")
  /// Für die gewählte Aktion ist eine Internetverbindung nötig. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es noch einmal.
  public static let emptyStateOfflineMessage = L10n.tr("Localizable", "emptyState_offlineMessage", fallback: "Für die gewählte Aktion ist eine Internetverbindung nötig. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es noch einmal.")
  /// Fehlende Internetverbindung
  public static let emptyStateOfflineTitle = L10n.tr("Localizable", "emptyState_offlineTitle", fallback: "Fehlende Internetverbindung")
  /// Zurück
  public static let globalBack = L10n.tr("Localizable", "global_back", fallback: "Zurück")
  /// Zurück  zur Wallet
  public static let globalBackHome = L10n.tr("Localizable", "global_back_home", fallback: "Zurück  zur Wallet")
  /// Abbrechen
  public static let globalCancel = L10n.tr("Localizable", "global_cancel", fallback: "Abbrechen")
  /// Schliessen
  public static let globalClose = L10n.tr("Localizable", "global_close", fallback: "Schliessen")
  /// Weiter
  public static let globalContinue = L10n.tr("Localizable", "global_continue", fallback: "Weiter")
  /// Zu den Einstellungen
  public static let globalErrorNoDevicePinButton = L10n.tr("Localizable", "global_error_no_device_pin_button", fallback: "Zu den Einstellungen")
  /// Bitte definieren Sie einen Smartphone-Code, damit Sie die pilotWallet verwenden können.
  public static let globalErrorNoDevicePinMessage = L10n.tr("Localizable", "global_error_no_device_pin_message", fallback: "Bitte definieren Sie einen Smartphone-Code, damit Sie die pilotWallet verwenden können.")
  /// Fehlender Smartphone-Code
  public static let globalErrorNoDevicePinTitle = L10n.tr("Localizable", "global_error_no_device_pin_title", fallback: "Fehlender Smartphone-Code")
  /// n/a
  public static let globalNotAssigned = L10n.tr("Localizable", "global_not_assigned", fallback: "n/a")
  /// Nochmals versuchen
  public static let globalRetry = L10n.tr("Localizable", "global_retry", fallback: "Nochmals versuchen")
  /// App Version
  public static let impressumAppVersion = L10n.tr("Localizable", "impressum_app_version", fallback: "App Version")
  /// Build Nummer
  public static let impressumBuildNumber = L10n.tr("Localizable", "impressum_build_number", fallback: "Build Nummer")
  /// Die Autorenschaft übernimmt keinerlei Gewähr hinsichtlich der Zuverlässigkeit und Vollständigkeit der Informationen. Verweise und Links auf Webseiten Dritter liegen ausserhalb unseres Verantwortungsbereichs.
  public static let impressumDisclaimerText = L10n.tr("Localizable", "impressum_disclaimer_text", fallback: "Die Autorenschaft übernimmt keinerlei Gewähr hinsichtlich der Zuverlässigkeit und Vollständigkeit der Informationen. Verweise und Links auf Webseiten Dritter liegen ausserhalb unseres Verantwortungsbereichs.")
  /// Haftungsausschluss
  public static let impressumDisclaimerTitle = L10n.tr("Localizable", "impressum_disclaimer_title", fallback: "Haftungsausschluss")
  /// https://github.com/e-id-admin
  public static let impressumGithubLink = L10n.tr("Localizable", "impressum_github_link", fallback: "https://github.com/e-id-admin")
  /// https://github.com/e-id-admin
  public static let impressumGithubLinkText = L10n.tr("Localizable", "impressum_github_link_text", fallback: "https://github.com/e-id-admin")
  /// Die pilotWallet ist Open-Source. Der Quellcode kann auf GitHub eingesehen werden.
  public static let impressumHeaderText = L10n.tr("Localizable", "impressum_header_text", fallback: "Die pilotWallet ist Open-Source. Der Quellcode kann auf GitHub eingesehen werden.")
  /// https://www.eid.admin.ch/de/pilotwallet-privacy
  public static let impressumLegalsLink = L10n.tr("Localizable", "impressum_legals_link", fallback: "https://www.eid.admin.ch/de/pilotwallet-privacy")
  /// Nutzungsbedingungen
  public static let impressumLegalsLinkText = L10n.tr("Localizable", "impressum_legals_link_text", fallback: "Nutzungsbedingungen")
  /// Rechtliches
  public static let impressumLegalsTitle = L10n.tr("Localizable", "impressum_legals_title", fallback: "Rechtliches")
  /// Herausgeber, Umsetzung und Betrieb
  public static let impressumManagerTitle = L10n.tr("Localizable", "impressum_manager_title", fallback: "Herausgeber, Umsetzung und Betrieb")
  /// https://www.eid.admin.ch/de/pilotprojekte
  public static let impressumMoreInformationLink = L10n.tr("Localizable", "impressum_more_information_link", fallback: "https://www.eid.admin.ch/de/pilotprojekte")
  /// https://www.eid.admin.ch/de/pilotprojekte
  public static let impressumMoreInformationLinkText = L10n.tr("Localizable", "impressum_more_information_link_text", fallback: "https://www.eid.admin.ch/de/pilotprojekte")
  /// Weitere Informationen
  public static let impressumMoreInformationTitle = L10n.tr("Localizable", "impressum_more_information_title", fallback: "Weitere Informationen")
  /// Impressum
  public static let impressumTitle = L10n.tr("Localizable", "impressum_title", fallback: "Impressum")
  /// Unsere App erlaubt es nicht, jailbroken Geräte zu verwenden. Um mögliche Sicherheitslücken zu vermeiden, empfehlen wir Ihnen, Ihr Gerät zu entjailbreaken.
  public static let jailbreakText = L10n.tr("Localizable", "jailbreak_text", fallback: "Unsere App erlaubt es nicht, jailbroken Geräte zu verwenden. Um mögliche Sicherheitslücken zu vermeiden, empfehlen wir Ihnen, Ihr Gerät zu entjailbreaken.")
  /// Wir haben einen Jailbreak auf Ihrem System entdeckt
  public static let jailbreakTitle = L10n.tr("Localizable", "jailbreak_title", fallback: "Wir haben einen Jailbreak auf Ihrem System entdeckt")
  /// Die App verwendet momentan keine Programmbibliotheken.
  public static let licencesEmptyState = L10n.tr("Localizable", "licences_empty_state", fallback: "Die App verwendet momentan keine Programmbibliotheken.")
  /// https://www.eid.admin.ch/de/hilfe-support
  public static let licencesMoreInformationLink = L10n.tr("Localizable", "licences_more_information_link", fallback: "https://www.eid.admin.ch/de/hilfe-support")
  /// Weitere Informationen
  public static let licencesMoreInformationText = L10n.tr("Localizable", "licences_more_information_text", fallback: "Weitere Informationen")
  /// -
  public static let licencesNoVersion = L10n.tr("Localizable", "licences_no_version", fallback: "-")
  /// Nachfolgend die Liste der von dieser App verwendeten Libraries und deren Softwarelizenzen.
  ///
  /// Die Lizenzen folgen den Richtlinien des BIT zur Einhaltung der Privatsphäre und aktuellster Sicherheitsstandards. Mit dieser Liste möchten wir die Transparenz gegenüber den Benutzern gewährleisten.
  public static let licencesText = L10n.tr("Localizable", "licences_text", fallback: "Nachfolgend die Liste der von dieser App verwendeten Libraries und deren Softwarelizenzen.\n\nDie Lizenzen folgen den Richtlinien des BIT zur Einhaltung der Privatsphäre und aktuellster Sicherheitsstandards. Mit dieser Liste möchten wir die Transparenz gegenüber den Benutzern gewährleisten.")
  /// Lizenzen
  public static let licencesTitle = L10n.tr("Localizable", "licences_title", fallback: "Lizenzen")
  /// Weiter
  public static let onboardingContinue = L10n.tr("Localizable", "onboarding_continue", fallback: "Weiter")
  /// Tour starten
  public static let onboardingIntroButtonText = L10n.tr("Localizable", "onboarding_intro_button_text", fallback: "Tour starten")
  /// Ein Service der Schweizerischen Eidgenossenschaft.
  public static let onboardingIntroDetails = L10n.tr("Localizable", "onboarding_intro_details", fallback: "Ein Service der Schweizerischen Eidgenossenschaft.")
  /// Ein sicheres Zuhause für Ihre Nachweise
  public static let onboardingIntroPrimary = L10n.tr("Localizable", "onboarding_intro_primary", fallback: "Ein sicheres Zuhause für Ihre Nachweise")
  /// Willkommen beim Onboarding zur Public Beta Wallet App. Ein sicheres Zuhause für Ihre Nachweise
  public static let onboardingIntroPrimaryAlt = L10n.tr("Localizable", "onboarding_intro_primary_alt", fallback: "Willkommen beim Onboarding zur Public Beta Wallet App. Ein sicheres Zuhause für Ihre Nachweise")
  /// Mit publicBeta haben Sie Ihre Nachweise immer griffbereit.
  public static let onboardingIntroSecondary = L10n.tr("Localizable", "onboarding_intro_secondary", fallback: "Mit publicBeta haben Sie Ihre Nachweise immer griffbereit.")
  /// Code eingeben
  public static let onboardingPinCodeEnterCodeButton = L10n.tr("Localizable", "onboarding_pin_code_enterCodeButton", fallback: "Code eingeben")
  /// Zu viele Fehlversuche. Bitte starten Sie den Prozess neu. Sichern Sie die App, um Ihre Daten zu schützen.
  public static let onboardingPinCodeErrorTooManyAttemptsText = L10n.tr("Localizable", "onboarding_pin_code_error_tooManyAttempts_text", fallback: "Zu viele Fehlversuche. Bitte starten Sie den Prozess neu. Sichern Sie die App, um Ihre Daten zu schützen.")
  /// PIN-Fehler
  public static let onboardingPinCodeErrorTooManyAttemptsTitle = L10n.tr("Localizable", "onboarding_pin_code_error_tooManyAttempts_title", fallback: "PIN-Fehler")
  /// Unknown error...
  public static let onboardingPinCodeErrorUnknown = L10n.tr("Localizable", "onboarding_pin_code_error_unknown", fallback: "Unknown error...")
  /// Sichern Sie Ihre App, damit Ihre Nachweise geschützt sind.
  public static let onboardingPinCodeText = L10n.tr("Localizable", "onboarding_pin_code_text", fallback: "Sichern Sie Ihre App, damit Ihre Nachweise geschützt sind.")
  /// App mit Code sichern
  public static let onboardingPinCodeTitle = L10n.tr("Localizable", "onboarding_pin_code_title", fallback: "App mit Code sichern")
  /// Nachweise einfach vorweisen
  public static let onboardingPresentPrimary = L10n.tr("Localizable", "onboarding_present_primary", fallback: "Nachweise einfach vorweisen")
  /// Anfragen für Nachweise in der App erhalten und sofort beantworten. Sie entscheiden, wer wann welchen Nachweis sehen darf.
  public static let onboardingPresentSecondary = L10n.tr("Localizable", "onboarding_present_secondary", fallback: "Anfragen für Nachweise in der App erhalten und sofort beantworten. Sie entscheiden, wer wann welchen Nachweis sehen darf.")
  /// Erlauben
  public static let onboardingPrivacyAcceptLoggingButton = L10n.tr("Localizable", "onboarding_privacy_acceptLoggingButton", fallback: "Erlauben")
  /// Nicht erlauben
  public static let onboardingPrivacyDeclineLoggingButton = L10n.tr("Localizable", "onboarding_privacy_declineLoggingButton", fallback: "Nicht erlauben")
  /// Datenschutz und Sicherheit
  public static let onboardingPrivacyLinkText = L10n.tr("Localizable", "onboarding_privacy_link_text", fallback: "Datenschutz und Sicherheit")
  /// https://www.eid.admin.ch/de/pilotwallet-privacy
  public static let onboardingPrivacyLinkValue = L10n.tr("Localizable", "onboarding_privacy_link_value", fallback: "https://www.eid.admin.ch/de/pilotwallet-privacy")
  /// Helfen Sie uns, besser zu werden
  public static let onboardingPrivacyPrimary = L10n.tr("Localizable", "onboarding_privacy_primary", fallback: "Helfen Sie uns, besser zu werden")
  /// Erlauben Sie die Weitergabe anonymisierter Nutzungsdaten an unser Entwicklungsteam.
  public static let onboardingPrivacySecondary = L10n.tr("Localizable", "onboarding_privacy_secondary", fallback: "Erlauben Sie die Weitergabe anonymisierter Nutzungsdaten an unser Entwicklungsteam.")
  /// Abschliessen
  public static let onboardingReadyButtonText = L10n.tr("Localizable", "onboarding_ready_buttonText", fallback: "Abschliessen")
  /// Alles bereit
  public static let onboardingReadyPrimary = L10n.tr("Localizable", "onboarding_ready_primary", fallback: "Alles bereit")
  /// Die App ist bereit. Sie können weitere Tipps zur Bedienung erhalten oder diese später in der Hilfe nachlesen.
  public static let onboardingReadySecondary = L10n.tr("Localizable", "onboarding_ready_secondary", fallback: "Die App ist bereit. Sie können weitere Tipps zur Bedienung erhalten oder diese später in der Hilfe nachlesen.")
  /// Die Schweizerische Eidgenossenschaft hat keinen Zugriff auf Ihre Daten.
  public static let onboardingSecurityDetails = L10n.tr("Localizable", "onboarding_security_details", fallback: "Die Schweizerische Eidgenossenschaft hat keinen Zugriff auf Ihre Daten.")
  /// Ihre Daten – bei Ihnen
  public static let onboardingSecurityPrimary = L10n.tr("Localizable", "onboarding_security_primary", fallback: "Ihre Daten – bei Ihnen")
  /// Ihre Nachweise sind ausschliesslich auf Ihrem Gerät gespeichert. Nur Sie haben Zugriff darauf.
  public static let onboardingSecuritySecondary = L10n.tr("Localizable", "onboarding_security_secondary", fallback: "Ihre Nachweise sind ausschliesslich auf Ihrem Gerät gespeichert. Nur Sie haben Zugriff darauf.")
  /// Erneut versuchen
  public static let onboardingSetupErrorButtonText = L10n.tr("Localizable", "onboarding_setupError_buttonText", fallback: "Erneut versuchen")
  /// Etwas ist schiefgelaufen
  public static let onboardingSetupErrorPrimary = L10n.tr("Localizable", "onboarding_setupError_primary", fallback: "Etwas ist schiefgelaufen")
  /// Wir können die App im Moment nicht bereitstellen. Bitte versuchen Sie es  erneut.
  public static let onboardingSetupErrorSecondary = L10n.tr("Localizable", "onboarding_setupError_secondary", fallback: "Wir können die App im Moment nicht bereitstellen. Bitte versuchen Sie es  erneut.")
  /// Aktueller Code
  public static let pinChangeCurrentPasswordTitle = L10n.tr("Localizable", "pin_change_current_password_title", fallback: "Aktueller Code")
  /// Neuen Code bestätigen
  public static let pinChangeNewPinConfirmationTitle = L10n.tr("Localizable", "pin_change_new_pin_confirmation_title", fallback: "Neuen Code bestätigen")
  /// Neuer Code
  public static let pinChangeNewPinTitle = L10n.tr("Localizable", "pin_change_new_pin_title", fallback: "Neuer Code")
  /// Code ändern
  public static let pinChangeTitle = L10n.tr("Localizable", "pin_change_title", fallback: "Code ändern")
  /// Daten übermitteln
  public static let presentationAcceptButtonText = L10n.tr("Localizable", "presentation_accept_button_text", fallback: "Daten übermitteln")
  /// Die Verifizierung wurde abgebrochen. Ihre Daten wurden nicht übertragen.
  public static let presentationDeclinedMessage = L10n.tr("Localizable", "presentation_declined_message", fallback: "Die Verifizierung wurde abgebrochen. Ihre Daten wurden nicht übertragen.")
  /// Abgebrochene Verifizierung
  public static let presentationDeclinedTitle = L10n.tr("Localizable", "presentation_declined_title", fallback: "Abgebrochene Verifizierung")
  /// Anfrage ablehnen
  public static let presentationDenyButtonText = L10n.tr("Localizable", "presentation_deny_button_text", fallback: "Anfrage ablehnen")
  /// Bitte wählen Sie den Nachweis aus, den Sie vorweisen möchten.
  public static let presentationSelectCredentialSubtitle = L10n.tr("Localizable", "presentation_select_credential_subtitle", fallback: "Bitte wählen Sie den Nachweis aus, den Sie vorweisen möchten.")
  /// Welchen Nachweis wollen Sie vorweisen?
  public static let presentationSelectCredentialTitle = L10n.tr("Localizable", "presentation_select_credential_title", fallback: "Welchen Nachweis wollen Sie vorweisen?")
  /// Unbekannter Verifizierer
  public static let presentationVerifierNameUnknown = L10n.tr("Localizable", "presentation_verifier_name_unknown", fallback: "Unbekannter Verifizierer")
  /// Daten
  public static let securitySettingsAnalysisTitle = L10n.tr("Localizable", "securitySettings_analysisTitle", fallback: "Daten")
  /// Biometrie
  public static let securitySettingsBiometrics = L10n.tr("Localizable", "securitySettings_biometrics", fallback: "Biometrie")
  /// Code ändern
  public static let securitySettingsChangePin = L10n.tr("Localizable", "securitySettings_changePin", fallback: "Code ändern")
  /// Weitere Informationen
  public static let securitySettingsDataAnalysis = L10n.tr("Localizable", "securitySettings_dataAnalysis", fallback: "Weitere Informationen")
  /// Datenschutzerklärung
  public static let securitySettingsDataProtection = L10n.tr("Localizable", "securitySettings_dataProtection", fallback: "Datenschutzerklärung")
  /// https://www.eid.admin.ch/de/pilotwallet-privacy
  public static let securitySettingsDataProtectionLink = L10n.tr("Localizable", "securitySettings_dataProtectionLink", fallback: "https://www.eid.admin.ch/de/pilotwallet-privacy")
  /// Sicherheit
  public static let securitySettingsLoginTitle = L10n.tr("Localizable", "securitySettings_loginTitle", fallback: "Sicherheit")
  /// Anonymisierte Fehlermeldungen teilen
  public static let securitySettingsShareAnalysis = L10n.tr("Localizable", "securitySettings_shareAnalysis", fallback: "Anonymisierte Fehlermeldungen teilen")
  /// Helfen Sie mit, Ihre pilotWallet zu verbessern. Erlauben Sie dafür die gelegentliche und anonyme Übermittlung der Diagnosedaten.
  public static let securitySettingsShareAnalysisText = L10n.tr("Localizable", "securitySettings_shareAnalysis_text", fallback: "Helfen Sie mit, Ihre pilotWallet zu verbessern. Erlauben Sie dafür die gelegentliche und anonyme Übermittlung der Diagnosedaten.")
  /// Datenschutz & Sicherheit
  public static let securitySettingsTitle = L10n.tr("Localizable", "securitySettings_title", fallback: "Datenschutz & Sicherheit")
  /// Kontakt
  public static let settingsContact = L10n.tr("Localizable", "settings_contact", fallback: "Kontakt")
  /// https://forms.eid.admin.ch/elfa
  public static let settingsContactLink = L10n.tr("Localizable", "settings_contactLink", fallback: "https://forms.eid.admin.ch/elfa")
  /// Hilfe
  public static let settingsHelp = L10n.tr("Localizable", "settings_help", fallback: "Hilfe")
  /// https://www.eid.admin.ch/de/hilfe-support
  public static let settingsHelpLink = L10n.tr("Localizable", "settings_helpLink", fallback: "https://www.eid.admin.ch/de/hilfe-support")
  /// Impressum
  public static let settingsImpressum = L10n.tr("Localizable", "settings_impressum", fallback: "Impressum")
  /// Sprache
  public static let settingsLanguage = L10n.tr("Localizable", "settings_language", fallback: "Sprache")
  /// Lizenzen
  public static let settingsLicences = L10n.tr("Localizable", "settings_licences", fallback: "Lizenzen")
  /// Datenschutz & Sicherheit
  public static let settingsSecurity = L10n.tr("Localizable", "settings_security", fallback: "Datenschutz & Sicherheit")
  /// Einstellungen
  public static let settingsTitle = L10n.tr("Localizable", "settings_title", fallback: "Einstellungen")
  /// Ihre Einstellungen werden angewendet, das kann bis zu 30 Sekunden dauern.
  public static let storageSetupText = L10n.tr("Localizable", "storageSetup_text", fallback: "Ihre Einstellungen werden angewendet, das kann bis zu 30 Sekunden dauern.")
  /// Einstellungen anwenden
  public static let storageSetupTitle = L10n.tr("Localizable", "storageSetup_title", fallback: "Einstellungen anwenden")
  /// Aktuelles Passwort
  public static let tkChangepasswordError1Note1 = L10n.tr("Localizable", "tk_changepassword_error1_note1", fallback: "Aktuelles Passwort")
  /// Maximallänge von 64 Zeichen erreicht
  public static let tkChangepasswordError2Note2 = L10n.tr("Localizable", "tk_changepassword_error2_note2", fallback: "Maximallänge von 64 Zeichen erreicht")
  /// Neues Passwort bestätigen
  public static let tkChangepasswordError3Note1 = L10n.tr("Localizable", "tk_changepassword_error3_note1", fallback: "Neues Passwort bestätigen")
  /// Die Passwörter stimmen nicht überein. Bitte versuchen Sie es erneut.
  public static let tkChangepasswordError3Note2 = L10n.tr("Localizable", "tk_changepassword_error3_note2", fallback: "Die Passwörter stimmen nicht überein. Bitte versuchen Sie es erneut.")
  /// Zu oft Passwort falsch eingegeben. Erstellen Sie ein neues Passwort.
  public static let tkChangepasswordError4Notification = L10n.tr("Localizable", "tk_changepassword_error4_notification", fallback: "Zu oft Passwort falsch eingegeben. Erstellen Sie ein neues Passwort.")
  /// Passwort ändern
  public static let tkChangepasswordSecurityprivacyBody1 = L10n.tr("Localizable", "tk_changepassword_securityprivacy_body1", fallback: "Passwort ändern")
  /// Fehlermeldungen anonym teilen
  public static let tkChangepasswordSecurityprivacyBody3 = L10n.tr("Localizable", "tk_changepassword_securityprivacy_body3", fallback: "Fehlermeldungen anonym teilen")
  /// Datenschutz & Privatsphäre
  public static let tkChangepasswordSecurityprivacyBody4 = L10n.tr("Localizable", "tk_changepassword_securityprivacy_body4", fallback: "Datenschutz & Privatsphäre")
  /// Login mit Face ID aktivieren
  public static let tkChangepasswordSecurityprivacyIosBody2 = L10n.tr("Localizable", "tk_changepassword_securityprivacy_ios_body2", fallback: "Login mit Face ID aktivieren")
  /// Dies hilft, die App zu verbessern
  public static let tkChangepasswordSecurityprivacySmallbody = L10n.tr("Localizable", "tk_changepassword_securityprivacy_smallbody", fallback: "Dies hilft, die App zu verbessern")
  /// Sicherheit
  public static let tkChangepasswordSecurityprivacySubtitle1 = L10n.tr("Localizable", "tk_changepassword_securityprivacy_subtitle1", fallback: "Sicherheit")
  /// Datenschutz & Privatsphäre
  public static let tkChangepasswordSecurityprivacySubtitle2 = L10n.tr("Localizable", "tk_changepassword_securityprivacy_subtitle2", fallback: "Datenschutz & Privatsphäre")
  /// Sicherheit & Datenschutz
  public static let tkChangepasswordSecurityprivacyTitle = L10n.tr("Localizable", "tk_changepassword_securityprivacy_title", fallback: "Sicherheit & Datenschutz")
  /// Aktuelles Passwort eingeben
  public static let tkChangepasswordStep1CurrentpasswordAlt = L10n.tr("Localizable", "tk_changepassword_step1_currentpassword_alt", fallback: "Aktuelles Passwort eingeben")
  /// Aktuelles Passwort
  public static let tkChangepasswordStep1Note1 = L10n.tr("Localizable", "tk_changepassword_step1_note1", fallback: "Aktuelles Passwort")
  /// Passwort
  public static let tkChangepasswordStep1Note2 = L10n.tr("Localizable", "tk_changepassword_step1_note2", fallback: "Passwort")
  /// Zwischen 6-64 Zeichen
  public static let tkChangepasswordStep2Note2 = L10n.tr("Localizable", "tk_changepassword_step2_note2", fallback: "Zwischen 6-64 Zeichen")
  /// Neues Passwort mit sechs bis vierundsechzig Zeichen eingeben.
  public static let tkChangepasswordStep2PasswordlengthAlt = L10n.tr("Localizable", "tk_changepassword_step2_passwordlength_alt", fallback: "Neues Passwort mit sechs bis vierundsechzig Zeichen eingeben.")
  /// Neues Passwort bestätigen
  public static let tkChangepasswordStep3Note1 = L10n.tr("Localizable", "tk_changepassword_step3_note1", fallback: "Neues Passwort bestätigen")
  /// Passwort erfolgreich geändert
  public static let tkChangepasswordSuccessfulNotification = L10n.tr("Localizable", "tk_changepassword_successful_notification", fallback: "Passwort erfolgreich geändert")
  /// Nachweis
  public static let tkCredentialFallbackTitle = L10n.tr("Localizable", "tk_credential_fallback_title", fallback: "Nachweis")
  /// Dieser Nachweis mit allen dazugehörenden Daten wird auf diesem Gerät komplett gelöscht.
  public static let tkDisplaydeleteCredentialdeleteBody = L10n.tr("Localizable", "tk_displaydelete_credentialdelete_body", fallback: "Dieser Nachweis mit allen dazugehörenden Daten wird auf diesem Gerät komplett gelöscht.")
  /// Nachweis löschen?
  public static let tkDisplaydeleteCredentialdeleteTitle = L10n.tr("Localizable", "tk_displaydelete_credentialdelete_title", fallback: "Nachweis löschen?")
  /// Nachweis löschen
  public static let tkDisplaydeleteCredentialmenuPrimarybutton = L10n.tr("Localizable", "tk_displaydelete_credentialmenu_primarybutton", fallback: "Nachweis löschen")
  /// Zurück nach oben
  public static let tkDisplaydeleteDisplaycredential1Hiddenlink1Text = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_hiddenlink1_text", fallback: "Zurück nach oben")
  /// Zu den persönlichen Angaben
  public static let tkDisplaydeleteDisplaycredential1Hiddenlink2Text = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_hiddenlink2_text", fallback: "Zu den persönlichen Angaben")
  /// Gesamter Verlauf
  public static let tkDisplaydeleteDisplaycredential1Smallbody = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_smallbody", fallback: "Gesamter Verlauf")
  /// Verlauf
  public static let tkDisplaydeleteDisplaycredential1Title1 = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_title1", fallback: "Verlauf")
  /// Details
  public static let tkDisplaydeleteDisplaycredential1Title2 = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_title2", fallback: "Details")
  /// Ergänzungen
  public static let tkDisplaydeleteDisplaycredential1Title3 = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_title3", fallback: "Ergänzungen")
  /// Gültigkeit
  public static let tkDisplaydeleteDisplaycredential1Title4 = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_title4", fallback: "Gültigkeit")
  /// Ausgestellt von
  public static let tkDisplaydeleteDisplaycredential1Title5 = L10n.tr("Localizable", "tk_displaydelete_displaycredential1_title5", fallback: "Ausgestellt von")
  /// Bitte überprüfen Sie Ihre Internetverbindung oder versuchen Sie es später erneut.
  public static let tkErrorConnectionproblemBody = L10n.tr("Localizable", "tk_error_connectionproblem_body", fallback: "Bitte überprüfen Sie Ihre Internetverbindung oder versuchen Sie es später erneut.")
  /// Verbindungsprobleme
  public static let tkErrorConnectionproblemTitle = L10n.tr("Localizable", "tk_error_connectionproblem_title", fallback: "Verbindungsprobleme")
  /// In Ihrer swiyu App hat es noch keinen Nachweis.
  public static let tkErrorEmptywalletBody = L10n.tr("Localizable", "tk_error_emptywallet_body", fallback: "In Ihrer swiyu App hat es noch keinen Nachweis.")
  /// Leere swiyu App
  public static let tkErrorEmptywalletTitle = L10n.tr("Localizable", "tk_error_emptywallet_title", fallback: "Leere swiyu App")
  /// Dieser QR-Code kann nicht verwendet werden.
  public static let tkErrorInvalidqrcodeBody = L10n.tr("Localizable", "tk_error_invalidqrcode_body", fallback: "Dieser QR-Code kann nicht verwendet werden.")
  /// Ungültiger QR-Code
  public static let tkErrorInvalidqrcodeTitle = L10n.tr("Localizable", "tk_error_invalidqrcode_title", fallback: "Ungültiger QR-Code")
  /// Diese Überprüfung kann nicht durchgeführt werden.
  public static let tkErrorInvalidrequestBody = L10n.tr("Localizable", "tk_error_invalidrequest_body", fallback: "Diese Überprüfung kann nicht durchgeführt werden.")
  /// Ungültige Überprüfung
  public static let tkErrorInvalidrequestTitle = L10n.tr("Localizable", "tk_error_invalidrequest_title", fallback: "Ungültige Überprüfung")
  /// Dieser Nachweis kann nicht in die swiyu App hinzugefügt werden.
  public static let tkErrorInvitationcredentialBody = L10n.tr("Localizable", "tk_error_invitationcredential_body", fallback: "Dieser Nachweis kann nicht in die swiyu App hinzugefügt werden.")
  /// Ungültiger Nachweis
  public static let tkErrorInvitationcredentialTitle = L10n.tr("Localizable", "tk_error_invitationcredential_title", fallback: "Ungültiger Nachweis")
  /// In Ihrer swiyu App hat es keinen passenden Nachweis.
  public static let tkErrorNosuchcredentialBody = L10n.tr("Localizable", "tk_error_nosuchcredential_body", fallback: "In Ihrer swiyu App hat es keinen passenden Nachweis.")
  /// Kein passender Nachweis verfügbar
  public static let tkErrorNosuchcredentialTitle = L10n.tr("Localizable", "tk_error_nosuchcredential_title", fallback: "Kein passender Nachweis verfügbar")
  /// Dieser Aussteller ist nicht registriert.
  public static let tkErrorNotregisteredBody = L10n.tr("Localizable", "tk_error_notregistered_body", fallback: "Dieser Aussteller ist nicht registriert.")
  /// Unbekannter Aussteller
  public static let tkErrorNotregisteredTitle = L10n.tr("Localizable", "tk_error_notregistered_title", fallback: "Unbekannter Aussteller")
  /// Dieser QR-Code kann nicht mehr verwendet werden, da er bereits benutzt wurde.
  public static let tkErrorNotusableBody = L10n.tr("Localizable", "tk_error_notusable_body", fallback: "Dieser QR-Code kann nicht mehr verwendet werden, da er bereits benutzt wurde.")
  /// QR-Code nicht mehr gültig
  public static let tkErrorNotusableTitle = L10n.tr("Localizable", "tk_error_notusable_title", fallback: "QR-Code nicht mehr gültig")
  /// Neue Beta-ID wurde hinzugefügt.
  public static let tkGetBetaIdAddedNote = L10n.tr("Localizable", "tk_getBetaId_added_note", fallback: "Neue Beta-ID wurde hinzugefügt.")
  /// Möchte folgenden Nachweis ausstellen:
  public static let tkGetBetaIdApprovalTitle = L10n.tr("Localizable", "tk_getBetaId_approval_title", fallback: "Möchte folgenden Nachweis ausstellen:")
  /// Testen Sie jetzt die Swiss Wallet App und die Vorteile von digitalen Nachweisen.
  ///
  /// Auf der nachfolgenden Webseite können Sie zu Testzwecken individuelle Beta-IDs erstellen und in die Swiss Wallet App importieren.
  public static let tkGetBetaIdCreateBody = L10n.tr("Localizable", "tk_getBetaId_create_body", fallback: "Testen Sie jetzt die Swiss Wallet App und die Vorteile von digitalen Nachweisen.\n\nAuf der nachfolgenden Webseite können Sie zu Testzwecken individuelle Beta-IDs erstellen und in die Swiss Wallet App importieren.")
  /// Beta-ID erstellen
  public static let tkGetBetaIdCreateTitle = L10n.tr("Localizable", "tk_getBetaId_create_title", fallback: "Beta-ID erstellen")
  /// Bitte versuche es noch einmal.
  public static let tkGetBetaIdErrorBody = L10n.tr("Localizable", "tk_getBetaId_error_body", fallback: "Bitte versuche es noch einmal.")
  /// Fehlercode: VXA - 1009
  public static let tkGetBetaIdErrorSmallbody = L10n.tr("Localizable", "tk_getBetaId_error_smallbody", fallback: "Fehlercode: VXA - 1009")
  /// Ups, da ist etwas schiefgelaufen!
  public static let tkGetBetaIdErrorTitle = L10n.tr("Localizable", "tk_getBetaId_error_title", fallback: "Ups, da ist etwas schiefgelaufen!")
  /// Ihr Gerät unterstützt keine Strongbox.
  public static let tkGetBetaIdErrorStrongboxBody = L10n.tr("Localizable", "tk_getBetaId_errorStrongbox_body", fallback: "Ihr Gerät unterstützt keine Strongbox.")
  /// Fehlercode: XYZ - 12345
  public static let tkGetBetaIdErrorStrongboxSmallbody = L10n.tr("Localizable", "tk_getBetaId_errorStrongbox_smallbody", fallback: "Fehlercode: XYZ - 12345")
  /// Strongbox Fehler
  public static let tkGetBetaIdErrorStrongboxTitle = L10n.tr("Localizable", "tk_getBetaId_errorStrongbox_title", fallback: "Strongbox Fehler")
  /// Starten Sie mit dem Erstellen einer Beta-ID.
  public static let tkGetBetaIdFirstUseBody = L10n.tr("Localizable", "tk_getBetaId_firstUse_body", fallback: "Starten Sie mit dem Erstellen einer Beta-ID.")
  /// Noch kein Nachweis hinterlegt.
  public static let tkGetBetaIdFirstUseTitle = L10n.tr("Localizable", "tk_getBetaId_firstUse_title", fallback: "Noch kein Nachweis hinterlegt.")
  /// Hinzufügen
  public static let tkGlobalAdd = L10n.tr("Localizable", "tk_global_add", fallback: "Hinzufügen")
  /// Hinzufügen
  public static let tkGlobalAddPrimarybutton = L10n.tr("Localizable", "tk_global_add_primarybutton", fallback: "Hinzufügen")
  /// Erlauben
  public static let tkGlobalAllow = L10n.tr("Localizable", "tk_global_allow", fallback: "Erlauben")
  /// Erlauben
  public static let tkGlobalAllowPrimarybutton = L10n.tr("Localizable", "tk_global_allow_primarybutton", fallback: "Erlauben")
  /// Zurück
  public static let tkGlobalBackAlt = L10n.tr("Localizable", "tk_global_back_alt", fallback: "Zurück")
  /// Abbrechen
  public static let tkGlobalCancel = L10n.tr("Localizable", "tk_global_cancel", fallback: "Abbrechen")
  /// Abbrechen
  public static let tkGlobalCancelPrimarybutton = L10n.tr("Localizable", "tk_global_cancel_primarybutton", fallback: "Abbrechen")
  /// Passwort ändern
  public static let tkGlobalChangepassword = L10n.tr("Localizable", "tk_global_changepassword", fallback: "Passwort ändern")
  /// Möchte Ihr Alter überprüfen
  public static let tkGlobalCheckage = L10n.tr("Localizable", "tk_global_checkage", fallback: "Möchte Ihr Alter überprüfen")
  /// Möchte Ihren Nachweis überprüfen
  public static let tkGlobalCheckcredential = L10n.tr("Localizable", "tk_global_checkcredential", fallback: "Möchte Ihren Nachweis überprüfen")
  /// Schliessen
  public static let tkGlobalClose = L10n.tr("Localizable", "tk_global_close", fallback: "Schliessen")
  /// Details schliessen
  public static let tkGlobalClosedetailsAlt = L10n.tr("Localizable", "tk_global_closedetails_alt", fallback: "Details schliessen")
  /// Lernfahrausweis schliessen
  public static let tkGlobalCloseelfaAlt = L10n.tr("Localizable", "tk_global_closeelfa_alt", fallback: "Lernfahrausweis schliessen")
  /// QR-Code Scanner schliessen
  public static let tkGlobalClosescanAlt = L10n.tr("Localizable", "tk_global_closescan_alt", fallback: "QR-Code Scanner schliessen")
  /// Warnhinweis schliessen
  public static let tkGlobalClosewarningAlt = L10n.tr("Localizable", "tk_global_closewarning_alt", fallback: "Warnhinweis schliessen")
  /// Passwort bestätigen
  public static let tkGlobalConfirmpassword = L10n.tr("Localizable", "tk_global_confirmpassword", fallback: "Passwort bestätigen")
  /// Weiter
  public static let tkGlobalContinue = L10n.tr("Localizable", "tk_global_continue", fallback: "Weiter")
  /// Nachweis
  public static let tkGlobalCredential = L10n.tr("Localizable", "tk_global_credential", fallback: "Nachweis")
  /// Demo
  public static let tkGlobalCredentialStatusDemo = L10n.tr("Localizable", "tk_global_credential_status_demo", fallback: "Demo")
  /// Demo Nachweis
  public static let tkGlobalCredentialStatusDemoAlt = L10n.tr("Localizable", "tk_global_credential_status_demo_alt", fallback: "Demo Nachweis")
  /// Abgelaufen
  public static let tkGlobalCredentialStatusInvalid = L10n.tr("Localizable", "tk_global_credential_status_invalid", fallback: "Abgelaufen")
  /// Nachweis ist abgelaufen
  public static let tkGlobalCredentialStatusInvalidAlt = L10n.tr("Localizable", "tk_global_credential_status_invalid_alt", fallback: "Nachweis ist abgelaufen")
  /// Entzogen
  public static let tkGlobalCredentialStatusRevoked = L10n.tr("Localizable", "tk_global_credential_status_revoked", fallback: "Entzogen")
  /// Nachweis ist entzogen
  public static let tkGlobalCredentialStatusRevokedAlt = L10n.tr("Localizable", "tk_global_credential_status_revoked_alt", fallback: "Nachweis ist entzogen")
  /// Bald gültig
  public static let tkGlobalCredentialStatusSoon = L10n.tr("Localizable", "tk_global_credential_status_soon", fallback: "Bald gültig")
  /// Nachweis ist bald verfügbar
  public static let tkGlobalCredentialStatusSoonAlt = L10n.tr("Localizable", "tk_global_credential_status_soon_alt", fallback: "Nachweis ist bald verfügbar")
  /// Aktuell gesperrt
  public static let tkGlobalCredentialStatusSuspended = L10n.tr("Localizable", "tk_global_credential_status_suspended", fallback: "Aktuell gesperrt")
  /// Nachweis ist temporär gesperrt
  public static let tkGlobalCredentialStatusSuspendedAlt = L10n.tr("Localizable", "tk_global_credential_status_suspended_alt", fallback: "Nachweis ist temporär gesperrt")
  /// Unbekannt
  public static let tkGlobalCredentialStatusUnknown = L10n.tr("Localizable", "tk_global_credential_status_unknown", fallback: "Unbekannt")
  /// Gültigkeitsstatus unbekannt
  public static let tkGlobalCredentialStatusUnknownAlt = L10n.tr("Localizable", "tk_global_credential_status_unknown_alt", fallback: "Gültigkeitsstatus unbekannt")
  /// Gültig
  public static let tkGlobalCredentialStatusValid = L10n.tr("Localizable", "tk_global_credential_status_valid", fallback: "Gültig")
  /// Nachweis ist gültig
  public static let tkGlobalCredentialStatusValidAlt = L10n.tr("Localizable", "tk_global_credential_status_valid_alt", fallback: "Nachweis ist gültig")
  /// Ablehnen
  public static let tkGlobalDecline = L10n.tr("Localizable", "tk_global_decline", fallback: "Ablehnen")
  /// Ablehnen
  public static let tkGlobalDeclineSecondarybutton = L10n.tr("Localizable", "tk_global_decline_secondarybutton", fallback: "Ablehnen")
  /// Löschen
  public static let tkGlobalDelete = L10n.tr("Localizable", "tk_global_delete", fallback: "Löschen")
  /// Details öffnen
  public static let tkGlobalDetailsAlt = L10n.tr("Localizable", "tk_global_details_alt", fallback: "Details öffnen")
  /// Passwort eingeben
  public static let tkGlobalEnterpassword = L10n.tr("Localizable", "tk_global_enterpassword", fallback: "Passwort eingeben")
  /// Link, um die swiyu App zu verlassen
  public static let tkGlobalExternallinkAlt = L10n.tr("Localizable", "tk_global_externallink_alt", fallback: "Link, um die swiyu App zu verlassen")
  /// Beta-ID erstellen
  public static let tkGlobalGetbetaidPrimarybutton = L10n.tr("Localizable", "tk_global_getbetaid_primarybutton", fallback: "Beta-ID erstellen")
  /// Passwort anzeigen
  public static let tkGlobalInvisibleAlt = L10n.tr("Localizable", "tk_global_invisible_alt", fallback: "Passwort anzeigen")
  /// Login
  public static let tkGlobalLoginPrimarybutton = L10n.tr("Localizable", "tk_global_login_primarybutton", fallback: "Login")
  /// Mit Face ID anmelden
  public static let tkGlobalLoginfaceidPrimarybutton = L10n.tr("Localizable", "tk_global_loginfaceid_primarybutton", fallback: "Mit Face ID anmelden")
  /// Mit Passwort anmelden
  public static let tkGlobalLoginpasswordSecondarybutton = L10n.tr("Localizable", "tk_global_loginpassword_secondarybutton", fallback: "Mit Passwort anmelden")
  /// Logo
  public static let tkGlobalLogoAlt = L10n.tr("Localizable", "tk_global_logo_alt", fallback: "Logo")
  /// Mehr Optionen
  public static let tkGlobalMoreoptionsAlt = L10n.tr("Localizable", "tk_global_moreoptions_alt", fallback: "Mehr Optionen")
  /// ...
  public static let tkGlobalMoreoptionsSecondarybutton = L10n.tr("Localizable", "tk_global_moreoptions_secondarybutton", fallback: "...")
  /// Neues Passwort
  public static let tkGlobalNewpassword = L10n.tr("Localizable", "tk_global_newpassword", fallback: "Neues Passwort")
  /// Nein, Danke
  public static let tkGlobalNo = L10n.tr("Localizable", "tk_global_no", fallback: "Nein, Danke")
  /// Ablehnen
  public static let tkGlobalNotallow = L10n.tr("Localizable", "tk_global_notallow", fallback: "Ablehnen")
  /// Bitte warten
  public static let tkGlobalPleasewait = L10n.tr("Localizable", "tk_global_pleasewait", fallback: "Bitte warten")
  /// Bitte warten. Ihre Angaben werden gesendet
  public static let tkGlobalPleasewaitAlt = L10n.tr("Localizable", "tk_global_pleasewait_alt", fallback: "Bitte warten. Ihre Angaben werden gesendet")
  /// Erneut versuchen
  public static let tkGlobalRepeatPrimarybutton = L10n.tr("Localizable", "tk_global_repeat_primarybutton", fallback: "Erneut versuchen")
  /// Scannen
  public static let tkGlobalScanPrimarybutton = L10n.tr("Localizable", "tk_global_scan_primarybutton", fallback: "Scannen")
  /// Scannen
  public static let tkGlobalScanPrimarybuttonAlt = L10n.tr("Localizable", "tk_global_scan_primarybutton_alt", fallback: "Scannen")
  /// QR-Code scannen
  public static let tkGlobalScanqrcode = L10n.tr("Localizable", "tk_global_scanqrcode", fallback: "QR-Code scannen")
  /// Überspringen
  public static let tkGlobalSkip = L10n.tr("Localizable", "tk_global_skip", fallback: "Überspringen")
  /// Zu den Einstellungen
  public static let tkGlobalTothesettings = L10n.tr("Localizable", "tk_global_tothesettings", fallback: "Zu den Einstellungen")
  /// Passwort ausblenden
  public static let tkGlobalVisibleAlt = L10n.tr("Localizable", "tk_global_visible_alt", fallback: "Passwort ausblenden")
  /// Warnhinweis
  public static let tkGlobalWarningAlt = L10n.tr("Localizable", "tk_global_warning_alt", fallback: "Warnhinweis")
  /// Willkommen zurück
  public static let tkGlobalWelcomeback = L10n.tr("Localizable", "tk_global_welcomeback", fallback: "Willkommen zurück")
  /// Falsche Angaben melden
  public static let tkGlobalWrongdata = L10n.tr("Localizable", "tk_global_wrongdata", fallback: "Falsche Angaben melden")
  /// Fügen Sie Ausweise und Dokumente hinzu, indem Sie den QR-Code scannen oder den SMS-Link öffnen.
  public static let tkHomeEmpthyhomeBody = L10n.tr("Localizable", "tk_home_empthyhome_body", fallback: "Fügen Sie Ausweise und Dokumente hinzu, indem Sie den QR-Code scannen oder den SMS-Link öffnen.")
  /// Leere Wallet
  public static let tkHomeEmpthyhomeTitle = L10n.tr("Localizable", "tk_home_empthyhome_title", fallback: "Leere Wallet")
  /// Fügen Sie Ausweise und Dokumente hinzu, indem Sie den QR-Code scannen oder den SMS-Link öffnen.
  public static let tkHomeFirstuseBody = L10n.tr("Localizable", "tk_home_firstuse_body", fallback: "Fügen Sie Ausweise und Dokumente hinzu, indem Sie den QR-Code scannen oder den SMS-Link öffnen.")
  /// Leere Wallet
  public static let tkHomeFirstuseTitle = L10n.tr("Localizable", "tk_home_firstuse_title", fallback: "Leere Wallet")
  /// swiyu App Startbildschirm
  public static let tkHomeHomescreenAlt = L10n.tr("Localizable", "tk_home_homescreen_alt", fallback: "swiyu App Startbildschirm")
  /// Wiederholen
  public static let tkLoginFacenotrecognised1Body = L10n.tr("Localizable", "tk_login_facenotrecognised1_body", fallback: "Wiederholen")
  /// Erneut mit Face ID versuchen
  public static let tkLoginFacenotrecognised1Primarybutton = L10n.tr("Localizable", "tk_login_facenotrecognised1_primarybutton", fallback: "Erneut mit Face ID versuchen")
  /// Abbrechen
  public static let tkLoginFacenotrecognised1Secondarybutton = L10n.tr("Localizable", "tk_login_facenotrecognised1_secondarybutton", fallback: "Abbrechen")
  /// Gesicht nicht erkannt
  public static let tkLoginFacenotrecognised1Title = L10n.tr("Localizable", "tk_login_facenotrecognised1_title", fallback: "Gesicht nicht erkannt")
  /// Passwort eingeben
  public static let tkLoginFacenotrecognised2Body = L10n.tr("Localizable", "tk_login_facenotrecognised2_body", fallback: "Passwort eingeben")
  /// Passwort eingeben
  public static let tkLoginFacenotrecognised2Primarybutton = L10n.tr("Localizable", "tk_login_facenotrecognised2_primarybutton", fallback: "Passwort eingeben")
  /// Bitte entsperren Sie die App, um fortzufahren.
  public static let tkLoginFailedBody = L10n.tr("Localizable", "tk_login_failed_body", fallback: "Bitte entsperren Sie die App, um fortzufahren.")
  /// Login
  public static let tkLoginFailedTitle = L10n.tr("Localizable", "tk_login_failed_title", fallback: "Login")
  /// Weitere Informationen
  public static let tkLoginForgottenpasswordAlt = L10n.tr("Localizable", "tk_login_forgottenpassword_alt", fallback: "Weitere Informationen")
  /// Versuchen Sie es in 5 Minuten erneut
  public static let tkLoginLockedBody = L10n.tr("Localizable", "tk_login_locked_body", fallback: "Versuchen Sie es in 5 Minuten erneut")
  /// Passwort vergessen?
  public static let tkLoginLockedSecondarybuttonText = L10n.tr("Localizable", "tk_login_locked_secondarybutton_text", fallback: "Passwort vergessen?")
  /// https://www.eid.admin.ch/de
  public static let tkLoginLockedSecondarybuttonValue = L10n.tr("Localizable", "tk_login_locked_secondarybutton_value", fallback: "https://www.eid.admin.ch/de")
  /// Leider ist die swiyu App im Moment nicht verfügbar. Bitte versuchen Sie es später erneut.
  public static let tkLoginLockedTitle = L10n.tr("Localizable", "tk_login_locked_title", fallback: "Leider ist die swiyu App im Moment nicht verfügbar. Bitte versuchen Sie es später erneut.")
  /// Swiyu App Passwort eingeben
  public static let tkLoginPasswordAlt = L10n.tr("Localizable", "tk_login_password_alt", fallback: "Swiyu App Passwort eingeben")
  /// Bitte geben Sie Ihr Passwort ein:
  public static let tkLoginPasswordBody = L10n.tr("Localizable", "tk_login_password_body", fallback: "Bitte geben Sie Ihr Passwort ein:")
  /// Swiyu App mit Face ID entsperren
  public static let tkLoginPasswordFaceidAlt = L10n.tr("Localizable", "tk_login_password_faceid_alt", fallback: "Swiyu App mit Face ID entsperren")
  /// Passwort
  public static let tkLoginPasswordNote = L10n.tr("Localizable", "tk_login_password_note", fallback: "Passwort")
  /// Passwort ist falsch. Bitte versuchen Sie es erneut.
  public static let tkLoginPasswordfailedAlt = L10n.tr("Localizable", "tk_login_passwordfailed_alt", fallback: "Passwort ist falsch. Bitte versuchen Sie es erneut.")
  /// Bitte geben Sie Ihr Passwort ein:
  public static let tkLoginPasswordfailedBody = L10n.tr("Localizable", "tk_login_passwordfailed_body", fallback: "Bitte geben Sie Ihr Passwort ein:")
  /// Falsches Passwort
  public static let tkLoginPasswordfailedIosNotification = L10n.tr("Localizable", "tk_login_passwordfailed_ios_notification", fallback: "Falsches Passwort")
  /// Das Passwort ist falsch. Bitte versuchen Sie es erneut.
  public static let tkLoginPasswordfailedNotification = L10n.tr("Localizable", "tk_login_passwordfailed_notification", fallback: "Das Passwort ist falsch. Bitte versuchen Sie es erneut.")
  /// Erfolgreich eingeloggt. Bitte warten.
  public static let tkLoginSpinnerAlt = L10n.tr("Localizable", "tk_login_spinner_alt", fallback: "Erfolgreich eingeloggt. Bitte warten.")
  /// Die swiyu App ist gesperrt
  public static let tkLoginVariantBody = L10n.tr("Localizable", "tk_login_variant_body", fallback: "Die swiyu App ist gesperrt")
  /// App Absturz
  public static let tkMenuDiagnosticDataAppCrash = L10n.tr("Localizable", "tk_menu_diagnosticData_appCrash", fallback: "App Absturz")
  /// Beim Teilen von Diagnosedaten sendet swyiu gelegentlich anonyme, nicht personenbezogene Informationen. Diese helfen uns, die App stetig zu verbessern und Fehler schneller zu beheben. Ein Rückschluss auf Ihre Person ist nicht möglich.
  public static let tkMenuDiagnosticDataBody = L10n.tr("Localizable", "tk_menu_diagnosticData_body", fallback: "Beim Teilen von Diagnosedaten sendet swyiu gelegentlich anonyme, nicht personenbezogene Informationen. Diese helfen uns, die App stetig zu verbessern und Fehler schneller zu beheben. Ein Rückschluss auf Ihre Person ist nicht möglich.")
  /// Kommunikationsfehler
  public static let tkMenuDiagnosticDataCommunicationError = L10n.tr("Localizable", "tk_menu_diagnosticData_communicationError", fallback: "Kommunikationsfehler")
  /// Allgemeine Fehlermeldungen
  public static let tkMenuDiagnosticDataGeneralError = L10n.tr("Localizable", "tk_menu_diagnosticData_generalError", fallback: "Allgemeine Fehlermeldungen")
  /// Diagnosedaten
  public static let tkMenuDiagnosticDataTitle = L10n.tr("Localizable", "tk_menu_diagnosticData_title", fallback: "Diagnosedaten")
  /// Beta-ID erstellen
  public static let tkMenuHomeListAdd = L10n.tr("Localizable", "tk_menu_homeList_add", fallback: "Beta-ID erstellen")
  /// Hilfe & Kontakt
  public static let tkMenuHomeListHelp = L10n.tr("Localizable", "tk_menu_homeList_help", fallback: "Hilfe & Kontakt")
  /// Einstellungen
  public static let tkMenuHomeListSettings = L10n.tr("Localizable", "tk_menu_homeList_settings", fallback: "Einstellungen")
  /// www.bit.admin.ch
  public static let tkMenuImprintAdminLinkText = L10n.tr("Localizable", "tk_menu_imprint_admin_link_text", fallback: "www.bit.admin.ch")
  /// https://www.bit.admin.ch/de
  public static let tkMenuImprintAdminLinkValue = L10n.tr("Localizable", "tk_menu_imprint_admin_link_value", fallback: "https://www.bit.admin.ch/de")
  /// App Version
  public static let tkMenuImprintAppVersion = L10n.tr("Localizable", "tk_menu_imprint_appVersion", fallback: "App Version")
  /// Build Nummer
  public static let tkMenuImprintBuildNummer = L10n.tr("Localizable", "tk_menu_imprint_buildNummer", fallback: "Build Nummer")
  /// Federal Finance Administration FFA
  /// Federal Office of Information Technology, Systems and Telecommunication FOITT
  public static let tkMenuImprintDepartmentNote = L10n.tr("Localizable", "tk_menu_imprint_department_note", fallback: "Federal Finance Administration FFA\nFederal Office of Information Technology, Systems and Telecommunication FOITT")
  /// Die Autoren übernehmen keinerlei Haftung für die Zuverlässigkeit und Vollständigkeit der Informationen. Verweise und Links zu Websites Dritter liegen außerhalb unseres Verantwortungsbereichs.
  public static let tkMenuImprintDisclaimerNote = L10n.tr("Localizable", "tk_menu_imprint_disclaimer_note", fallback: "Die Autoren übernehmen keinerlei Haftung für die Zuverlässigkeit und Vollständigkeit der Informationen. Verweise und Links zu Websites Dritter liegen außerhalb unseres Verantwortungsbereichs.")
  /// www.github.com/admin-ch
  public static let tkMenuImprintGithubLinkText = L10n.tr("Localizable", "tk_menu_imprint_github_link_text", fallback: "www.github.com/admin-ch")
  /// https://github.com/e-id-admin
  public static let tkMenuImprintGithubLinkValue = L10n.tr("Localizable", "tk_menu_imprint_github_link_value", fallback: "https://github.com/e-id-admin")
  /// Die swiyu ist Open-Source. Ihr Quellcode kann auf GitHub eingesehen werden.
  public static let tkMenuImprintNote = L10n.tr("Localizable", "tk_menu_imprint_note", fallback: "Die swiyu ist Open-Source. Ihr Quellcode kann auf GitHub eingesehen werden.")
  /// Haftungsauschluss
  public static let tkMenuImprintSubtitleDisclaimer = L10n.tr("Localizable", "tk_menu_imprint_subtitle_disclaimer", fallback: "Haftungsauschluss")
  /// Rechtliches
  public static let tkMenuImprintSubtitleLegal = L10n.tr("Localizable", "tk_menu_imprint_subtitle_legal", fallback: "Rechtliches")
  /// Herausgeber, Umsetzung und Betrieb
  public static let tkMenuImprintSubtitlePublisher = L10n.tr("Localizable", "tk_menu_imprint_subtitle_publisher", fallback: "Herausgeber, Umsetzung und Betrieb")
  /// Nutzungsbedingungen
  public static let tkMenuImprintTermsOfUseLinkText = L10n.tr("Localizable", "tk_menu_imprint_termsOfUse_link_text", fallback: "Nutzungsbedingungen")
  /// https://www.eid.admin.ch/de/swiyu-terms
  public static let tkMenuImprintTermsOfUseLinkValue = L10n.tr("Localizable", "tk_menu_imprint_termsOfUse_link_value", fallback: "https://www.eid.admin.ch/de/swiyu-terms")
  /// Impressum
  public static let tkMenuImprintTitle = L10n.tr("Localizable", "tk_menu_imprint_title", fallback: "Impressum")
  /// Sprache
  public static let tkMenuLanguageTitle = L10n.tr("Localizable", "tk_menu_language_title", fallback: "Sprache")
  /// Nachfolgend die Liste der von dieser App verwendeten Softwarelizenzen.
  ///
  /// Die Lizenzen folgen den Richtlinien des BIT zur Einhaltung der Privatsphäre und aktuellster Sicherheitsstandards. Mit dieser Liste möchten wir die Transparenz gegenüber den Benutzern gewährleisten.
  public static let tkMenuLicencesBody = L10n.tr("Localizable", "tk_menu_licences_body", fallback: "Nachfolgend die Liste der von dieser App verwendeten Softwarelizenzen.\n\nDie Lizenzen folgen den Richtlinien des BIT zur Einhaltung der Privatsphäre und aktuellster Sicherheitsstandards. Mit dieser Liste möchten wir die Transparenz gegenüber den Benutzern gewährleisten.")
  /// Weitere Informationen
  public static let tkMenuLicencesLinkText = L10n.tr("Localizable", "tk_menu_licences_link_text", fallback: "Weitere Informationen")
  /// Lizenzen
  public static let tkMenuLicencesTitle = L10n.tr("Localizable", "tk_menu_licences_title", fallback: "Lizenzen")
  /// Biometrische Entsperrung wurde aktiviert.
  public static let tkMenuSecurityPrivacyAndroidStatusActivating = L10n.tr("Localizable", "tk_menu_securityPrivacy_android_status_activating", fallback: "Biometrische Entsperrung wurde aktiviert.")
  /// Diagnosedaten
  public static let tkMenuSecurityPrivacyDataProtectionDiagnosticData = L10n.tr("Localizable", "tk_menu_securityPrivacy_dataProtection_diagnosticData", fallback: "Diagnosedaten")
  /// Datenschutzerklärung
  public static let tkMenuSecurityPrivacyDataProtectionPrivacyPolicy = L10n.tr("Localizable", "tk_menu_securityPrivacy_dataProtection_privacyPolicy", fallback: "Datenschutzerklärung")
  /// Diagnosedaten teilen
  public static let tkMenuSecurityPrivacyDataProtectionShareData = L10n.tr("Localizable", "tk_menu_securityPrivacy_dataProtection_shareData", fallback: "Diagnosedaten teilen")
  /// Helfen Sie uns, swyiu zu verbessern, indem Sie die gelegentliche, anonyme Übermittlung von Informationen wie Fehlermeldungen und Abstürzen zulassen.
  public static let tkMenuSecurityPrivacyDataProtectionShareDataBody = L10n.tr("Localizable", "tk_menu_securityPrivacy_dataProtection_shareData_body", fallback: "Helfen Sie uns, swyiu zu verbessern, indem Sie die gelegentliche, anonyme Übermittlung von Informationen wie Fehlermeldungen und Abstürzen zulassen.")
  /// Face ID erfolgreich aktiviert
  public static let tkMenuSecurityPrivacyIosStatusActivating = L10n.tr("Localizable", "tk_menu_securityPrivacy_ios_status_activating", fallback: "Face ID erfolgreich aktiviert")
  /// Face ID erfolgreich deaktiviert
  public static let tkMenuSecurityPrivacyIosStatusDeactivating = L10n.tr("Localizable", "tk_menu_securityPrivacy_ios_status_deactivating", fallback: "Face ID erfolgreich deaktiviert")
  /// Face ID ist auf diesem Gerät nicht aktiviert. Gehen Sie in die Geräteeinstellungen um Biometrie zu aktivieren.
  public static let tkMenuSecurityPrivacyMenuIosUnlockBody = L10n.tr("Localizable", "tk_menu_securityPrivacy_menu_ios_unlock_body", fallback: "Face ID ist auf diesem Gerät nicht aktiviert. Gehen Sie in die Geräteeinstellungen um Biometrie zu aktivieren.")
  /// Passwort ändern
  public static let tkMenuSecurityPrivacySecurityChangePassword = L10n.tr("Localizable", "tk_menu_securityPrivacy_security_changePassword", fallback: "Passwort ändern")
  /// Mit Face ID entsperren
  public static let tkMenuSecurityPrivacySecurityIosUnlock = L10n.tr("Localizable", "tk_menu_securityPrivacy_security_ios_unlock", fallback: "Mit Face ID entsperren")
  /// Datenschutz & Privatsphäre
  public static let tkMenuSecurityPrivacySubtitleDataProtection = L10n.tr("Localizable", "tk_menu_securityPrivacy_subtitle_dataProtection", fallback: "Datenschutz & Privatsphäre")
  /// Sicherheit
  public static let tkMenuSecurityPrivacySubtitleSecurity = L10n.tr("Localizable", "tk_menu_securityPrivacy_subtitle_security", fallback: "Sicherheit")
  /// Sicherheit & Datenschutz
  public static let tkMenuSecurityPrivacyTitle = L10n.tr("Localizable", "tk_menu_securityPrivacy_title", fallback: "Sicherheit & Datenschutz")
  /// Allgemein
  public static let tkMenuSettingSubtitleGeneral = L10n.tr("Localizable", "tk_menu_setting_subtitle_general", fallback: "Allgemein")
  /// Einstellungen
  public static let tkMenuSettingTitle = L10n.tr("Localizable", "tk_menu_setting_title", fallback: "Einstellungen")
  /// Feedback mitteilen
  public static let tkMenuSettingWalletFeedback = L10n.tr("Localizable", "tk_menu_setting_wallet_feedback", fallback: "Feedback mitteilen")
  /// Hilfe & Kontakt
  public static let tkMenuSettingWalletHelp = L10n.tr("Localizable", "tk_menu_setting_wallet_help", fallback: "Hilfe & Kontakt")
  /// Impressum
  public static let tkMenuSettingWalletImprint = L10n.tr("Localizable", "tk_menu_setting_wallet_imprint", fallback: "Impressum")
  /// Sprache
  public static let tkMenuSettingWalletLanguage = L10n.tr("Localizable", "tk_menu_setting_wallet_language", fallback: "Sprache")
  /// Deutsch
  public static let tkMenuSettingWalletLanguageChoiceDe = L10n.tr("Localizable", "tk_menu_setting_wallet_languageChoiceDe", fallback: "Deutsch")
  /// Lizenzen
  public static let tkMenuSettingWalletLicences = L10n.tr("Localizable", "tk_menu_setting_wallet_licences", fallback: "Lizenzen")
  /// Sicherheit & Datenschutz
  public static let tkMenuSettingWalletSecurity = L10n.tr("Localizable", "tk_menu_setting_wallet_security", fallback: "Sicherheit & Datenschutz")
  /// Feedback mitteilen
  public static let tkMenuSetupMenuFeedback = L10n.tr("Localizable", "tk_menu_setup_menu_feedback", fallback: "Feedback mitteilen")
  /// Wallet
  public static let tkMenuSetupSubtitleWallet = L10n.tr("Localizable", "tk_menu_setup_subtitle_wallet", fallback: "Wallet")
  /// Ihre swiyu App ist jetzt optimal geschützt vor unerlaubtem Zugriff.
  public static let tkOnboardingAllsetBody = L10n.tr("Localizable", "tk_onboarding_allset_body", fallback: "Ihre swiyu App ist jetzt optimal geschützt vor unerlaubtem Zugriff.")
  /// Alles eingerichtet
  public static let tkOnboardingAllsetTitle = L10n.tr("Localizable", "tk_onboarding_allset_title", fallback: "Alles eingerichtet")
  /// Ihre Einstellungen werden übernommen. Das kann bis zu 30 Sekunden dauern.
  public static let tkOnboardingApplysettingsBody = L10n.tr("Localizable", "tk_onboarding_applysettings_body", fallback: "Ihre Einstellungen werden übernommen. Das kann bis zu 30 Sekunden dauern.")
  /// Einen kleinen Moment...
  public static let tkOnboardingApplysettingsTitle = L10n.tr("Localizable", "tk_onboarding_applysettings_title", fallback: "Einen kleinen Moment...")
  /// Möchten Sie Face ID zum Entsperren der App verwenden?
  public static let tkOnboardingBiometricios1Body = L10n.tr("Localizable", "tk_onboarding_biometricios1_body", fallback: "Möchten Sie Face ID zum Entsperren der App verwenden?")
  /// Ja, verwenden
  public static let tkOnboardingBiometricios1Primarybutton = L10n.tr("Localizable", "tk_onboarding_biometricios1_primarybutton", fallback: "Ja, verwenden")
  /// Falls Face ID nicht funktioniert, können Sie weiterhin Ihr Passwort verwenden.
  public static let tkOnboardingBiometricios1Smallbody = L10n.tr("Localizable", "tk_onboarding_biometricios1_smallbody", fallback: "Falls Face ID nicht funktioniert, können Sie weiterhin Ihr Passwort verwenden.")
  /// Face ID verwenden
  public static let tkOnboardingBiometricios1Title = L10n.tr("Localizable", "tk_onboarding_biometricios1_title", fallback: "Face ID verwenden")
  /// Möchten Sie Face ID zum Entsperren der swiyu App verwenden?
  public static let tkOnboardingBiometricios3Body = L10n.tr("Localizable", "tk_onboarding_biometricios3_body", fallback: "Möchten Sie Face ID zum Entsperren der swiyu App verwenden?")
  /// Falls Face ID nicht funktioniert, können Sie weiterhin Ihr Passwort verwenden.
  public static let tkOnboardingBiometricios3Smallbody = L10n.tr("Localizable", "tk_onboarding_biometricios3_smallbody", fallback: "Falls Face ID nicht funktioniert, können Sie weiterhin Ihr Passwort verwenden.")
  /// Face ID verwenden
  public static let tkOnboardingBiometricios3Title = L10n.tr("Localizable", "tk_onboarding_biometricios3_title", fallback: "Face ID verwenden")
  /// Face ID
  public static let tkOnboardingBiometricios4Title = L10n.tr("Localizable", "tk_onboarding_biometricios4_title", fallback: "Face ID")
  /// Zwischen 6-64 Zeichen
  public static let tkOnboardingCharactersNote = L10n.tr("Localizable", "tk_onboarding_characters_note", fallback: "Zwischen 6-64 Zeichen")
  /// Passwort besteht aus sechs bis vierundsechzig Zeichen
  public static let tkOnboardingCode2Alt = L10n.tr("Localizable", "tk_onboarding_code2_alt", fallback: "Passwort besteht aus sechs bis vierundsechzig Zeichen")
  /// Profitieren Sie von einer App, die auf Ihre Bedürfnisse abgestimmt ist. Möchten Sie dafür Ihre anonymen Nutzungsdaten mit dem Entwicklungsteam teilen?
  public static let tkOnboardingImprovementBody = L10n.tr("Localizable", "tk_onboarding_improvement_body", fallback: "Profitieren Sie von einer App, die auf Ihre Bedürfnisse abgestimmt ist. Möchten Sie dafür Ihre anonymen Nutzungsdaten mit dem Entwicklungsteam teilen?")
  /// Datenschutz und Sicherheit
  public static let tkOnboardingImprovementLinkText = L10n.tr("Localizable", "tk_onboarding_improvement_link_text", fallback: "Datenschutz und Sicherheit")
  /// https://www.eid.admin.ch/de/swiyu-privacy
  public static let tkOnboardingImprovementLinkValue = L10n.tr("Localizable", "tk_onboarding_improvement_link_value", fallback: "https://www.eid.admin.ch/de/swiyu-privacy")
  /// Anonym zur Verbesserung der App beitragen
  public static let tkOnboardingImprovementTitle = L10n.tr("Localizable", "tk_onboarding_improvement_title", fallback: "Anonym zur Verbesserung der App beitragen")
  /// Dank der swiyu App tragen Sie Ihre Ausweise immer bei sich auf Ihrem Handy.
  public static let tkOnboardingNeverforgetBody = L10n.tr("Localizable", "tk_onboarding_neverforget_body", fallback: "Dank der swiyu App tragen Sie Ihre Ausweise immer bei sich auf Ihrem Handy.")
  /// Nie mehr den Ausweis vergessen
  public static let tkOnboardingNeverforgetTitle = L10n.tr("Localizable", "tk_onboarding_neverforget_title", fallback: "Nie mehr den Ausweis vergessen")
  /// Bitte bestätigen Sie das Passwort
  public static let tkOnboardingNopasswordmismatchAlt = L10n.tr("Localizable", "tk_onboarding_nopasswordmismatch_alt", fallback: "Bitte bestätigen Sie das Passwort")
  /// Die Passwörter stimmen nicht überein. Bitte versuchen Sie es erneut.
  public static let tkOnboardingNopasswordmismatchNotification = L10n.tr("Localizable", "tk_onboarding_nopasswordmismatch_notification", fallback: "Die Passwörter stimmen nicht überein. Bitte versuchen Sie es erneut.")
  /// Passwort ist leer
  public static let tkOnboardingPasswordErrorEmpty = L10n.tr("Localizable", "tk_onboarding_password_error_empty", fallback: "Passwort ist leer")
  /// Falsches Passwort
  public static let tkOnboardingPasswordErrorMismatch = L10n.tr("Localizable", "tk_onboarding_password_error_mismatch", fallback: "Falsches Passwort")
  /// Passwort
  public static let tkOnboardingPasswordPlaceholder = L10n.tr("Localizable", "tk_onboarding_password_placeholder", fallback: "Passwort")
  /// Das Passwort wurde zu oft falsch eingegeben. Bitte erstellen Sie ein neues Passwort.
  public static let tkOnboardingPassworderrorBody = L10n.tr("Localizable", "tk_onboarding_passworderror_body", fallback: "Das Passwort wurde zu oft falsch eingegeben. Bitte erstellen Sie ein neues Passwort.")
  /// Passwort erstellen
  public static let tkOnboardingPassworderrorPrimarybutton = L10n.tr("Localizable", "tk_onboarding_passworderror_primarybutton", fallback: "Passwort erstellen")
  /// Einrichten des Passworts hat nicht geklappt
  public static let tkOnboardingPassworderrorTitle = L10n.tr("Localizable", "tk_onboarding_passworderror_title", fallback: "Einrichten des Passworts hat nicht geklappt")
  /// Das Passwort muss zwischen 6 und 64 Zeichen lang sein.
  public static let tkOnboardingPasswordlengthNotification = L10n.tr("Localizable", "tk_onboarding_passwordlength_notification", fallback: "Das Passwort muss zwischen 6 und 64 Zeichen lang sein.")
  /// Schützen Sie Ihre App vor unerlaubtem Zugriff.
  public static let tkOnboardingSecurewithcodeBody = L10n.tr("Localizable", "tk_onboarding_securewithcode_body", fallback: "Schützen Sie Ihre App vor unerlaubtem Zugriff.")
  /// Passwort eingeben
  public static let tkOnboardingSecurewithcodePrimarybutton = L10n.tr("Localizable", "tk_onboarding_securewithcode_primarybutton", fallback: "Passwort eingeben")
  /// App mit Passwort sichern
  public static let tkOnboardingSecurewithcodeTitle = L10n.tr("Localizable", "tk_onboarding_securewithcode_title", fallback: "App mit Passwort sichern")
  /// Die swiyu App kann im Moment leider nicht bereitstellt werden. Bitte versuchen Sie es erneut.
  public static let tkOnboardingSomethingwentwrongBody = L10n.tr("Localizable", "tk_onboarding_somethingwentwrong_body", fallback: "Die swiyu App kann im Moment leider nicht bereitstellt werden. Bitte versuchen Sie es erneut.")
  /// Erneut versuchen
  public static let tkOnboardingSomethingwentwrongPrimarybutton = L10n.tr("Localizable", "tk_onboarding_somethingwentwrong_primarybutton", fallback: "Erneut versuchen")
  /// Etwas hat nicht geklappt
  public static let tkOnboardingSomethingwentwrongTitle = L10n.tr("Localizable", "tk_onboarding_somethingwentwrong_title", fallback: "Etwas hat nicht geklappt")
  /// Willkommen zum Onboarding der swiyu App.
  public static let tkOnboardingStartAlt = L10n.tr("Localizable", "tk_onboarding_start_alt", fallback: "Willkommen zum Onboarding der swiyu App.")
  /// Ihre Ausweisdaten werden verschlüsselt und lokal in der swiyu App auf Ihrem Handy gespeichert.
  public static let tkOnboardingStartBody = L10n.tr("Localizable", "tk_onboarding_start_body", fallback: "Ihre Ausweisdaten werden verschlüsselt und lokal in der swiyu App auf Ihrem Handy gespeichert.")
  /// Starten
  public static let tkOnboardingStartPrimarybutton = L10n.tr("Localizable", "tk_onboarding_start_primarybutton", fallback: "Starten")
  /// Digitale Ausweise sicher aufbewahren
  public static let tkOnboardingStartTitle = L10n.tr("Localizable", "tk_onboarding_start_title", fallback: "Digitale Ausweise sicher aufbewahren")
  /// Sie haben die Kontrolle darüber, wer wann Ihre Ausweisdaten überprüfen darf. Ohne Einwilligung kein Zugriff.
  public static let tkOnboardingYourdataBody = L10n.tr("Localizable", "tk_onboarding_yourdata_body", fallback: "Sie haben die Kontrolle darüber, wer wann Ihre Ausweisdaten überprüfen darf. Ohne Einwilligung kein Zugriff.")
  /// Mehr über die SSI-Technologie lernen
  public static let tkOnboardingYourdataLinkText = L10n.tr("Localizable", "tk_onboarding_yourdata_link_text", fallback: "Mehr über die SSI-Technologie lernen")
  /// Ihre Daten gehören Ihnen
  public static let tkOnboardingYourdataTitle = L10n.tr("Localizable", "tk_onboarding_yourdata_title", fallback: "Ihre Daten gehören Ihnen")
  /// Ihre Angaben wurden erfolgreich überprüft.
  public static let tkPresentAcceptTitle = L10n.tr("Localizable", "tk_present_accept_title", fallback: "Ihre Angaben wurden erfolgreich überprüft.")
  /// Erforderlicher Nachweis vorhanden
  public static let tkPresentAcceptTitle2 = L10n.tr("Localizable", "tk_present_accept_title2", fallback: "Erforderlicher Nachweis vorhanden")
  /// Erforderliches Alter nicht erfüllt
  public static let tkPresentAgenotmetTitle = L10n.tr("Localizable", "tk_present_agenotmet_title", fallback: "Erforderliches Alter nicht erfüllt")
  /// Angeforderte Angaben
  public static let tkPresentApprovalTitle = L10n.tr("Localizable", "tk_present_approval_title", fallback: "Angeforderte Angaben")
  /// Fehlercode: VXA - 1009
  public static let tkPresentCanceledverificationSmallbody = L10n.tr("Localizable", "tk_present_canceledverification_smallbody", fallback: "Fehlercode: VXA - 1009")
  /// Die Verifizierung wurde abgebrochen und keine Daten wurden übertragen.
  public static let tkPresentCanceledverificationSubtitle = L10n.tr("Localizable", "tk_present_canceledverification_subtitle", fallback: "Die Verifizierung wurde abgebrochen und keine Daten wurden übertragen.")
  /// Abgebrochene Verifizierung
  public static let tkPresentCanceledverificationTitle = L10n.tr("Localizable", "tk_present_canceledverification_title", fallback: "Abgebrochene Verifizierung")
  /// Bestätigung
  public static let tkPresentConfirmAlt = L10n.tr("Localizable", "tk_present_confirm_alt", fallback: "Bestätigung")
  /// Daten wurden nicht übermittelt
  public static let tkPresentDeclineTitle = L10n.tr("Localizable", "tk_present_decline_title", fallback: "Daten wurden nicht übermittelt")
  /// Fehlercode: VXA - 1009
  public static let tkPresentErrorSmallbody = L10n.tr("Localizable", "tk_present_error_smallbody", fallback: "Fehlercode: VXA - 1009")
  /// Bitte versuche es noch einmal.
  public static let tkPresentErrorSubtitle = L10n.tr("Localizable", "tk_present_error_subtitle", fallback: "Bitte versuche es noch einmal.")
  /// Ups, da ist etwas schiefgelaufen!
  public static let tkPresentErrorTitle = L10n.tr("Localizable", "tk_present_error_title", fallback: "Ups, da ist etwas schiefgelaufen!")
  /// Ausweis oder Dokument auswählen
  public static let tkPresentMultiplecredentialsTitle = L10n.tr("Localizable", "tk_present_multiplecredentials_title", fallback: "Ausweis oder Dokument auswählen")
  /// Leider konnten keine Angaben gesendet werden.
  public static let tkPresentNoinformationprovidedTitle = L10n.tr("Localizable", "tk_present_noinformationprovided_title", fallback: "Leider konnten keine Angaben gesendet werden.")
  /// Warnung
  public static let tkPresentWarningAlt = L10n.tr("Localizable", "tk_present_warning_alt", fallback: "Warnung")
  /// Dieser QR-Code wurde bereits verwendet. Bestellen Sie einen neuen QR-Code.
  public static let tkQrscannerInvalidcodeBody = L10n.tr("Localizable", "tk_qrscanner_invalidcode_body", fallback: "Dieser QR-Code wurde bereits verwendet. Bestellen Sie einen neuen QR-Code.")
  /// Wurde dieser QR-Code ohne Ihr Wissen verwendet?
  public static let tkQrscannerInvalidcodeLinkText = L10n.tr("Localizable", "tk_qrscanner_invalidcode_link_text", fallback: "Wurde dieser QR-Code ohne Ihr Wissen verwendet?")
  /// QR-Code nicht mehr gültig
  public static let tkQrscannerInvalidcodeTitle = L10n.tr("Localizable", "tk_qrscanner_invalidcode_title", fallback: "QR-Code nicht mehr gültig")
  /// Licht aus. Zum Einschalten doppelt tippen
  public static let tkQrscannerLightoffLabel = L10n.tr("Localizable", "tk_qrscanner_lightoff_label", fallback: "Licht aus. Zum Einschalten doppelt tippen")
  /// Licht an. Zum Ausschalten doppelt tippen
  public static let tkQrscannerLightonLabel = L10n.tr("Localizable", "tk_qrscanner_lighton_label", fallback: "Licht an. Zum Ausschalten doppelt tippen")
  /// Licht an
  public static let tkQrscannerLightonTitle = L10n.tr("Localizable", "tk_qrscanner_lighton_title", fallback: "Licht an")
  /// Mehr Licht nötig
  public static let tkQrscannerMorelightneededTitle = L10n.tr("Localizable", "tk_qrscanner_morelightneeded_title", fallback: "Mehr Licht nötig")
  /// QR-Code wurde gescannt
  public static let tkQrscannerProcessingAlt = L10n.tr("Localizable", "tk_qrscanner_processing_alt", fallback: "QR-Code wurde gescannt")
  /// Dieser QR-Code kann nicht mehr verwendet werden, da er bereits benutzt wurde.
  public static let tkQrscannerReceiveNotusableBody = L10n.tr("Localizable", "tk_qrscanner_receive_notusable_body", fallback: "Dieser QR-Code kann nicht mehr verwendet werden, da er bereits benutzt wurde.")
  /// QR-Code nicht mehr gültig
  public static let tkQrscannerReceiveNotusableTitle = L10n.tr("Localizable", "tk_qrscanner_receive_notusable_title", fallback: "QR-Code nicht mehr gültig")
  /// Um sich auszuweisen oder Ausweise und Dokumente hinzuzufügen.
  public static let tkQrscannerScanningBody = L10n.tr("Localizable", "tk_qrscanner_scanning_body", fallback: "Um sich auszuweisen oder Ausweise und Dokumente hinzuzufügen.")
  /// QR-Code scannen
  public static let tkQrscannerScanningTitle = L10n.tr("Localizable", "tk_qrscanner_scanning_title", fallback: "QR-Code scannen")
  /// Zu den Details
  public static let tkReceiveApprovalHiddenlinkText = L10n.tr("Localizable", "tk_receive_approval_hiddenlink_text", fallback: "Zu den Details")
  /// Die Kamera ist eine wichtige Funktion. Ohne Kamera können Sie keine Ausweise und Dokumente empfangen oder sich damit ausweisen.
  public static let tkReceiveCameraaccessneeded1Body = L10n.tr("Localizable", "tk_receive_cameraaccessneeded1_body", fallback: "Die Kamera ist eine wichtige Funktion. Ohne Kamera können Sie keine Ausweise und Dokumente empfangen oder sich damit ausweisen.")
  /// Zugriff auf Kamera erlauben
  public static let tkReceiveCameraaccessneeded1Title = L10n.tr("Localizable", "tk_receive_cameraaccessneeded1_title", fallback: "Zugriff auf Kamera erlauben")
  /// Der Kamerazugriff ist abgelaufen. Bitte erlauben Sie den Zugriff erneut.
  public static let tkReceiveCameraaccessneeded2Body = L10n.tr("Localizable", "tk_receive_cameraaccessneeded2_body", fallback: "Der Kamerazugriff ist abgelaufen. Bitte erlauben Sie den Zugriff erneut.")
  /// Bitte ändern Sie die notwendigen Berechtigungen in den Geräteeinstellungen.
  ///
  /// Um QR-Codes zu scannen, muss die App auf die Kamera zugreifen.
  public static let tkReceiveCameraaccessneeded3Body = L10n.tr("Localizable", "tk_receive_cameraaccessneeded3_body", fallback: "Bitte ändern Sie die notwendigen Berechtigungen in den Geräteeinstellungen.\n\nUm QR-Codes zu scannen, muss die App auf die Kamera zugreifen.")
  /// Zugriff auf Kamera erlauben
  public static let tkReceiveCameraaccessneeded3Title = L10n.tr("Localizable", "tk_receive_cameraaccessneeded3_title", fallback: "Zugriff auf Kamera erlauben")
  /// Die swiyu App möchte auf Ihre Kamera zugreifen
  public static let tkReceiveCameraaccessneeded4Title = L10n.tr("Localizable", "tk_receive_cameraaccessneeded4_title", fallback: "Die swiyu App möchte auf Ihre Kamera zugreifen")
  /// Wenn Sie den Nachweis jetzt ablehnen, wird er sofort ungültig.
  ///
  /// Um einen neuen Nachweis zu erhalten, müssen Sie ihn erneut bestellen.
  public static let tkReceiveDeny1Body = L10n.tr("Localizable", "tk_receive_deny1_body", fallback: "Wenn Sie den Nachweis jetzt ablehnen, wird er sofort ungültig.\n\nUm einen neuen Nachweis zu erhalten, müssen Sie ihn erneut bestellen.")
  /// Nachweis ablehnen
  public static let tkReceiveDeny1Primarybutton = L10n.tr("Localizable", "tk_receive_deny1_primarybutton", fallback: "Nachweis ablehnen")
  /// Nachweis ablehnen?
  public static let tkReceiveDeny1Title = L10n.tr("Localizable", "tk_receive_deny1_title", fallback: "Nachweis ablehnen?")
  /// Nachweis abgelehnt
  public static let tkReceiveDeny2Title = L10n.tr("Localizable", "tk_receive_deny2_title", fallback: "Nachweis abgelehnt")
  /// Sie können den Nachweis entweder hinzufügen oder ablehnen.
  ///
  /// Falls Sie den Nachweis akzeptieren möchten:
  /// 1. Öffnen Sie die Detailansicht des fehlerhaften Nachweises.
  /// 2. Klicken Sie erneut auf «Falsche Daten melden».
  /// 3. Folgen Sie der Anleitung.
  public static let tkReceiveIncorrectdataBody = L10n.tr("Localizable", "tk_receive_incorrectdata_body", fallback: "Sie können den Nachweis entweder hinzufügen oder ablehnen.\n\nFalls Sie den Nachweis akzeptieren möchten:\n1. Öffnen Sie die Detailansicht des fehlerhaften Nachweises.\n2. Klicken Sie erneut auf «Falsche Daten melden».\n3. Folgen Sie der Anleitung.")
  /// Aussteller:in
  public static let tkReceiveIncorrectdataIssuer = L10n.tr("Localizable", "tk_receive_incorrectdata_issuer", fallback: "Aussteller:in")
  /// Falsche Daten melden
  public static let tkReceiveIncorrectdataLinkText = L10n.tr("Localizable", "tk_receive_incorrectdata_link_text", fallback: "Falsche Daten melden")
  /// Falsche Angaben gefunden?
  public static let tkReceiveIncorrectdataSubtitle = L10n.tr("Localizable", "tk_receive_incorrectdata_subtitle", fallback: "Falsche Angaben gefunden?")
  /// Falsche Daten
  public static let tkReceiveIncorrectdataTitle = L10n.tr("Localizable", "tk_receive_incorrectdata_title", fallback: "Falsche Daten")
  /// Nicht-Verifiziert
  public static let tkReceiveNotTrustedIssuerText = L10n.tr("Localizable", "tk_receive_not_trusted_issuer_text", fallback: "Nicht-Verifiziert")
  /// Kamera sucht QR-Code
  public static let tkReceiveScanningAlt = L10n.tr("Localizable", "tk_receive_scanning_alt", fallback: "Kamera sucht QR-Code")
  /// Kein QR-Code gefunden. Versuchen Sie die Kamera neu zu positionieren.
  public static let tkReceiveScanningNotfoundAlt = L10n.tr("Localizable", "tk_receive_scanning_notfound_alt", fallback: "Kein QR-Code gefunden. Versuchen Sie die Kamera neu zu positionieren.")
  /// Verifiziert
  public static let tkReceiveTrustedIssuerText = L10n.tr("Localizable", "tk_receive_trusted_issuer_text", fallback: "Verifiziert")
  /// Aus Sicherheitsgründen können Sie die swiyu App auf diesem Gerät nicht benutzen.
  public static let tkUnsafedeviceUnsafeBody = L10n.tr("Localizable", "tk_unsafedevice_unsafe_body", fallback: "Aus Sicherheitsgründen können Sie die swiyu App auf diesem Gerät nicht benutzen.")
  /// Falls Sie die swiyu App nutzen möchten:
  /// Setzen Sie dieses Gerät auf die Werkseinstellungen zurückoder installieren Sie die Original-Firmware.
  public static let tkUnsafedeviceUnsafeSmallbody = L10n.tr("Localizable", "tk_unsafedevice_unsafe_smallbody", fallback: "Falls Sie die swiyu App nutzen möchten:\nSetzen Sie dieses Gerät auf die Werkseinstellungen zurückoder installieren Sie die Original-Firmware.")
  /// Die swiyu App kann nicht benutzt werden
  public static let tkUnsafedeviceUnsafeTitle = L10n.tr("Localizable", "tk_unsafedevice_unsafe_title", fallback: "Die swiyu App kann nicht benutzt werden")
  /// App aktualisieren
  public static let versionEnforcementButton = L10n.tr("Localizable", "version_enforcement_button", fallback: "App aktualisieren")
  /// https://www.eid.admin.ch
  public static let versionEnforcementStoreLink = L10n.tr("Localizable", "version_enforcement_store_link", fallback: "https://www.eid.admin.ch")

  /// Möchten Sie %@ zum Entsperren der App aktivieren?
  public static func biometricSetupContent(_ p1: Any) -> String {
    L10n.tr("Localizable", "biometricSetup _content", String(describing: p1), fallback: "Möchten Sie %@ zum Entsperren der App aktivieren?")
  }

  /// Sie können weiterhin Ihren Code verwenden, sollte es mit der %@ mal nicht klappen.
  public static func biometricSetupDetail(_ p1: Any) -> String {
    L10n.tr("Localizable", "biometricSetup _detail", String(describing: p1), fallback: "Sie können weiterhin Ihren Code verwenden, sollte es mit der %@ mal nicht klappen.")
  }

  /// Mit %@
  public static func biometricSetupActionButton(_ p1: Any) -> String {
    L10n.tr("Localizable", "biometricSetup_actionButton", String(describing: p1), fallback: "Mit %@")
  }

  /// %@, Doppeltippen zum Schließen
  public static func biometricSetupErrorAltText(_ p1: Any) -> String {
    L10n.tr("Localizable", "biometricSetup_error_altText", String(describing: p1), fallback: "%@, Doppeltippen zum Schließen")
  }

  /// %@ verwenden
  public static func biometricSetupTitle(_ p1: Any) -> String {
    L10n.tr("Localizable", "biometricSetup_title", String(describing: p1), fallback: "%@ verwenden")
  }

  /// Sie können weiterhin Ihren Code verwenden, sollte es mit der %@ mal nicht klappen.
  public static func onboardingBiometricPermissionReason(_ p1: Any) -> String {
    L10n.tr("Localizable", "onboarding_biometric_permission_reason", String(describing: p1), fallback: "Sie können weiterhin Ihren Code verwenden, sollte es mit der %@ mal nicht klappen.")
  }

  /// %@, Doppeltippen zum Schließen
  public static func onboardingPinCodeErrorAltText(_ p1: Any) -> String {
    L10n.tr("Localizable", "onboarding_pin_code_error_altText", String(describing: p1), fallback: "%@, Doppeltippen zum Schließen")
  }

  /// Das Passwort ist falsch. Sie haben noch %@ Versuche.
  public static func tkChangepasswordError1IosNote2(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_changepassword_error1_ios_note2", String(describing: p1), fallback: "Das Passwort ist falsch. Sie haben noch %@ Versuche.")
  }

  /// In %@ Tagen gültig
  public static func tkGlobalCredentialStatusValidindaysIos(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_global_credential_status_validindays_ios", String(describing: p1), fallback: "In %@ Tagen gültig")
  }

  /// Nachweis ist in %@ Tage gültig
  public static func tkGlobalCredentialStatusValidindaysIosAlt(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_global_credential_status_validindays_ios_alt", String(describing: p1), fallback: "Nachweis ist in %@ Tage gültig")
  }

  /// Möchte %@ Angaben lesen
  public static func tkGlobalReadnumberIos(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_global_readnumber_ios", String(describing: p1), fallback: "Möchte %@ Angaben lesen")
  }

  /// Sie haben noch %@ Versuche
  public static func tkGlobalTryIos(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_global_try_ios", String(describing: p1), fallback: "Sie haben noch %@ Versuche")
  }

  /// Inhaltsliste %@ Nachweise enthalten
  public static func tkHomeHomeIosAlt(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_home_home_ios_alt", String(describing: p1), fallback: "Inhaltsliste %@ Nachweise enthalten")
  }

  /// Versuchen Sie es in %@ Sekunden erneut.
  public static func tkLoginLockedBodySeconds(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_login_locked_body_seconds", String(describing: p1), fallback: "Versuchen Sie es in %@ Sekunden erneut.")
  }

  /// Bitte in %@ Sekunden erneut versuchen
  public static func tkLoginLockedSeconds(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_login_locked_seconds", String(describing: p1), fallback: "Bitte in %@ Sekunden erneut versuchen")
  }

  /// Sie haben noch %@ Versuche
  public static func tkLoginPasswordfailedIosSubtitle(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_login_passwordfailed_ios_subtitle", String(describing: p1), fallback: "Sie haben noch %@ Versuche")
  }

  /// swiyu-Password eingeben, um %@ zu aktivieren.
  public static func tkMenuActivatingBiometricsIosBody(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_menu_activatingBiometrics_ios_body", String(describing: p1), fallback: "swiyu-Password eingeben, um %@ zu aktivieren.")
  }

  /// Mit  %@  entsperren
  public static func tkMenuActivatingBiometricsIosTitle(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_menu_activatingBiometrics_ios_title", String(describing: p1), fallback: "Mit  %@  entsperren")
  }

  /// swiyu-Password eingeben, um %@ zu deaktivieren.
  public static func tkMenuDeactivatingBiometricsIosNote(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_menu_deactivatingBiometrics_ios_note", String(describing: p1), fallback: "swiyu-Password eingeben, um %@ zu deaktivieren.")
  }

  /// %@ deaktivieren
  public static func tkMenuDeactivatingBiometricsIosTitle(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_menu_deactivatingBiometrics_ios_title", String(describing: p1), fallback: "%@ deaktivieren")
  }

  /// Pin Code enthält %@ Zeichen von insgesamt sechs
  public static func tkOnboardingCode3Alt(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_onboarding_code3_alt", String(describing: p1), fallback: "Pin Code enthält %@ Zeichen von insgesamt sechs")
  }

  /// %@ Zeichen eingegeben
  public static func tkOnboardingCodeIosAlt(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_onboarding_code_ios_alt", String(describing: p1), fallback: "%@ Zeichen eingegeben")
  }

  /// Passwort ist zu kurz, mindestens %@ Zeichen
  public static func tkOnboardingPasswordErrorTooShort(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_onboarding_password_error_too_short", String(describing: p1), fallback: "Passwort ist zu kurz, mindestens %@ Zeichen")
  }

  /// Möchte %@ Angaben lesen
  public static func tkPresentMultiplecredentialsIosSubtitle(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_present_multiplecredentials_ios_subtitle", String(describing: p1), fallback: "Möchte %@ Angaben lesen")
  }

  /// möchte %@ Nachweis(e) ausstellen
  public static func tkReceiveApprovalIosSubtitle(_ p1: Any) -> String {
    L10n.tr("Localizable", "tk_receive_approval_ios_subtitle", String(describing: p1), fallback: "möchte %@ Nachweis(e) ausstellen")
  }

}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// MARK: - BundleToken

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

// swiftlint:enable convenience_type
