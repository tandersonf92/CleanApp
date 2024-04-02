import XCTest

@testable import UI

final class WelcomeViewControllerTests: XCTestCase {

    func test_LoginButtonCallsSignUpOnTap() throws {
        let (sut, buttonSpy) = makeSut()
        sut.loginButton?.simulateTap()

        XCTAssertEqual(buttonSpy.clicks, 1)
    }

    func test_SignUpButtonCallsSignUpOnTap() throws {
        let (sut, buttonSpy) = makeSut()
        sut.signUpButton?.simulateTap()

        XCTAssertEqual(buttonSpy.clicks, 1)
    }
}

extension WelcomeViewControllerTests {
    func makeSut() -> (sut: WelcomeViewController, buttonSpy: ButtonSpy) {
        let sut = WelcomeViewController.instantiate()
        let buttonSpy = ButtonSpy()
        sut.login = buttonSpy.onClick
        sut.signUp = buttonSpy.onClick
        sut.loadViewIfNeeded()
        return (sut, buttonSpy)
    }

    class ButtonSpy {
        var clicks = 0
        func onClick() {
            clicks += 1
        }
    }
}
