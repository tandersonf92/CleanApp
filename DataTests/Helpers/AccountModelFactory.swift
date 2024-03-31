import Domain

func makeAccountModel() -> AccountModel {
    AccountModel(accessToken: "any_token")
}

func makeAddAccountModel() -> AddAccountModel {
    AddAccountModel(name: "any_name",
                    email: "any_email@email.com",
                    password: "any_password",
                    passwordConfirmation: "any_password")
}

func makeAuthenticationModel() -> AuthenticationModel {
    AuthenticationModel(
        email: "any_email@email.com",
        password: "any_password")
}
