import Foundation

func makeApiUrl(path: String) -> URL {
    URL(string: "\(Environment.variable(.apiBaseURL))/\(path)")!
}
