import Foundation
import RealmSwift

final class AllJoke {
    static let shared = AllJoke()
    var realm: Realm
    
    private init() {
//        try! FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        func getKey() -> Data {
            let keychainIdentifier = "io.Realm.EncryptionExampleKey"
            let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            var query: [NSString: AnyObject] = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecReturnData: true as AnyObject
            ]
            var dataTypeRef: AnyObject?
            var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
            if status == errSecSuccess {
                return dataTypeRef as! Data
            }

            var key = Data(count: 64)
            key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
                let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
                assert(result == 0, "Failed to get random bytes")
            })
            query = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecValueData: key as AnyObject
            ]
            status = SecItemAdd(query as CFDictionary, nil)
            assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
            return key
        }

        let config = Realm.Configuration(encryptionKey: getKey(), schemaVersion: 1)

        do {
            realm = try Realm(configuration: config)


        } catch let error as NSError {
            fatalError("Error opening realm: \(error)")
        }

    }
    
    func addCategories(_ categoriesJokes: [CategoriesJokesRealm]) {
        write {
            realm.add(categoriesJokes)
        }
    }
    
    func addCategory(_ categoryJokes: CategoriesJokesRealm) {
        write {
            realm.add(categoryJokes)
        }
    }
    
    func save(_ joke: JokeRealm, to categoryJokes: CategoriesJokesRealm) {
        write {
            categoryJokes.jokes.append(joke)
        }
    }
    
    func deleteAll() {
        write {
            realm.deleteAll()
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
