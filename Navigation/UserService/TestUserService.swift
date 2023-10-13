import Foundation

final class TestUserService: UserService {
    
    let testUser = User(userFullName: "test", userAvatar: "person.circle", userStatus: "test")
    
    func authorization() -> User? {
            return testUser
        }
    
}
