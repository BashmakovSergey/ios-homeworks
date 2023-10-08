import Foundation

class FeedViewModel {
    
    private var secretWord = "Dune"
    let notificationCenter = NotificationCenter.default
    
    var onShowNextView: (() -> Void)?
    
    lazy var onTapShowNextView: () -> Void = { [weak self] in
        self?.onShowNextView?()
    }
    
    func check(inputSecretWord word: String) {
        
        var notification = Notification(name: NSNotification.Name(rawValue: "Clear notification"), object: nil, userInfo: nil)
        
        if word == secretWord {
            notification.name = NSNotification.Name(rawValue: "Word is correct")
        } else {
            notification.name = NSNotification.Name(rawValue: "Word is not correct")
        }
        
        notificationCenter.post(notification)
    }
    
    func returnCorrectSecretWord() -> String{
        return secretWord
    }
}
