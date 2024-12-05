import BITCredential
import BITInvitation
import BITNavigation
import BITSettings
import Foundation
import UIKit

// MARK: - HomeRouterRoutes

public protocol HomeRouterRoutes: InvitationRoutes, ExternalRoutes, CredentialDetailRoutes {}

// MARK: - HomeRouter

final public class HomeRouter: Router<UIViewController>, HomeRouterRoutes {}
