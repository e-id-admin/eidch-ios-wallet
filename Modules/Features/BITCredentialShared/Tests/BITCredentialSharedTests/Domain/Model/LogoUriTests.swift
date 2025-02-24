import XCTest
@testable import BITCredentialShared

final class LogoUriTests: XCTestCase {

  func testURLInit_success() throws {
    let mockURI = "https://image.noelshack.com/fichiers/2024/07/1/1707731598-flag.png"

    let logoUri = CredentialDisplay.LogoUri(uri: mockURI)

    XCTAssertNotNil(logoUri.logoUrl)
    XCTAssertNotNil(logoUri.url)
    XCTAssertNil(logoUri.data)
  }

  func testDataInit_success() throws {
    let mockURI = "iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAACPSURBVHgB7ZbbCYAwDEVvxEHcREdzlI7gCHUDN9AtfEJM0S9BUWwrSA5cWujHgdA2oWFcWhAyxKGjYVpYNpaZawSEiHJZCjhhP84lAuMczpUgMir8Tii32PBGiRdoSVWoQhX+UJjiOfnJf9pIV68QQFjsOWIkXoVGYi/OO9zgtlDKZeEBfRbeiT4IU+xRfwVePD+H6WV/zQAAAABJRU5ErkJggg=="

    let logoUri = CredentialDisplay.LogoUri(uri: mockURI)

    XCTAssertNil(logoUri.logoUrl)
    XCTAssertNotNil(logoUri.url)
    XCTAssertNotNil(logoUri.data)
  }
}
