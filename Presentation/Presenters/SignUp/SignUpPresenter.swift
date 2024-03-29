import Foundation
import Domain

public final class SignUpPresenter {

    private let alertView: AlertView
    private let addAccount: AddAccountUseCase
    private let loadingView: LoadingView
    private let validation: Validation

    public init(alertView: AlertView, loadingView: LoadingView, addAccount: AddAccountUseCase, validation: Validation) {
        self.alertView = alertView
        self.loadingView = loadingView
        self.addAccount = addAccount
        self.validation = validation
    }

    public func signUp(viewModel: SignUpViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: viewModel.toAddAccountModel()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure:
                    alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
                case .success:
                    alertView.showMessage(viewModel: AlertViewModel(title: "Sucesso", message: "Conta criada com sucesso."))
                }
                loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
}
