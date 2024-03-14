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

public final class MainQueueDispatchDecorator<T> {

    private let instance: T

    public init(_ instance: T) {
        self.instance = instance
    }

    func dispatch(completion: @escaping() -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { completion() }
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccountUseCase where T: AddAccountUseCase {
    public func add(addAccountModel: Domain.AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        instance.add(addAccountModel: addAccountModel) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
