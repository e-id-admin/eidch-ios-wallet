import Lottie
import SwiftUI

public struct LottieView: UIViewRepresentable {

  // MARK: Lifecycle

  public init(animationFile: String, contentMode: UIView.ContentMode = .scaleAspectFit, loopMode: LottieLoopMode = .loop) {
    self.animationFile = animationFile
    self.contentMode = contentMode
    self.loopMode = loopMode
  }

  // MARK: Public

  public func makeUIView(context: Context) -> UIView {
    let view = UIView()

    let animationView = LottieAnimationView()
    animationView.contentMode = contentMode
    animationView.loopMode = loopMode

    if let path = Bundle.module.path(forResource: animationFile, ofType: "json") {
      animationView.animation = LottieAnimation.filepath(path)
      animationView.play()
    }

    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)

    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
    ])

    return view
  }

  public func updateUIView(_ uiView: UIView, context: Context) { }

  // MARK: Private

  private let animationFile: String
  private let contentMode: UIView.ContentMode
  private let loopMode: LottieLoopMode

}
