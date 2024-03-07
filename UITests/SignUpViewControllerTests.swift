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

    func test_SaveButtonCallsSignUpOnTap() {
        var signUpViewModel: SignUpViewModel?
        let sut = makeSut() { signUpViewModel = $0 }

        sut.saveButton?.simulateTap()
        let name = sut.nameTextField?.text
        let email = sut.emailTextField?.text
        let password = sut.passwordTextField?.text
        let passwordConfirmation = sut.passwordConfirmationTextField.text

        XCTAssertEqual(signUpViewModel, SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation))
    }
}

extension SignUpViewControllerTests {
    func makeSut(signUpSpy: ((SignUpViewModel) -> Void)? = nil) -> SignUpViewController {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        sut.signUp = signUpSpy

        sut.loadViewIfNeeded()

        return sut
    }
}
