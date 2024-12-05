import Foundation

extension MainActor {
  @MainActor
  public static func run<T>(withDelay seconds: TimeInterval, resultType: T.Type = T.self, body: @MainActor @Sendable () throws -> T) async throws -> T where T: Sendable {
    let delay = UInt64(seconds * 1_000_000_000)
    try await Task<Never, Never>.sleep(nanoseconds: delay)
    return try body()
  }
}
