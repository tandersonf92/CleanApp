import Presentation
import UIKit

final class SignUpViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!

    var signUp: ((SignUpViewModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel())
    }
}

extension SignUpViewController: LoadingView {
    func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

extension SignUpViewController: AlertView {
    func showMessage(viewModel: Presentation.AlertViewModel) {
        
    }
}
