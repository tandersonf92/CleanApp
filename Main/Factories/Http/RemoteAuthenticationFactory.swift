import Data
import Domain
import Foundation

func makeRemoteAuthentication(httpClient: HttpPostClient) -> AuthenticationUseCase {
    let remoteAuthentication = RemoteAuthentication(url: makeApiUrl(path: "login"), httpClient: httpClient)
    return MainQueueDispatchDecorator(remoteAuthentication)
}
