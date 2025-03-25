import BITNavigation
import Foundation
import UIKit

// MARK: - NoDevicePinCodeRouterRoutes

public protocol NoDevicePinCodeRouterRoutes: ClosableRoutes, ExternalRoutes {}

// MARK: - NoDevicePinCodeRouter

final public class NoDevicePinCodeRouter: Router<UIViewController>, NoDevicePinCodeRouterRoutes {}
