import UIKit

public final class WelcomeViewController: UIViewController, StoryBoarded {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    public var login: (() -> Void)?
    public var signUp: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        title = "4Devs"
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc private func loginButtonTapped() {
        login?()
    }

    @objc private func signUpButtonTapped() {
        signUp?()
    }
}
