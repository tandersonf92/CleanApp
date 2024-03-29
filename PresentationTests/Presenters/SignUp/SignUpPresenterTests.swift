import Domain
import XCTest
@testable import Presentation

final class SignUpPresenterTests: XCTestCase {

    func test_SignUp_ShouldCallAddAccountWithCorrectValues() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())

        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }

    func test_SignUp_ShouldShowErrorMessageIfAddAccountFails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)

        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }

    func test_SignUp_ShouldShowLoadingBeforeAndAfterCallAddAccount() {
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy, loadingView: loadingViewSpy)

        let exp = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }

        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)

        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }

        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }

    func test_SignUp_ShouldShowSuccessMessageIfAddAccountSucceeds() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)

        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Sucesso",message: "Conta criada com sucesso."))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }

    func test_SignUp_ShouldCallValidationWithCorrectValues() throws {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeSignUpViewModel()

        sut.signUp(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: viewModel.toJson()!))
    }

    func test_SignUp_ShouldShowErrorMessageIfValidationFails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(alertView: alertViewSpy, validation: validationSpy)

        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Falha na validação", message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), addAccount: AddAccountSpy = AddAccountSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(), validation: ValidationSpy = ValidationSpy(), file: StaticString = #filePath,
                 line: UInt = #line) -> SignUpPresenter {
        let alertViewSpy = alertView
        let sut = SignUpPresenter(alertView: alertViewSpy, loadingView: loadingView, addAccount: addAccount, validation: validation)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}

