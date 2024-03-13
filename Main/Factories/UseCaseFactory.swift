import Data
import Domain
import Infra

import Foundation

enum UseCaseFactory {
    static func makeRemoteAddAccount() -> AddAccountUseCase {
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamoFireAdapter()
        return RemoteAddAccount(url: url, httpClient: alamofireAdapter)
    }
}
