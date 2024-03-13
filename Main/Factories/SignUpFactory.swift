import Domain
import Foundation
import Presentation
import UI
import Validation

enum SignUpFactory {
    static func build(addAccount: AddAccountUseCase) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), emailValidator: emailValidatorAdapter, addAccount: addAccount)
        controller.signUp = presenter.signUp

        return controller
    }
}

class WeakVarProxy<T:AnyObject> {
    private weak var instance: T?

    init(_ instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: AlertView where T: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}

extension WeakVarProxy: LoadingView where T: LoadingView {
    func display(viewModel: LoadingViewModel) {
        instance?.display(viewModel: viewModel)
    }
}
