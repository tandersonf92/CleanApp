public protocol AddAccountUseCase {
    func add(addAccountModel: AddAccountModel, completion: @escaping( Result<AccountModel, Error>) -> Void)
}

public struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}
