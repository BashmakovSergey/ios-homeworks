import Foundation

class LoginInspector: LoginViewControllerDelegate {
    
    func check(inputLogin: String, inputPassword: String) -> Bool {
        return Checker.shared.check(inputLogin: inputLogin, inputPassword: inputPassword)
    }
    
}

struct MyLogInFactory: LoginFactory {
    
    private let inspector =  LoginInspector()
    
    func makeLoginInspector() -> LoginInspector {
        return inspector
    }
    
}

protocol LoginViewControllerDelegate: AnyObject {
    func check(inputLogin: String, inputPassword: String) -> Bool
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}
