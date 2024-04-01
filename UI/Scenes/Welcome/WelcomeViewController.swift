import UIKit

public final class WelcomeViewController: UIViewController, StoryBoarded {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    public var login: (() -> Void)?

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
               login?()
    }
}
