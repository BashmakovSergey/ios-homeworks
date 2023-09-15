import Foundation

final class Checker {
    
    static let shared = Checker()
    
    private let correctLogin: String = "IamNotaPig"
    private let correctPassword: String = "RoboCop"
    
    private init() {}
    
    func check(inputLogin: String, inputPassword: String) -> Bool {
        let isCorrectLoginAndPassword = correctLogin == inputLogin && correctPassword == inputPassword
        return isCorrectLoginAndPassword
    }
    
    func checkLoginOnly(inputLogin: String) -> Bool {
        let isCorrectLogin = correctLogin == inputLogin
        return isCorrectLogin
    }
    
    func checkPasswordOnly(inputPassword: String) -> Bool {
        let isCorrectPassword = correctPassword == inputPassword
        return isCorrectPassword
    }
    
    func returnCorrectLogin() -> String{
        return correctLogin
    }
    
    func returnCorrectPassword() -> String{
        return correctPassword
    }
    
}
