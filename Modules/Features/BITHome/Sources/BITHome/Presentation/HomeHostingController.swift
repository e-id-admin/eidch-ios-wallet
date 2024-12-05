import SwiftUI
import UIKit

// MARK: - HomeHostingController

public class HomeHostingController<Content>: UIHostingController<Content> where Content: View {

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

}
