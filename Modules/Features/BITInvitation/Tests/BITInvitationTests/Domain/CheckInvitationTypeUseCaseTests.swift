import BITCore
import Spyable
import XCTest
@testable import BITInvitation

final class CheckInvitationTypeUseCaseTests: XCTestCase {

  // MARK: Internal

  func testCheckInvitationType_Presentation_Success() async throws {
    let strURL = "https://bit.com"
    guard let validPresentationInvitationURL = URL(string: strURL) else {
      fatalError("url generation")
    }

    let expectedInvitationType = InvitationType.presentation
    let invitationType = try await useCase.execute(url: validPresentationInvitationURL)

    XCTAssertEqual(expectedInvitationType, invitationType)
  }

  func testCheckInvitationType_Credential_Success() async throws {
    let strURL = "openid-credential-offer://bit.com"
    guard let validCredentialInvitationURL = URL(string: strURL) else {
      fatalError("url generation")
    }

    let expectedInvitationType = InvitationType.credentialOffer
    let invitationType = try await useCase.execute(url: validCredentialInvitationURL)

    XCTAssertEqual(expectedInvitationType, invitationType)
  }

  func testCheckInvitationType_Failure() async throws {
    let strURL = "test://bit.com"
    guard let invalidInvitationURL = URL(string: strURL) else {
      fatalError("url generation")
    }

    do {
      _ = try await useCase.execute(url: invalidInvitationURL)
      XCTFail("Should have thrown an exception")
    } catch is CheckCameraError {
      // Expected exception, nothing to check
    } catch {
      XCTFail("Not the expected exception")
    }
  }

  // MARK: Private

  private var useCase = CheckInvitationTypeUseCase()
}
