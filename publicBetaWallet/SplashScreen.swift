import SwiftUI

// MARK: - AnimatedSplashScreen

@available(iOS 17.0, *)
struct AnimatedSplashScreen: View {
  struct AnimationProperties {
    var logoExtendedOpacity = 0.0
    var maskWidth = Defaults.logoWidth
    var translation = 0.0
  }

  enum Defaults {
    static let duration = 2.0

    static let firstStepDuration = 0.25 * duration
    static let secondStepDuration = 0.25 * duration
    static let thirdStepDuration = 0.5 * duration

    static let logoExtendedWidth = 265.0
    static let logoWidth = 28.0

    static let computedLogoPosition = -logoExtendedWidth / 2 + logoWidth / 2
  }

  @State var isAnimationTriggered = false

  var properties = AnimationProperties()
  var completed: (() -> Void)?

  var body: some View {
    ZStack(alignment: .center) {
      Asset.logoExtended.swiftUIImage
        .mask {
          Rectangle()
            .keyframeAnimator(initialValue: properties, trigger: isAnimationTriggered) { content, value in
              content
                .offset(x: value.translation)
                .frame(width: value.maskWidth)
            } keyframes: { _ in
              KeyframeTrack(\.translation) {
                SpringKeyframe(0, duration: Defaults.firstStepDuration)
                SpringKeyframe(Defaults.computedLogoPosition, duration: Defaults.secondStepDuration)
                SpringKeyframe(Defaults.computedLogoPosition, duration: Defaults.thirdStepDuration)
              }
              KeyframeTrack(\.maskWidth) {
                LinearKeyframe(0, duration: Defaults.firstStepDuration)
                LinearKeyframe(0, duration: Defaults.secondStepDuration)
                SpringKeyframe(Defaults.logoExtendedWidth * 2, duration: Defaults.thirdStepDuration)
              }
            }
        }
        .frame(width: Defaults.logoExtendedWidth)
        .keyframeAnimator(initialValue: properties, trigger: isAnimationTriggered) { content, value in
          content
            .opacity(value.logoExtendedOpacity)
        } keyframes: { _ in
          KeyframeTrack(\.logoExtendedOpacity) {
            LinearKeyframe(0, duration: Defaults.firstStepDuration)
            LinearKeyframe(0, duration: Defaults.secondStepDuration)
            SpringKeyframe(1.0, duration: Defaults.thirdStepDuration)
          }
        }

      Asset.logo.swiftUIImage
        .keyframeAnimator(initialValue: properties, trigger: isAnimationTriggered) { content, value in
          content
            .offset(x: value.translation)
        } keyframes: { _ in
          KeyframeTrack(\.translation) {
            SpringKeyframe(0, duration: Defaults.firstStepDuration)
            SpringKeyframe(Defaults.computedLogoPosition, duration: Defaults.secondStepDuration)
            SpringKeyframe(Defaults.computedLogoPosition, duration: Defaults.thirdStepDuration)
          }
        }
    }
    .onAppear {
      isAnimationTriggered = true
      DispatchQueue.main.asyncAfter(deadline: .now() + Defaults.duration) {
        completed?()
      }
    }
  }
}

// MARK: - SplashScreen

struct SplashScreen: View {
  enum Defaults {
    static let duration = 1.0
  }

  var body: some View {
    Asset.logoExtended.swiftUIImage
      .onFirstAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + Defaults.duration) {
          completed?()
        }
      }
  }

  var completed: (() -> Void)?
}
