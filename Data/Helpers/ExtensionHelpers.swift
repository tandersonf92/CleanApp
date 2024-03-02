import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }

    func toJson() -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed) as? [String: Any]
    }
}
