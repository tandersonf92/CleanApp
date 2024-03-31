import Domain

class AuthenticationSpy: AuthenticationUseCase {

    var authenticationModel: AuthenticationModel?

    func auth(authenticationModel: AuthenticationModel, completion: @escaping (AuthenticationUseCase.Result) -> Void) {
        self.authenticationModel = authenticationModel
    }
}
