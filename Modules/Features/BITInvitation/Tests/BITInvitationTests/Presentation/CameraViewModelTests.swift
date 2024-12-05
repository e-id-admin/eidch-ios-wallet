import BITNetworking
import Factory
import Foundation
import Spyable
import XCTest

@testable import BITAnyCredentialFormat
@testable import BITAnyCredentialFormatMocks
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITInvitation
@testable import BITOpenID
@testable import BITPresentation
@testable import BITSdJWTMocks
@testable import BITTestingCore

// MARK: - CameraViewModelTests

final class CameraViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {

    Container.shared.validateCredentialOfferInvitationUrlUseCase.register { self.validateCredentialOfferInvitationUrlUseCase }
    Container.shared.fetchRequestObjectUseCase.register { self.fetchRequestObjectUseCase }
    Container.shared.checkInvitationTypeUseCase.register { self.checkInvitationTypeUseCase }
    Container.shared.getCompatibleCredentialsUseCase.register { self.getCompatibleCredentialsUseCase }
    Container.shared.fetchMetadataUseCase.register { self.fetchMetadataUseCase }
    Container.shared.fetchCredentialUseCase.register { self.fetchCredentialUseCase }
    Container.shared.saveCredentialUseCase.register { self.saveCredentialUseCase }
    Container.shared.checkAndUpdateCredentialStatusUseCase.register { self.checkAndUpdateCredentialStatusUseCase }
    Container.shared.getCredentialsCountUseCase.register { self.getCredentialsCountUseCase }
    Container.shared.fetchTrustStatementUseCase.register { self.fetchTrustStatementUseCase }
    Container.shared.denyPresentationUseCase.register { self.denyPresentationUseCase }
    Container.shared.validateRequestObjectUseCase.register { self.validateRequestObjectUseCase }
    Container.shared.createAnyCredentialUseCase.register { self.createAnyCredentialUseCase }

