import Foundation
import Domain

public final class LoginPresenter {

    private let validation: Validation
    private let alertView: AlertView
    private let authentication: AuthenticationUseCase
    private let loadingView: LoadingView

    public init(validation: Validation, alertView: AlertView, authentication: AuthenticationUseCase, loadingView: LoadingView) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
        self.loadingView = loadingView
    }

    public func login(viewModel: LoginRequest) {
        if let message = validation.validate(data: viewModel.toJson()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel())  { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    let errorMessage: String = error == .expiredSession
                    ? "Email e/ou senha inválidos"
                    : "Algo inesperado aconteceu, tente novamente em alguns instantes."
                    alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: errorMessage))
                case .success:
                    alertView.showMessage(viewModel: AlertViewModel(title: "Sucesso", message: "Login feito com sucesso."))
                }
                loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
}
