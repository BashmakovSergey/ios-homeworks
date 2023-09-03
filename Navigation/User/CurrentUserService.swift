import UIKit

class CurrentUserService: UserService {

    let currentUser = User(userLogin: "IamNotaPig", userFullName: "Piggy Pig", userAvatar: UIImage(named: "avatar") ?? UIImage(), userStatus: "I am gonna to Magadan")

    func authorization(userLogin: String) -> User? {
        
        if userLogin == currentUser.userLogin {
            return currentUser
        } else {
            return nil
        }
    }
}
