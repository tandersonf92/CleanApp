import XCTest

@testable import UI

class WelcomeRouter {
    private let nav: NavigationController
    private let loginFactory: () -> LoginViewController

    init(nav: NavigationController, loginFactory: @escaping () -> LoginViewController) {
        self.nav = nav
        self.loginFactory = loginFactory
    }

    func goToLogin() {
        nav.pushViewController(loginFactory())
    }
}

final class WelcomeRouterTests: XCTestCase {

    func test_GoToLogin_CallsNavWithCorrectVC() {
        let loginFactorySpy = LoginFactorySpy()
        let nav = NavigationController()
        let sut = WelcomeRouter(nav: nav, loginFactory: loginFactorySpy.makeLogin)

        sut.goToLogin()
        XCTAssertEqual(nav.viewControllers.count, 1)
        XCTAssertTrue(nav.viewControllers[0] is LoginViewController)
    }

    class LoginFactorySpy {
        func makeLogin() -> LoginViewController {
            LoginViewController.instantiate()
        }
    }
}

