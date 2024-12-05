import BITDeeplink
import BITNavigation
import BITPresentation
import UIKit

// MARK: - InvitationRouterRoutes

public protocol InvitationRouterRoutes: ClosableRoutes & CredentialOfferRoutes & ExternalRoutes & InvitationRoutes & PresentationRoutes {}

// MARK: - InvitationRouter

final public class InvitationRouter: Router<UIViewController>, InvitationRouterRoutes {}
