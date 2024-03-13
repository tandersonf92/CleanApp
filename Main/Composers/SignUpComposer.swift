import Domain
import Presentation
import Validation
import UI

enum SignUpComposer {
    static func composeControllerWith(addAccount: AddAccountUseCase) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), emailValidator: emailValidatorAdapter, addAccount: addAccount)
        controller.signUp = presenter.signUp
        return controller
    }
}
