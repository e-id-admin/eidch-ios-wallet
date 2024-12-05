import XCTest
@testable import BITSettings

final class FetchPackagesUseCaseTests: XCTestCase {

  func testExecute_withNotExistingFile() {
    let fetchPackagesUseCase = FetchPackagesUseCase(filePath: "fake_file")

    XCTAssertThrowsError(try fetchPackagesUseCase.execute()) { error in
      XCTAssertEqual(error as? FetchPackagesError, .fileNotExisting)
    }
  }
}
