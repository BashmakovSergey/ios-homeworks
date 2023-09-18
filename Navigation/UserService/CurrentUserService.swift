import UIKit

final class CurrentUserService: UserService {

    let currentUser = User(userFullName: "Piggy Pig", userAvatar: UIImage(named: "avatar") ?? UIImage(), userStatus: "I am gonna to Magadan")
    
    func authorization() -> User? {
            return currentUser
        }
    
}
