import XCTest
@testable import BITInvitation

@MainActor
final class CredentialOfferWrongDataViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    router = MockCredentialOfferRouter()

    viewModel = CredentialOfferWrongDataViewModel(router: router)
  }

  func testClose() {
    viewModel.close()
    XCTAssertTrue(router.closeCalled)
  }

  // MARK: Private

  // swiftlint:disable all
  private var router: MockCredentialOfferRouter!
  private var viewModel: CredentialOfferWrongDataViewModel!
  // swiftlint:enable all

}
