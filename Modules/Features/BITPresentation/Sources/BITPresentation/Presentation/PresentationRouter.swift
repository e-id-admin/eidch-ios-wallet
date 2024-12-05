import BITCredential
import BITNavigation
import UIKit

// MARK: - PresentationRouterRoutes

public protocol PresentationRouterRoutes: ClosableRoutes, PresentationRoutes {}

// MARK: - PresentationRouter

final public class PresentationRouter: Router<UIViewController>, PresentationRouterRoutes {}
