import Data
import Domain
import Infra

import Foundation

enum UseCaseFactory {
    private static let httpClient = AlamoFireAdapter()

    private static let apiBaseUrl = Environment.variable(.apiBaseURL)

    private static func makeUrl(path: String) -> URL {
        URL(string: "\(apiBaseUrl)/\(path)")!
    }

    static func makeRemoteAddAccount() -> AddAccountUseCase {
        let remoteAddAccount = RemoteAddAccount(url: makeUrl(path: "signup"), httpClient: httpClient)
        return MainQueueDispatchDecorator(remoteAddAccount)
    }
}
