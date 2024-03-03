import XCTest
@testable import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_SignUp_ShouldShowErrorMessageIfNameIsNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(name: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "Nome"))
    }

    func test_SignUp_ShouldShowErrorMessageIfEmailIsNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(email: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "Email"))
    }

    func test_SignUp_ShouldShowErrorMessageIfPasswordIsNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(password: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "Password"))
    }

    func test_SignUp_ShouldShowErrorMessageIfPasswordConfirmationIsNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))

        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(fieldName: "Confirmar Senha"))
    }
    
    func test_SignUp_ShouldShowErrorMessageIfPasswordConfirmationNotMatch() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)

        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))

        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "Confirmar Senha"))
    }

    func test_SignUp_ShouldShowErrorMessageIfInvalidEmailIsProvided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()

        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "Email"))
    }

    func test_SignUp_ShouldCallEmailValidatorWithCorrectEmail() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
}

extension SignUpPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter {
        let alertViewSpy = alertView
        let emailValidatorSpy = emailValidator
        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        return sut
    }

    func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é obrigatório")
    }

    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Falha na validação", message: "O campo \(fieldName) é inválido")
    }

    func makeSignUpViewModel(name: String? = "any_name", email: String? = "any_email@email.com", password: String? = "any_password", passwordConfirmation: String? = "any_password") -> SignUpViewModel {
        SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }

    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?

        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }

    class EmailValidatorSpy: EmailValidator {

        var isValid: Bool = true
        var email: String?

        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }

        func simulateInvalidEmail() {
            isValid = false
        }
    }
}