    mockRequestObject = .Mock.VcSdJwt.sample
    mockCredentialWithKeyBinding = CredentialWithKeyBinding(anyCredential: MockAnyCredential(), boundTo: nil)
    viewModel = createViewModel(mode: .qr)
  }

  @MainActor
  func testWithInitialData() async {
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertTrue(viewModel.isTipPresented)
    XCTAssertFalse(viewModel.isPopupErrorPresented)
    XCTAssertNil(viewModel.qrScannerError)
    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isScannerActive)
  }

  // MARK: - Issuing

  @MainActor
  func testValidateCredentialOfferSuccess() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = mockCredentialWithKeyBinding
    saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    createAnyCredentialUseCase.executeFromFormatReturnValue = mockAnyCredential
    fetchTrustStatementUseCase.executeCredentialReturnValue = .Mock.sample

    await viewModel.setMetadataUrl(url)

    XCTAssertTrue(router.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isPopupErrorPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(mockCredentialWithKeyBinding.anyCredential.raw, saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReceivedArguments?.credentialWithKeyBinding.anyCredential.raw)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.format, credential.format)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.payload, credential.payload)
    XCTAssertEqual(fetchTrustStatementUseCase.executeCredentialReceivedCredential?.issuer, mockAnyCredential.issuer)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  @MainActor
  func testValidateCredentialOfferSuccess_withRouter() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    let viewModel = CameraViewModel(router: router)

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = mockCredentialWithKeyBinding
    saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReturnValue = credential
    createAnyCredentialUseCase.executeFromFormatReturnValue = mockAnyCredential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    fetchTrustStatementUseCase.executeCredentialReturnValue = .Mock.sample

    await viewModel.setMetadataUrl(url)

    XCTAssertTrue(router.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(1, fetchMetadataUseCase.executeFromCallsCount)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(1, fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount)
    XCTAssertTrue(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertEqual(1, saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.format, credential.format)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.payload, credential.payload)
    XCTAssertEqual(fetchTrustStatementUseCase.executeCredentialReceivedCredential?.issuer, mockAnyCredential.issuer)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  @MainActor
  func testValidateCredentialOfferSuccess_deeplink() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample
    let expectation = XCTestExpectation(description: "Async operation completes")

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = mockCredentialWithKeyBinding
    saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReturnValue = credential
    createAnyCredentialUseCase.executeFromFormatReturnValue = MockAnyCredential()
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForClosure = { credential in
      expectation.fulfill()
      return credential
    }
    fetchTrustStatementUseCase.executeCredentialReturnValue = .Mock.sample

    viewModel = createViewModel(mode: .deeplink(url: url))

    await fulfillment(of: [expectation], timeout: 5.0)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(1, fetchMetadataUseCase.executeFromCallsCount)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(1, fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount)
    XCTAssertTrue(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertEqual(1, saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertEqual(1, checkAndUpdateCredentialStatusUseCase.executeForCallsCount)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.format, credential.format)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.payload, credential.payload)
    XCTAssertEqual(fetchTrustStatementUseCase.executeCredentialReceivedCredential?.issuer, mockAnyCredential.issuer)
  }

  @MainActor
  func testValidateCredentialOfferFailure() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeThrowableError = ValidateCredentialOfferInvitationUrlError.unexpectedScheme

    viewModel.isTorchEnabled = true
    viewModel.isTorchEnabled = true

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertTrue(viewModel.isTorchEnabled)
    XCTAssertTrue(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTipPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  @MainActor
  func testValidateCredentialOfferVerificationFailure() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = FetchCredentialError.verificationFailed

    viewModel.isTorchEnabled = true

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .unavailableCredential)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTipPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(fetchMetadataUseCase.executeFromCallsCount, 1)

    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount, 1)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  @MainActor
  func testFetchCredentialExpired() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = FetchCredentialError.expiredInvitation

    viewModel.isTorchEnabled = true

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .expiredInvitation)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTipPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertEqual(1, validateCredentialOfferInvitationUrlUseCase.executeCallsCount)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertEqual(fetchMetadataUseCase.executeFromCallsCount, 1)

    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCallsCount, 1)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  @MainActor
  func testValidateCredentialOffer_fetchTrustStatement_failure() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = mockCredentialWithKeyBinding
    saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    createAnyCredentialUseCase.executeFromFormatReturnValue = MockAnyCredential()
    fetchTrustStatementUseCase.executeCredentialThrowableError = TestingError.error

    await viewModel.setMetadataUrl(url)

    XCTAssertTrue(router.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isPopupErrorPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertTrue(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertEqual(mockCredentialWithKeyBinding.anyCredential.raw, saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReceivedArguments?.credentialWithKeyBinding.anyCredential.raw)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertTrue(fetchTrustStatementUseCase.executeCredentialCalled)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  @MainActor
  func testValidateCredentialOffer_CreateAnyCredential_failure() async {
    let mockCredentialOffer: CredentialOffer = .Mock.sample
    let credential: Credential = .Mock.sample

    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = mockCredentialOffer
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = mockCredentialWithKeyBinding
    saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReturnValue = credential
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = credential
    createAnyCredentialUseCase.executeFromFormatThrowableError = TestingError.error

    await viewModel.setMetadataUrl(url)

    XCTAssertTrue(router.didCallCredentialOffer)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isPopupErrorPresented)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)

    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertEqual(mockCredentialWithKeyBinding.anyCredential.raw, saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReceivedArguments?.credentialWithKeyBinding.anyCredential.raw)
    XCTAssertTrue(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.format, credential.format)
    XCTAssertEqual(createAnyCredentialUseCase.executeFromFormatReceivedArguments?.payload, credential.payload)

    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
  }

  // MARK: - Presentation

  @MainActor
  func testValidatePresentationWithOneCredentialSuccess() async throws {
    let context = PresentationRequestContext.Mock.vcSdJwtSample

    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = context.requestObject
    validateRequestObjectUseCase.executeReturnValue = true
    // swiftlint: disable all
    getCompatibleCredentialsUseCase.executeUsingReturnValue = [context.requestObject.presentationDefinition.inputDescriptors.first!.id: [.Mock.BIT]]
    // swiftlint: enable all

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(router.didCallPresentationReview)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isPopupErrorPresented)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertTrue(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeUsingCallsCount)
    XCTAssertEqual(context.requestObject, getCompatibleCredentialsUseCase.executeUsingReceivedRequestObject)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertTrue(validateRequestObjectUseCase.executeCalled)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, context.requestObject)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testValidatePresentationWithJWTRequestObjectSuccess() async throws {
    let context = PresentationRequestContext.Mock.vcSdJwtJwtSample

    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = context.requestObject
    validateRequestObjectUseCase.executeReturnValue = true
    fetchTrustStatementUseCase.executeJwtRequestObjectReturnValue = .Mock.sample

    // swiftlint: disable all
    getCompatibleCredentialsUseCase.executeUsingReturnValue = [context.requestObject.presentationDefinition.inputDescriptors.first!.id: [.Mock.BIT]]
    // swiftlint: enable all

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(router.didCallPresentationReview)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isPopupErrorPresented)

    XCTAssertEqual(checkInvitationTypeUseCase.executeUrlReceivedUrl, url)
    XCTAssertEqual(fetchRequestObjectUseCase.executeReceivedUrl, url)
    XCTAssertEqual(getCompatibleCredentialsUseCase.executeUsingReceivedRequestObject, context.requestObject)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, context.requestObject)
    XCTAssertEqual(fetchTrustStatementUseCase.executeJwtRequestObjectReceivedJwtRequestObject, (context.requestObject as? JWTRequestObject))
  }

  @MainActor
  func testValidatePresentationWithMultipleCredentialSuccess() async throws {
    let context = PresentationRequestContext.Mock.vcSdJwtSample
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = context.requestObject
    validateRequestObjectUseCase.executeReturnValue = true

    // swiftlint: disable all
    getCompatibleCredentialsUseCase.executeUsingReturnValue = [context.requestObject.presentationDefinition.inputDescriptors.first!.id: CompatibleCredential.Mock.array]
    // swiftlint: enable all

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(router.didCallCompatibleCredentials)
    XCTAssertFalse(router.didCallPresentationReview)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isPopupErrorPresented)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertTrue(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeUsingCallsCount)
    XCTAssertEqual(context.requestObject, getCompatibleCredentialsUseCase.executeUsingReceivedRequestObject)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertTrue(validateRequestObjectUseCase.executeCalled)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, context.requestObject)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testValidatePresentationFailure() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeThrowableError = TestingError.error

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertFalse(viewModel.isTipPresented)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(0, getCompatibleCredentialsUseCase.executeUsingCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertFalse(validateRequestObjectUseCase.executeCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testValidatePresentationEmptyCompatibleCredentialsFailure() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject
    getCompatibleCredentialsUseCase.executeUsingThrowableError = CompatibleCredentialsError.noCompatibleCredentials
    validateRequestObjectUseCase.executeReturnValue = true

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)

    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .noCompatibleCredentials)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTipPresented)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertTrue(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeUsingCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertTrue(validateRequestObjectUseCase.executeCalled)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, mockRequestObject)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testValidatePresentationInvalidInvitationFail() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeThrowableError = FetchRequestObjectError.invalidPresentationInvitation

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertEqual(1, checkInvitationTypeUseCase.executeUrlCallsCount)

    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertEqual(1, fetchRequestObjectUseCase.executeCallsCount)

    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(0, getCompatibleCredentialsUseCase.executeUsingCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertFalse(validateRequestObjectUseCase.executeCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testEmptyWalletPath() async throws {
    getCompatibleCredentialsUseCase.executeUsingThrowableError = CompatibleCredentialsError.noCredentialsInWallet
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject
    validateRequestObjectUseCase.executeReturnValue = true

    // swiftlint: disable all
    await viewModel.setMetadataUrl(.init(string: "http://")!)
    // swiftlint: enable all

    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .noCredentialsInWallet)
    XCTAssertTrue(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeUsingCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertTrue(validateRequestObjectUseCase.executeCalled)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, mockRequestObject)
  }

  @MainActor
  func testNoCompatibleCredentialsPath() async throws {
    getCompatibleCredentialsUseCase.executeUsingThrowableError = CompatibleCredentialsError.noCompatibleCredentials
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = mockRequestObject
    validateRequestObjectUseCase.executeReturnValue = true

    // swiftlint: disable all
    await viewModel.setMetadataUrl(.init(string: "http://")!)
    // swiftlint: enable all

    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .noCompatibleCredentials)
    XCTAssertTrue(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertEqual(1, getCompatibleCredentialsUseCase.executeUsingCallsCount)

    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertTrue(validateRequestObjectUseCase.executeCalled)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, mockRequestObject)
  }

  @MainActor
  func testFetchMetadataFailed_networkError() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = .Mock.sample
    fetchMetadataUseCase.executeFromThrowableError = NetworkError(status: .noConnection)
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenReturnValue = mockCredentialWithKeyBinding

    await viewModel.setMetadataUrl(url)

    assertsNoInternetConnexion()
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
  }

  @MainActor
  func testFetchCredentialFailed_networkError() async {
    checkInvitationTypeUseCase.executeUrlReturnValue = .credentialOffer
    validateCredentialOfferInvitationUrlUseCase.executeReturnValue = .Mock.sample
    fetchMetadataUseCase.executeFromReturnValue = .Mock.sample
    fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenThrowableError = NetworkError(status: .noConnection)
    saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperReturnValue = .Mock.sample
    checkAndUpdateCredentialStatusUseCase.executeForReturnValue = .Mock.sample

    await viewModel.setMetadataUrl(url)

    assertsNoInternetConnexion()
    XCTAssertTrue(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
  }

  @MainActor
  func testSubmitPresentationFailed_networkError() async throws {
    let context = PresentationRequestContext.Mock.vcSdJwtSample

    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeThrowableError = NetworkError(status: .noConnection)
    // swiftlint: disable all
    getCompatibleCredentialsUseCase.executeUsingReturnValue = [context.requestObject.presentationDefinition.inputDescriptors.first!.id: [.Mock.BIT]]
    // swiftlint: enable all

    await viewModel.setMetadataUrl(url)

    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .noInternetConnexion)
    XCTAssertFalse(router.didCallCompatibleCredentials)
    XCTAssertFalse(router.didCallPresentationReview)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }

  @MainActor
  func testSubmitPresentationWithInvalidRequestObject() async throws {
    let context = PresentationRequestContext.Mock.vcSdJwtSample

    // swiftlint: disable all
    getCompatibleCredentialsUseCase.executeUsingReturnValue = [context.requestObject.presentationDefinition.inputDescriptors.first!.id: [.Mock.BIT]]
    // swiftlint: enable all
    checkInvitationTypeUseCase.executeUrlReturnValue = .presentation
    fetchRequestObjectUseCase.executeReturnValue = context.requestObject
    validateRequestObjectUseCase.executeReturnValue = false

    await viewModel.setMetadataUrl(url)

    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCredentialsCountUseCase.executeCalled)
    XCTAssertFalse(router.didCallCompatibleCredentials)
    XCTAssertFalse(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(fetchCredentialUseCase.executeFromMetadataWrapperCredentialOfferAccessTokenCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)

    XCTAssertTrue(validateRequestObjectUseCase.executeCalled)
    XCTAssertEqual(validateRequestObjectUseCase.executeReceivedRequestObject, context.requestObject)
    XCTAssertTrue(denyPresentationUseCase.executeContextErrorCalled)
    XCTAssertEqual(denyPresentationUseCase.executeContextErrorReceivedArguments?.error, .invalidRequest)
  }

  @MainActor
  func testClose() async {
    viewModel.close()

    XCTAssertTrue(router.closeCalled)
  }

  @MainActor
  func testCloseErrorView() async {
    viewModel.closeErrorView()

    XCTAssertFalse(viewModel.isPopupErrorPresented)
  }

  @MainActor
  func testCloseTipView() async {
    viewModel.closeTipView()

    XCTAssertFalse(viewModel.isTipPresented)
  }

  @MainActor
  func testShowErrorView() async {
    viewModel.showErrorView()

    XCTAssertFalse(viewModel.isTipPresented)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertTrue(viewModel.isScannerActive)
  }

  @MainActor
  func testOnAppearWithCredentials() async {
    getCredentialsCountUseCase.executeReturnValue = 2

    await viewModel.onAppear()

    XCTAssertFalse(viewModel.isTipPresented)
  }

  @MainActor
  func testOnAppearWithoutCredentials() async {
    getCredentialsCountUseCase.executeReturnValue = 0

    await viewModel.onAppear()

    XCTAssertTrue(viewModel.isTipPresented)
  }

  @MainActor
  func testOnAppearWithError() async {
    getCredentialsCountUseCase.executeThrowableError = TestingError.error

    await viewModel.onAppear()

    XCTAssertTrue(viewModel.isTipPresented)
  }

  // MARK: Private

  // swiftlint: disable all
  private var validateCredentialOfferInvitationUrlUseCase = ValidateCredentialOfferInvitationUrlUseCaseProtocolSpy()
  private var fetchRequestObjectUseCase = FetchRequestObjectUseCaseProtocolSpy()
  private var checkInvitationTypeUseCase = CheckInvitationTypeUseCaseProtocolSpy()
  private var getCompatibleCredentialsUseCase = GetCompatibleCredentialsUseCaseProtocolSpy()
  private var fetchMetadataUseCase = FetchMetadataUseCaseProtocolSpy()
  private var fetchCredentialUseCase = FetchCredentialUseCaseProtocolSpy()
  private var saveCredentialUseCase = SaveCredentialUseCaseProtocolSpy()
  private var checkAndUpdateCredentialStatusUseCase = CheckAndUpdateCredentialStatusUseCaseProtocolSpy()
  private var getCredentialsCountUseCase = GetCredentialsCountUseCaseProtocolSpy()
  private var fetchTrustStatementUseCase = FetchTrustStatementUseCaseProtocolSpy()
  private var denyPresentationUseCase = DenyPresentationUseCaseProtocolSpy()
  private var validateRequestObjectUseCase = ValidateRequestObjectUseCaseProtocolSpy()
  private var createAnyCredentialUseCase = CreateAnyCredentialUseCaseProtocolSpy()
  private var mockRequestObject: RequestObject!
  private var mockAnyCredential = MockAnyCredential()
  private var router = InvitationRouterMock()

  private var viewModel: CameraViewModel!
  private var mockCredentialWithKeyBinding: CredentialWithKeyBinding!
  private let url = URL(string: "openid-credential-offer://url")!
  private let scannerDelay: UInt64 = 0
  // swiftlint: enable all
}

