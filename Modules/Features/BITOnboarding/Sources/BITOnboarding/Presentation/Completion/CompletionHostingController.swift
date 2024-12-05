import Foundation
import SwiftUI
import UIKit

class CompletionHostingController<Content>: UIHostingController<Content> where Content: View {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.setHidesBackButton(true, animated: false)
  }

}
