import Foundation

class LoginInspector: LoginViewControllerDelegate {
    
    func checkLoginOnly(inputLogin: String) -> Bool {
        return Checker.shared.checkLoginOnly(inputLogin: inputLogin)
    }
    
    func checkPasswordOnly(inputPassword: String) -> Bool {
        return Checker.shared.checkPasswordOnly(inputPassword: inputPassword)
    }
    
    
    func check(inputLogin: String, inputPassword: String) -> Bool {
        return Checker.shared.check(inputLogin: inputLogin, inputPassword: inputPassword)
    }
    
}

struct MyLogInFactory: LoginFactory {
    
    private let inspector = LoginInspector()
    
    func makeLoginInspector() -> LoginInspector {
        return inspector
    }
    
}

protocol LoginViewControllerDelegate: AnyObject {
    func check(inputLogin: String, inputPassword: String) -> Bool
    
    func checkLoginOnly(inputLogin: String) -> Bool
    
    func checkPasswordOnly(inputPassword: String) -> Bool
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}
