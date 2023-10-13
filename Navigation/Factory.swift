import UIKit

protocol FactoryProtocol {
    func makeLoginInspector() -> LoginInspector
}

class MainFactory: FactoryProtocol {
    
    private let inspector = LoginInspector()
    
    func makeLoginInspector() -> LoginInspector {
        return inspector
    }
    
}
