import BITNavigation
import UIKit


public protocol EIDRequestRouterRoutes: ClosableRoutes {}


final public class EIDRequestRouter: Router<UIViewController>, EIDRequestRouterRoutes, EIDRequestInternalRoutes {}
