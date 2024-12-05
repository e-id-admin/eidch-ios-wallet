import Factory
import Foundation
import Spyable
import XCTest

@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITCredentialShared
@testable import BITInvitation
@testable import BITOpenID
@testable import BITTestingCore

// MARK: - CredentialOfferViewModelTests

@MainActor
final class CredentialOfferViewModelTests: XCTestCase {

  // swiftlint:disable all
  var viewModel: CredentialOfferViewModel!
  var credential: Credential = .Mock.sample
  var trustStatement: TrustStatement? = .Mock.validSample
  var router: MockRoutes!
  var delayAfterAcceptingCredential: UInt64 = 0
  var deleteCredentialUseCase = DeleteCredentialUseCaseProtocolSpy()
  var getCredentialIssuerDisplayUseCase = GetCredentialIssuerDisplayUseCaseProtocolSpy()

  // swiftlint:enable all

  override func setUp() {
    router = MockRoutes()

    Container.shared.delayAfterAcceptingCredential.register { self.delayAfterAcceptingCredential }
    Container.shared.deleteCredentialUseCase.register { self.deleteCredentialUseCase }
    Container.shared.getCredentialIssuerDisplayUseCase.register { self.getCredentialIssuerDisplayUseCase }

    viewModel = CredentialOfferViewModel(credential: credential, router: router)
  }

  func testInitValuesWithTrustStatement() async {
    viewModel = CredentialOfferViewModel(credential: credential, trustStatement: trustStatement, router: router)

    XCTAssertEqual(viewModel.credential, credential)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
    XCTAssertNotEqual(viewModel.issuerDisplay, credential.preferredIssuerDisplay)
    XCTAssertEqual(viewModel.state, .result)
    XCTAssertEqual(viewModel.issuerTrustStatus, .verified)
    XCTAssertTrue(getCredentialIssuerDisplayUseCase.executeForTrustStatementCalled)
    XCTAssertEqual(getCredentialIssuerDisplayUseCase.executeForTrustStatementReceivedArguments?.credential, credential)
    XCTAssertEqual(getCredentialIssuerDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, trustStatement)
  }

  func testInitValuesWithoutTrustStatement() async {
    viewModel = CredentialOfferViewModel(credential: credential, trustStatement: nil, router: router)

    XCTAssertEqual(viewModel.credential, credential)
    XCTAssertEqual(viewModel.credentialBody, CredentialDetailBody(from: credential))
    XCTAssertEqual(viewModel.state, .result)
    XCTAssertEqual(viewModel.issuerTrustStatus, .unverified)
    XCTAssertFalse(getCredentialIssuerDisplayUseCase.executeForTrustStatementCalled)
    XCTAssertEqual(getCredentialIssuerDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, nil)
  }

  func testAccept() async {
    await viewModel.send(event: .accept)
    XCTAssertEqual(viewModel.state, .loading)

    try? await Task.sleep(nanoseconds: delayAfterAcceptingCredential + 100_000_000)

    XCTAssertTrue(router.closeCalled)
  }

  func testDecline() async {
    await viewModel.send(event: .decline)
    XCTAssertEqual(viewModel.state, .decline)
  }

  func testDeclineConfirmation() async {
    await viewModel.send(event: .confirmDecline)
    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
    XCTAssertTrue(router.closeCalled)
  }

  func testDeclineConfirmation_onError() async {
    deleteCredentialUseCase.executeThrowableError = TestingError.error

    await viewModel.send(event: .confirmDecline)
    XCTAssertTrue(deleteCredentialUseCase.executeCalled)
    XCTAssertEqual(deleteCredentialUseCase.executeCallsCount, 1)
    XCTAssertFalse(router.closeCalled)
    XCTAssertEqual(viewModel.state, .error)
    XCTAssertNotNil(viewModel.stateError)
  }

  func testDeclineCancellation() async {
    await viewModel.send(event: .cancelDecline)
    XCTAssertEqual(viewModel.state, .result)
  }

  func testOpenWrongData() async {
    await viewModel.send(event: .openWrongData)
    XCTAssertTrue(router.wrongDataCalled)
  }

}
