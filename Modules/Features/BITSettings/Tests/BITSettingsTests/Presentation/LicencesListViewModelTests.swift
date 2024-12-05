import XCTest
@testable import BITSettings

final class LicencesListViewModelTests: XCTestCase {

  // MARK: Internal

  @MainActor
  override func setUp() {
    super.setUp()
    fetchPackagesUseCase = FetchPackagesUseCaseProtocolSpy()
    viewModel = LicencesListViewModel(fetchPackagesUseCase: fetchPackagesUseCase)
  }

  @MainActor
  func testInitialState() {
    XCTAssertEqual(viewModel.state, .loading)
    XCTAssertNotNil(viewModel.packages)
  }

  @MainActor
  func testFetchPackages_withResults() async {
    fetchPackagesUseCase.executeReturnValue = [PackageDependency.Mock.sample]
    await viewModel.send(event: .fetch)

    XCTAssertEqual(viewModel.state, .results)
    XCTAssertEqual(viewModel.packages.count, 1)
    XCTAssertTrue(fetchPackagesUseCase.executeCalled)
    XCTAssertEqual(fetchPackagesUseCase.executeCallsCount, 1)
  }

  @MainActor
  func testFetchPackages_withoutResults() async {
    fetchPackagesUseCase.executeReturnValue = []
    await viewModel.send(event: .fetch)

    XCTAssertEqual(viewModel.state, .empty)
    XCTAssertEqual(viewModel.packages.count, 0)
    XCTAssertTrue(fetchPackagesUseCase.executeCalled)
    XCTAssertEqual(fetchPackagesUseCase.executeCallsCount, 1)
  }

  @MainActor
  func testFetchPackages_failure() async {
    fetchPackagesUseCase.executeThrowableError = FetchPackagesError.fileNotExisting
    await viewModel.send(event: .fetch)

    XCTAssertEqual(viewModel.state, .error)
    XCTAssertEqual(viewModel.stateError as? FetchPackagesError, FetchPackagesError.fileNotExisting)
    XCTAssertTrue(fetchPackagesUseCase.executeCalled)
    XCTAssertEqual(fetchPackagesUseCase.executeCallsCount, 1)
  }

  @MainActor
  func test_selectDefaultElement() async {
    await testFetchPackages_withResults()

    XCTAssertEqual(viewModel.packages.first, PackageDependency.Mock.sample)
    XCTAssertFalse(viewModel.isPackageDetailPresented)
  }

  @MainActor
  func test_selectElement() async {
    await test_selectDefaultElement()

    guard let package = viewModel.packages.first else { return XCTFail("No package available...") }

    await viewModel.send(event: .selectPackage(package))
    XCTAssertEqual(package, PackageDependency.Mock.sample)
    XCTAssertTrue(viewModel.isPackageDetailPresented)
  }

  // MARK: Private

  // swiftlint:disable all
  private var viewModel: LicencesListViewModel!
  private var fetchPackagesUseCase: FetchPackagesUseCaseProtocolSpy!
  // swiftlint:enable all
}
