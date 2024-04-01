import UI
import Validation
import XCTest

@testable import Main

final class LoginControllerFactoryTests: XCTestCase {

    func test_BackgroundRequest_ShouldCompleteOnMainThread() {
        let (sut, authenticationSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.login?(makeLoginViewModel())

        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            authenticationSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func test_LoginComposeWithCorrectValidations() throws {
        let validations = makeLoginValidations()
        let emailFieldValidation = try XCTUnwrap(validations[0] as? RequiredFieldValidation)
        let emailValidation = try XCTUnwrap(validations[1] as? EmailValidation)
        let passwordValidation = try XCTUnwrap(validations[2] as? RequiredFieldValidation)

        XCTAssertEqual(emailFieldValidation, RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"))
        XCTAssertEqual(emailValidation, EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy()))
        XCTAssertEqual(passwordValidation, RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha"))
    }
}

extension LoginControllerFactoryTests {
    func makeSut(file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: LoginViewController, authentication: AuthenticationSpy) {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeLoginController(authentication: MainQueueDispatchDecorator(authenticationSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: authenticationSpy, file: file, line: line)

        return (sut, authenticationSpy)
    }
}
