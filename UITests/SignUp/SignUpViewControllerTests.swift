import Presentation
import XCTest

@testable import UI

final class SignUpViewControllerTests: XCTestCase {

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
        var signUpViewModel: SignUpRequest?
        let sut = makeSut() { signUpViewModel = $0 }

        sut.saveButton?.simulateTap()
        let name = try XCTUnwrap(sut.nameTextField?.text)
        let email = try XCTUnwrap(sut.emailTextField?.text)
        let password = try XCTUnwrap(sut.passwordTextField?.text)
        let passwordConfirmation = try XCTUnwrap(sut.passwordConfirmationTextField.text)

        XCTAssertEqual(signUpViewModel, SignUpRequest(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation))
    }
}

extension SignUpViewControllerTests {
    func makeSut(signUpSpy: ((SignUpRequest) -> Void)? = nil) -> SignUpViewController {
        let sut = SignUpViewController.instantiate()
        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()

        return sut
    }
}
