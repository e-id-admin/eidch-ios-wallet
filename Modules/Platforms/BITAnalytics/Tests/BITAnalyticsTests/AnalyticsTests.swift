import XCTest

@testable import BITAnalytics
@testable import BITAnalyticsMocks
@testable import BITTestingCore

class AnalyticsTests: XCTestCase {

  // MARK: Internal

  func testInit() {
    let analytics = Analytics()
    XCTAssertTrue(analytics.providers.isEmpty)
  }

  func testProviderRegistration() {
    let analytics = initAnalytics([mockProvider])
    XCTAssertEqual(analytics.providers.count, 1)
  }

  func testMultipleProviderRegistration() {
    let analytics = initAnalytics([dynatraceProvider, mockProvider])
    XCTAssertEqual(analytics.providers.count, 2)
  }

  func testPreventSameProviderRegistration() {
    let analytics = initAnalytics([mockProvider, mockProvider])
    XCTAssertEqual(analytics.providers.count, 1)
  }

  func testFireEvent() {
    let provider = MockProvider()

    let analytics = Analytics()
    analytics.register(provider)
    analytics.log(AnalyticsEvent.HelloWorld(parameter1: "Poke"))
    XCTAssertEqual(provider.logCounter, 1)

    analytics.log(AnalyticsEvent.HelloWorld(parameter1: "Poke"))
    XCTAssertEqual(provider.logCounter, 2)
  }

  func testFireEventOnMultipleProviders() {
    let analytics = initAnalytics([mockProvider, otherMockProvider])

    analytics.log(AnalyticsEvent.HelloWorld(parameter1: "Poke"))
    XCTAssertEqual(mockProvider.logCounter, 1)
    XCTAssertEqual(otherMockProvider.logCounter, 1)

    analytics.log(AnalyticsEvent.HelloWorld(parameter1: "Poke"))
    XCTAssertEqual(mockProvider.logCounter, 2)
    XCTAssertEqual(otherMockProvider.logCounter, 2)
  }

  func testLogError() {
    let provider = MockProvider()
    let analytics = Analytics()
    analytics.register(provider)

    analytics.log(TestingError.error)
    XCTAssertEqual(provider.logCounter, 1)
  }

  func testApplyUserPrivacyPolicy_enabled() async {
    let analytics = initAnalytics([mockProvider])

    await analytics.applyUserPrivacyPolicy(true)

    XCTAssertTrue(analytics.isAnalyticsEnabled)
  }

  func testApplyUserPrivacyPolicy_disabled() async {
    let analytics = initAnalytics([mockProvider])

    await analytics.applyUserPrivacyPolicy(false)

    XCTAssertFalse(analytics.isAnalyticsEnabled)
  }

  func testIsAnalyticsEnabled_multipleProvider() async {
    await mockProvider.applyUserPrivacyPolicy(true)
    await otherMockProvider.applyUserPrivacyPolicy(false)

    let analytics = initAnalytics([mockProvider, otherMockProvider])

    XCTAssertTrue(analytics.isAnalyticsEnabled)
  }

  // MARK: Private

  private let mockProvider = MockProvider()
  private let otherMockProvider = OtherMockProvider()
  private let dynatraceProvider = DynatraceProvider()

  private func initAnalytics(_ providers: [AnalyticsProviderProtocol]) -> Analytics {
    let analytics = Analytics()
    providers.forEach({ analytics.register($0) })

    return analytics
  }

}
