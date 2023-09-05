import UIKit

final class CurrentUserService: UserService {

    //пока userLogin совпадвет с Checker.correctLogin
    let currentUser = User(userLogin: "IamNotaPig", userFullName: "Piggy Pig", userAvatar: UIImage(named: "avatar") ?? UIImage(), userStatus: "I am gonna to Magadan")
    
    func authorization(userLogin: String) -> User? {
            return userLogin == currentUser.userLogin ? currentUser : nil
        }
    
}
