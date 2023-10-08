import UIKit

protocol MainCoordinatorProtocol {
    func startApplication() -> UIViewController
}

protocol FlowCoordinatorProtocol {
    func createViewController() -> UINavigationController
}

