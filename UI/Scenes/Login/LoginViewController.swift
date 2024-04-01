import Presentation
import UIKit

public final class LoginViewController: UIViewController, StoryBoarded {

    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    public var login: ((LoginViewModel) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        title = "4Devs"
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        hideKeyboardOnTap()
    }

    @objc private func loginButtonTapped() {
        if let emailText = emailTextField.text,
           let passwordText = passwordTextField.text {
               login?(LoginViewModel(email: emailText, password: passwordText))
           }
    }
}

// MARK: LoadingView
extension LoginViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            view.isUserInteractionEnabled = false
            loadingIndicator.startAnimating()
        } else {
            view.isUserInteractionEnabled = true
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: AlertView
extension LoginViewController: AlertView {
    public func showMessage(viewModel: Presentation.AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title,
                                      message: viewModel.message,
                                      preferredStyle: .alert)

        alert.addAction(.init(title: "Ok",
                              style: .default))

        present(alert, animated: true)
    }
}
