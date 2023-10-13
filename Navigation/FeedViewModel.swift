import Foundation

protocol FeedViewModelProtocol {
    func check(inputSecretWord word: String)
    func returnCorrectSecretWord() -> String
}

class FeedViewModel: FeedViewModelProtocol {
    
    private let model = SecretWords()
    private var secretWord: String
    
    let notificationCenter = NotificationCenter.default
    
    var onShowNextView: (() -> Void)?
    
    lazy var onTapShowNextView: () -> Void = { [weak self] in
        self?.onShowNextView?()
    }
    
    init() {
        self.secretWord = model.todayIsSecretWord()
      }
    
    func check(inputSecretWord word: String) {
        
        var notification = Notification(name: NSNotification.Name(rawValue: "Clear notification"), object: nil, userInfo: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [self] in
            print("ожидание выполнено")
            if word == secretWord {
                notification.name = NSNotification.Name(rawValue: "Word is correct")
            } else {
                notification.name = NSNotification.Name(rawValue: "Word is not correct")
            }
            self.notificationCenter.post(notification)
        })
    }
    
    func returnCorrectSecretWord() -> String{
        return secretWord
    }
}
