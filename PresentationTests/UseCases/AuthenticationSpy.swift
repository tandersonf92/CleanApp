import Domain

class AuthenticationSpy: AuthenticationUseCase {

    var authenticationModel: AuthenticationModel?
    var completion: ((AddAccountUseCase.Result) -> Void)?

    func auth(authenticationModel: AuthenticationModel, completion: @escaping (AuthenticationUseCase.Result) -> Void) {
        self.authenticationModel = authenticationModel
        self.completion = completion
    }

    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }

    func completeWithAccount(_ account: AccountModel) {
        completion?(.success(account))
    }
}
