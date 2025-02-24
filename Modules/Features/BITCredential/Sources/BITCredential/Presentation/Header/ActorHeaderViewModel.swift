import BITCredentialShared
import BITTheming
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ActorHeaderViewModel

@MainActor
class ActorHeaderViewModel: ObservableObject {

  // MARK: Lifecycle

  init(name: String, trustStatus: TrustStatus) {
    self.name = name
    self.trustStatus = trustStatus
  }

  convenience init(name: String, trustStatus: TrustStatus, image: Image) {
    self.init(name: name, trustStatus: trustStatus)
    self.image = image
  }

  convenience init(name: String, trustStatus: TrustStatus, imageData: Data) {
    self.init(name: name, trustStatus: trustStatus)
    image = Image(data: imageData)
  }

  convenience init(name: String, trustStatus: TrustStatus, imageUrl: URL) {
    self.init(name: name, trustStatus: trustStatus)
    SDWebImageDownloader().downloadImage(with: imageUrl) { [weak self] _, data, error, _ in
      guard let self, let data, error == nil else { return }
      image = Image(data: data)
    }
  }

  // MARK: Internal

  @Published var image: Image?
  @Published var name: String
  @Published var trustStatus: TrustStatus

}
