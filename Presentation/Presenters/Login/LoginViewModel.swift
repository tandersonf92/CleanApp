import Domain

public struct LoginViewModel: Model {
    public var email: String
    public var password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    public func toAuthenticationModel() -> AuthenticationModel {
        AuthenticationModel(email: email,
                            password: password)
    }
}
