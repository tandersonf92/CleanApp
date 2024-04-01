import Presentation
import UIKit

public final class LoginViewController: UIViewController, StoryBoarded {


    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        title = "4Devs"
        loginButton.layer.cornerRadius = 5
    }
}

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
