import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
     
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let mainCoordinator = MainCoordinator()
        
        let url = AppConfiguration.allCases.randomElement()?.url
        NetworkService.request(url: url)
        
        window.rootViewController = mainCoordinator.start()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        do {
            try Auth.auth().signOut()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
}
