import Foundation

public protocol AuthenticationUseCase {
    typealias Result = Swift.Result<AuthenticationModel, DomainError>
    func add(authenticationModel: AuthenticationModel, completion: @escaping(Result) -> Void)
}

public struct AuthenticationModel: Model {
    public var email: String
    public var password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
