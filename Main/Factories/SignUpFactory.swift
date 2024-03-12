import Data
import Infra
import Foundation
import Presentation
import UI
import Validation

enum SignUpFactory {
    static func build() -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamoFireAdapter()
        let removeAddAccount = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let presenter = SignUpPresenter(alertView: controller, loadingView: controller, emailValidator: emailValidatorAdapter, addAccount: removeAddAccount)
        controller.signUp = presenter.signUp

        return controller
    }
}
