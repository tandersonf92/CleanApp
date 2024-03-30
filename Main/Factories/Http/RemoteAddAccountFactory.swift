import Data
import Domain
import Foundation

func makeRemoteAddAccount(httpClient: HttpPostClient) -> AddAccountUseCase {
    let remoteAddAccount = RemoteAddAccount(url: makeApiUrl(path: "signup"), httpClient: httpClient)
    return MainQueueDispatchDecorator(remoteAddAccount)
}
