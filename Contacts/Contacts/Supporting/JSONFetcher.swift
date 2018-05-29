import Foundation

enum JSONFetcher {
    static func fetchInitialContactsJSON()->[Any] {
        guard let path = Bundle.main.path(forResource: "contacts", ofType: "json") else { fatalError("couldn't load json file") }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONSerialization.jsonObject(with: data)
                guard let jsonCollection = jsonResult as? [Any] else { fatalError("Couldn't load contacts json")}
                return jsonCollection
            } catch {
                fatalError(error.localizedDescription)
            }
    }
}
