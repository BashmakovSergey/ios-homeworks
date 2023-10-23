import Foundation

final class BruteForce {
    
    func bruteForce(passwordToUnlock: String, completion: @escaping (Result<String, LoginError>) -> Void) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        if passwordToUnlock.count > 4 {
            return completion(.failure(LoginError.tooStrongPassword))
        } else {
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: allowedCharacters)
                
            }
            return completion(.success(password))
        }
    }
    
    
    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
    
}
