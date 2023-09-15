import Foundation

final class Checker {
    
    static let shared = Checker()
    
    //пока correctLogin совпадает с CurrentUserService userLogin
    private let correctLogin: String = "IamNotaPig"
    private let correctPassword: String = "RoboCop"
    
    private init() {}
    
    func check(inputLogin: String, inputPassword: String) -> Bool {
        let isCorrectLoginAndPassword = correctLogin == inputLogin && correctPassword == inputPassword
        return isCorrectLoginAndPassword
    }
}
