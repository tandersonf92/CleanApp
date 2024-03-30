import Domain

class AddAccountSpy: AddAccountUseCase {
    var addAccountModel: AddAccountModel?
    var completion: ((AddAccountUseCase.Result) -> Void)?

    func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccountUseCase.Result) -> Void) {
        self.addAccountModel = addAccountModel
        self.completion = completion
    }

    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }

    func completeWithAccount(_ account: AccountModel) {
        completion?(.success(account))
    }
}
