import Domain
import Foundation

public final class RemoteAuthentication {
    private let url: URL
    private let httpClient: HttpPostClient

    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (AuthenticationUseCase.Result) -> Void) {
        httpClient.post(to: url, with: authenticationModel.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success: break
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
