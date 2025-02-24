import Spyable
import XCTest
@testable import BITAnyCredentialFormat
@testable import BITOpenID

final class FetchAnyCredentialUseCaseFactoryTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    mockVcSdJwtCredential = AnyCredentialSpy()
    mockVcSdJwtCredential.raw = UUID().uuidString
    spyFetchCredentialVcSdJwtUseCase = FetchAnyCredentialUseCaseProtocolSpy()
    mockDispatcher = [.vcSdJwt: spyFetchCredentialVcSdJwtUseCase]

    useCase = FetchAnyCredentialUseCase(anyFetchCredentialDispatcher: mockDispatcher)
  }

  func testExecuteVcSdJwtUseCase() async throws {
    spyFetchCredentialVcSdJwtUseCase.executeForReturnValue = mockVcSdJwtCredential

    let anyCredential = try await useCase.execute(for: .Mock.sampleVcSdJwt)
    XCTAssertEqual(mockVcSdJwtCredential.raw, anyCredential.raw)
    XCTAssertTrue(spyFetchCredentialVcSdJwtUseCase.executeForCalled)
  }

  func testExecuteUnsupportedFormat() async throws {
    do {
      _ = try await useCase.execute(for: .Mock.sample)
      XCTFail("An error was expected")
    } catch CredentialFormatError.formatNotSupported {
      /* expected error ✅ */
      XCTAssertFalse(spyFetchCredentialVcSdJwtUseCase.executeForCalled)
    } catch {
      XCTFail("Another error was expected")
    }
  }

  // MARK: Private

  // swiftlint:disable all
  private var useCase: FetchAnyCredentialUseCase!
  private var spyFetchCredentialVcSdJwtUseCase: FetchAnyCredentialUseCaseProtocolSpy!
  private var mockDispatcher: [CredentialFormat: FetchAnyCredentialUseCaseProtocol]!
  private var mockVcSdJwtCredential: AnyCredentialSpy!
  // swiftlint:enable all

}
