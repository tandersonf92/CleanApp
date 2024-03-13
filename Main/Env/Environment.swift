import Foundation

final class Environment {
    enum EnvironmentVariables: String {
        case apiBaseURL = "API_BASE_URL"
    }

    static func variable(_ key: EnvironmentVariables) -> String {
        Bundle.main.infoDictionary?[key.rawValue] as? String ?? ""
    }
}
