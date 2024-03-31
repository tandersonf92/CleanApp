import Domain
import XCTest
@testable import Presentation

final class LoginPresenterTests: XCTestCase {

    func test_Login_ShouldCallValidationWithCorrectValues() throws {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeLoginViewModel()

        sut.login(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: viewModel.toJson()!))
    }

    func test_Login_ShouldShowErrorMessageIfValidationFails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(alertView: alertViewSpy, validation: validationSpy)

        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Falha na validação", message: "Erro"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
    }

    func test_Login_ShouldCallAuthenticationtWithCorrectValues() {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy)

        sut.login(viewModel: makeLoginViewModel())

        XCTAssertEqual(authenticationSpy.authenticationModel, makeAuthenticationModel())
    }

    func test_Login_ShouldShowGenericErrorMessageIfAuthenticationFails() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)

        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
}

extension LoginPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), authentication: AuthenticationSpy = AuthenticationSpy(), validation: ValidationSpy = ValidationSpy(), file: StaticString = #filePath,
                 line: UInt = #line) -> LoginPresenter {
        let sut = LoginPresenter(validation: validation, alertView: alertView, authentication: authentication)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