extension CameraViewModelTests {

  private enum InvitationMode: Equatable {
    case deeplink(url: URL)
    case qr
  }

  @MainActor
  private func createViewModel(mode: InvitationMode = .qr) -> CameraViewModel {
    switch mode {
    case .qr: .init(router: router)
    case .deeplink(let url): .init(url: url, router: router)
    }
  }

  @MainActor
  private func assertsNoInternetConnexion() {
    XCTAssertNil(viewModel.offer)
    XCTAssertTrue(viewModel.isPopupErrorPresented)
    XCTAssertEqual(viewModel.qrScannerError as? CameraViewModel.CameraError, .noInternetConnexion)
    XCTAssertFalse(router.didCallCompatibleCredentials)
    XCTAssertFalse(router.didCallPresentationReview)
    XCTAssertFalse(viewModel.isTorchEnabled)
    XCTAssertFalse(viewModel.isTorchEnabled)

    XCTAssertEqual(url, validateCredentialOfferInvitationUrlUseCase.executeReceivedUrl)
    XCTAssertTrue(validateCredentialOfferInvitationUrlUseCase.executeCalled)
    XCTAssertTrue(checkInvitationTypeUseCase.executeUrlCalled)
    XCTAssertTrue(fetchMetadataUseCase.executeFromCalled)
    XCTAssertFalse(saveCredentialUseCase.executeCredentialWithKeyBindingMetadataWrapperCalled)
    XCTAssertFalse(checkAndUpdateCredentialStatusUseCase.executeForCalled)
    XCTAssertFalse(fetchRequestObjectUseCase.executeCalled)
    XCTAssertFalse(getCompatibleCredentialsUseCase.executeUsingCalled)
    XCTAssertFalse(validateRequestObjectUseCase.executeCalled)
    XCTAssertFalse(denyPresentationUseCase.executeContextErrorCalled)
  }
}
