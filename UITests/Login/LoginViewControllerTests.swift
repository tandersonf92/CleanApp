import Presentation
import XCTest

@testable import UI

final class LoginViewControllerTests: XCTestCase {

    func test_LoadingIsHiddenOnStart() {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }

    func test_SutImplementsLoadingView() {
        XCTAssertNotNil(makeSut() as LoadingView)
    }

    func test_SutImplementsAlertView() {
        XCTAssertNotNil(makeSut() as AlertView)
    }

    func test_SaveButtonCallsSignUpOnTap() throws {
        var loginViewModel: LoginRequest?
        let sut = makeSut() { loginViewModel = $0 }

        sut.loginButton?.simulateTap()
        let email = try XCTUnwrap(sut.emailTextField?.text)
        let password = try XCTUnwrap(sut.passwordTextField?.text)

        XCTAssertEqual(loginViewModel, LoginRequest(email: email, password: password))
    }
}

extension LoginViewControllerTests {
    func makeSut(loginSpy: ((LoginRequest) -> Void)? = nil) -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.login = loginSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
