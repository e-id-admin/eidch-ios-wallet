import BITCore
import XCTest

@testable import BITCredentialShared
@testable import BITOpenID

final class CredentialDisplayTests: XCTestCase {

  // MARK: Internal

  func testCredentialDisplayInitWithDataLogo_success() throws {
    guard let logoJsonData = dataLogoJson.data(using: .utf8) else {
      fatalError("Incorrect data")
    }

    let mockLogo = try JSONDecoder().decode(CredentialMetadata.CredentialSupportedDisplayLogo.self, from: logoJsonData)
    let mockCredentialSupportedDisplay = CredentialMetadata.CredentialSupportedDisplay(name: "credential", logo: mockLogo)
    let credentialDisplay = CredentialDisplay(mockCredentialSupportedDisplay)

    XCTAssertNotNil(credentialDisplay.logoBase64)
    XCTAssertNil(credentialDisplay.logoUrl)
  }

  func testCredentialDisplayInitWithUrlLogo_success() throws {
    guard let logoJsonData = urlLogoJson.data(using: .utf8) else {
      fatalError("Incorrect data")
    }

    let mockLogo = try JSONDecoder().decode(CredentialMetadata.CredentialSupportedDisplayLogo.self, from: logoJsonData)
    let mockCredentialSupportedDisplay = CredentialMetadata.CredentialSupportedDisplay(name: "credential", logo: mockLogo)
    let credentialDisplay = CredentialDisplay(mockCredentialSupportedDisplay)

    XCTAssertNil(credentialDisplay.logoBase64)
    XCTAssertNotNil(credentialDisplay.logoUrl)
  }

  // MARK: Private

  private let dataLogoJson =
    """
    {
      "uri":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAACPSURBVHgB7ZbbCYAwDEVvxEHcREdzlI7gCHUDN9AtfEJM0S9BUWwrSA5cWujHgdA2oWFcWhAyxKGjYVpYNpaZawSEiHJZCjhhP84lAuMczpUgMir8Tii32PBGiRdoSVWoQhX+UJjiOfnJf9pIV68QQFjsOWIkXoVGYi/OO9zgtlDKZeEBfRbeiT4IU+xRfwVePD+H6WV/zQAAAABJRU5ErkJggg=="
    }
    """

  private let urlLogoJson =
    """
    {
      "uri":"https://image.noelshack.com/fichiers/2024/07/1/1707731598-flag.png"
    }
    """

}
