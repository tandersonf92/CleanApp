import Domain

func makeAccountModel() -> AccountModel {
    AccountModel(id: "any_id",
                 name: "any_name",
                 email: "any_email@email.com",
                 password: "any_password")
}

func makeAddAccountModel() -> AddAccountModel {
    AddAccountModel(name: "any_name",
                    email: "any_email@email.com",
                    password: "any_password",
                    passwordConfirmation: "any_password")
}
