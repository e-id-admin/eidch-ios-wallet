import SwiftUI
import UIKit

// MARK: - HomeHostingController

class HomeHostingController<Content>: UIHostingController<Content> where Content: View {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

}
