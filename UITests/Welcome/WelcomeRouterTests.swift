import XCTest

@testable import UI

class WelcomeRouter {
    private let nav: NavigationController
    private let loginFactory: () -> LoginViewController
    private let signUpFactory: () -> SignUpViewController

    init(nav: NavigationController, loginFactory: @escaping () -> LoginViewController, signUpFactory: @escaping () -> SignUpViewController) {
        self.nav = nav
        self.loginFactory = loginFactory
        self.signUpFactory = signUpFactory
    }

    func goToLogin() {
        nav.pushViewController(loginFactory())
    }

    func goToSignUp() {
        nav.pushViewController(signUpFactory())
    }
}

final class WelcomeRouterTests: XCTestCase {

    func test_GoToLogin_CallsNavWithCorrectVC() {
       let (sut, nav) = makeSut()

        sut.goToLogin()
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers[0] is LoginViewController)
    }

    func test_GoToSignUp_CallsNavWithCorrectVC() {
       let (sut, nav) = makeSut()

        sut.goToSignUp()
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers[0] is SignUpViewController)
    }
}

extension WelcomeRouterTests {
    func makeSut() -> (sut: WelcomeRouter, nav: NavigationController) {
        let loginFactorySpy = LoginFactorySpy()
        let signUpFactorySpy = SignUpFactorySpy()
        let nav = NavigationController()
        let sut = WelcomeRouter(nav: nav, loginFactory: loginFactorySpy.makeLogin, signUpFactory: signUpFactorySpy.makeSignUp)
        return (sut, nav)
    }
}

extension WelcomeRouterTests {
    class LoginFactorySpy {
        func makeLogin() -> LoginViewController {
            LoginViewController.instantiate()
        }
    }

    class SignUpFactorySpy {
        func makeSignUp() -> SignUpViewController {
            SignUpViewController.instantiate()
        }
    }
}
