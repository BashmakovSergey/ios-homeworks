import Foundation

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
    
    var url: URL? {
            URL(string: self.rawValue)
        }
}

final class SomeTitleFromNetwork {
    private let json = "https://jsonplaceholder.typicode.com/todos/"
    private let randomIDforJson = String(Int.random(in: 1..<201))
    var url: URL?

    init() {
        self.url = URL(string: json + randomIDforJson)
    }
    
}

enum PlanetFromNetwork: String, CaseIterable {
    case planet = "https://swapi.dev/api/planets/1/"
    
    var url: URL? {
            URL(string: self.rawValue)
        }
}

struct Planets: Decodable {
    let name: String
    let rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents, films: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}

struct Resident: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear, gender: String
    let homeworld: String
    let films, species: [String]
    let vehicles, starships: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}
