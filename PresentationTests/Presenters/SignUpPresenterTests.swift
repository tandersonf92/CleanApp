import XCTest
@testable import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_SignUp_ShouldShowErrorMessageIfNameIsNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Nome é obrigatório"))
    }

    func test_SignUp_ShouldShowErrorMessageIfEmailIsNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", password: "any_password", passwordConfirmation: "any_password")

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Email é obrigatório"))
    }

    func test_SignUp_ShouldShowErrorMessageIfPasswordIsNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@email.com", passwordConfirmation: "any_password")

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Password é obrigatório"))
    }

    func test_SignUp_ShouldShowErrorMessageIfPasswordConfirmationIsNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@email.com", password: "any_password")

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "O campo Confirmar Senha é obrigatório"))
    }
    
    func test_SignUp_ShouldShowErrorMessageIfPasswordConfirmationNotMatch() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "wrong_password")

        sut.signUp(viewModel: signUpViewModel)

        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Falha ao confirmar senha"))
    }
}

extension SignUpPresenterTests {
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?

        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }

    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        return (sut, alertViewSpy)
    }
}
