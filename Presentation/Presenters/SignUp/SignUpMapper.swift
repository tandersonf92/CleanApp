import Domain

public final class SignUpMapper {
    public static func toAddAccountModel(viewModel: SignUpViewModel) -> AddAccountModel{
        AddAccountModel(name: viewModel.name!,
                        email: viewModel.email!,
                        password: viewModel.password!,
                        passwordConfirmation: viewModel.passwordConfirmation!)
    }
}
