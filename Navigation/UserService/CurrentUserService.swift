import Foundation

final class CurrentUserService: UserService {

    let currentUser = User(userFullName: "Piggy Pig", userAvatar: "avatar", userStatus: "I am gonna to Magadan")
    
    func authorization() -> User? {
            return currentUser
        }
    
}
