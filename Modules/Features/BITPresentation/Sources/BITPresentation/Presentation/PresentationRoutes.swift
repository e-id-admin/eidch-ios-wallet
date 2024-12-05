import BITCredentialShared
import BITNavigation
import BITOpenID
import Factory
import Foundation
import UIKit

// MARK: - PresentationRoutes

public protocol PresentationRoutes {
  func compatibleCredentials(for inputDescriptorId: InputDescriptorID, and context: PresentationRequestContext) throws
  func presentationReview(with context: PresentationRequestContext)
}

// MARK: - InvitationInternalRoutes

extension PresentationRoutes where Self: RouterProtocol {

  public func compatibleCredentials(for inputDescriptorId: InputDescriptorID, and context: PresentationRequestContext) throws {
    let module = try CompatibleCredentialsModule(context: context, inputDescriptorId: inputDescriptorId)
    let viewController = module.viewController

    let style = NavigationPushOpeningStyle()
    module.router.current = style
    open(viewController, on: self.viewController, as: style)
  }

  public func presentationReview(with context: PresentationRequestContext) {
    let module = PresentationRequestReviewModule(context: context)
    let viewController = module.viewController

    let style = NavigationPushOpeningStyle()
    module.router.current = style
    open(viewController, on: self.viewController, as: style)
  }

}
