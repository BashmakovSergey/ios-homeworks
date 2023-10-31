import Foundation

enum AppConfiguration: String, CaseIterable {
    case peopleURL = "https://swapi.dev/api/people/8"
    case starshipsURL = "https://swapi.dev/api/starships/3"
    case planetsURL = "https://swapi.dev/api/planets/5"
}

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
            let url = URL(string: configuration.rawValue)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) {data, response, error in

                if let error {
                    print("Ошибка: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Код ответа: \(httpResponse.statusCode)")
                    print("Заголовки: \(httpResponse.allHeaderFields)")
                }

                guard let data else {
                    print("Нет данных!")
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print("Данные получены: \(json)")
                } catch {
                    print("Ошибка обработки JSON: \(error.localizedDescription)")

                }
            }
            task.resume()
        }
}
