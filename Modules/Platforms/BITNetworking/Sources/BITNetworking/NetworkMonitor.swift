import Combine
import Factory
import Foundation
import Network

// MARK: - NetworkMonitorProtocol

public protocol NetworkMonitorProtocol: ObservableObject {
  var isActive: Bool { get }
  var connectionType: NWInterface.InterfaceType { get }
}

// MARK: - NetworkMonitor

public class NetworkMonitor: NetworkMonitorProtocol {

  // MARK: Lifecycle

  public init(connectionTypes: [NWInterface.InterfaceType] = NetworkContainer.shared.connectionTypes()) {
    monitor.pathUpdateHandler = { path in
      self.isActive = path.status == .satisfied

      let connectionTypes: [NWInterface.InterfaceType] = connectionTypes
      self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other

      DispatchQueue.main.async {
        self.objectWillChange.send()
      }
    }

    monitor.start(queue: queue)
  }

  // MARK: Public

  @Published public var isActive = false
  @Published public var connectionType: NWInterface.InterfaceType = .other

  // MARK: Private

  private let monitor: NWPathMonitor = .init()
  private let queue: DispatchQueue = .init(label: "Monitor")

}
