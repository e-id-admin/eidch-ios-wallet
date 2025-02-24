import SwiftUI

public class HideBackButtonHostingController<Content>: UIHostingController<Content> where Content: View {

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.setHidesBackButton(true, animated: false)
  }
}
