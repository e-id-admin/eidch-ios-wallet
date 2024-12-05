import Combine
import Foundation

extension AnyPublisher where Output == AnyObject, Failure == Never {

  public static func run<Event, Element: Collection>(
    _ task: @escaping () async throws -> Element,
    onSuccess: @escaping (Element) -> Event,
    onError: @escaping (Error) -> Event,
    onEmpty: @escaping () -> Event)
    -> AnyPublisher<Event, Never>
  {
    SendablePublisher {
      try await task()
    }
    .map { $0.isEmpty ? onEmpty() : onSuccess($0) }
    .catch({ error -> Just<Event> in
      Just(onError(error))
    })
    .eraseToAnyPublisher()
  }

  public static func run<Event, Element>(
    _ task: @escaping () async throws -> Element,
    onSuccess: @escaping (Element) -> Event,
    onError: @escaping (Error) -> Event)
    -> AnyPublisher<Event, Never>
  {
    SendablePublisher {
      try await task()
    }
    .map { onSuccess($0) }
    .catch({ error -> Just<Event> in
      Just(onError(error))
    })
    .eraseToAnyPublisher()
  }

  public static func run<Event, Element>(
    withDelay seconds: TimeInterval,
    _ task: @escaping () async throws -> Element,
    onSuccess: @escaping (Element) -> Event,
    onError: @escaping (Error) -> Event)
    -> AnyPublisher<Event, Never>
  {
    SendablePublisher(timeInterval: seconds) {
      try await task()
    }
    .map { onSuccess($0) }
    .catch({ error -> Just<Event> in
      Just(onError(error))
    })
    .eraseToAnyPublisher()
  }

}
