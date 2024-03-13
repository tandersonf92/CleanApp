import Domain
import Foundation
import Presentation
import UI
import Validation

enum SignUpFactory {
    static func build(addAccount: AddAccountUseCase) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(alertView: controller, loadingView: controller, emailValidator: emailValidatorAdapter, addAccount: addAccount)
        controller.signUp = presenter.signUp

        return controller
    }
}
