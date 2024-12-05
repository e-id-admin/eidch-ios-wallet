import Factory
import XCTest

@testable import BITOpenID
@testable import BITPresentation

// MARK: - CompatibleCredentialViewModelTests

final class CompatibleCredentialViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()

    Container.shared.getVerifierDisplayUseCase.register { self.getVerifierDisplayUseCase }
  }

  @MainActor
  func testInitialState() {
    getVerifierDisplayUseCase.executeForTrustStatementReturnValue = .Mock.sample

    guard let inputDescriptor = context.requestObject.presentationDefinition.inputDescriptors.first else {
      fatalError("Cannot get input descriptor")
    }

    viewModel = CompatibleCredentialViewModel(context: context, inputDescriptorId: inputDescriptor.id, compatibleCredentials: mockCompatibleCredentials, router: router)

    XCTAssertEqual(viewModel.compatibleCredentials, mockCompatibleCredentials)
    XCTAssertNotNil(context.trustStatement)
    XCTAssertNotNil(viewModel.verifierDisplay)
    XCTAssertEqual(viewModel.verifierDisplay?.trustStatus, .verified)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.trustStatement, context.trustStatement)
    XCTAssertEqual(getVerifierDisplayUseCase.executeForTrustStatementReceivedArguments?.verifier, context.requestObject.clientMetadata)
  }

  @MainActor
  func testCredentialSelection() async throws {
    let credential: CompatibleCredential = .Mock.BIT

    guard let inputDescriptor = context.requestObject.presentationDefinition.inputDescriptors.first else {
      fatalError("Cannot get input descriptor")
    }

    viewModel = CompatibleCredentialViewModel(context: context, inputDescriptorId: inputDescriptor.id, compatibleCredentials: mockCompatibleCredentials, router: router)

    viewModel.didSelect(credential: credential)
    XCTAssertTrue(router.didCallPresentationReview)
    XCTAssertEqual(context.selectedCredentials[inputDescriptor.id], credential)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: CompatibleCredentialViewModel!
  private var context: PresentationRequestContext = .Mock.vcSdJwtJwtSample
  private var getVerifierDisplayUseCase = GetVerifierDisplayUseCaseProtocolSpy()
  private let router = MockPresentationRouter()
  private let mockCompatibleCredentials = [CompatibleCredential(credential: .Mock.sample, requestedFields: [.string("firstName")])]
  // swiftlint:enable all
}
