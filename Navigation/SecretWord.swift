import Foundation

struct SecretWord {
    let secretWord: String
}

final class SecretWords {
    
    private let secretWords = [
        SecretWord(secretWord: "Dune"),
        SecretWord(secretWord: "Bad"),
        SecretWord(secretWord: "WarHammer")
        ]
    
    func todayIsSecretWord() -> String {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            print("done")
        })
        guard let randomElement = secretWords.randomElement() else {
            return "error"
        }
        return randomElement.secretWord
    }
    
}
