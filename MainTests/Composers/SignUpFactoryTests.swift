import UI
import Validation
import XCTest

@testable import Main

final class SignUpComposerTests: XCTestCase {

    func test_BackgroundRequest_ShouldCompleteOnMainThread() {
        let (sut, addAccountSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpViewModel())

        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccountSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func test_SignUpComposeWithCorrectValidations() throws {
        let validations = makeSignUpValidations()
        let nameValidation = try XCTUnwrap(validations[0] as? RequiredFieldValidation)
        let emailFieldValidation = try XCTUnwrap(validations[1] as? RequiredFieldValidation)
        let emailValidation = try XCTUnwrap(validations[2] as? EmailValidation)
        let passwordValidation = try XCTUnwrap(validations[3] as? RequiredFieldValidation)
        let passwordConfirmationValidation = try XCTUnwrap(validations[4] as? RequiredFieldValidation)
        let compareFieldsValidation = try XCTUnwrap(validations[5] as? CompareFieldsValidation)

        XCTAssertEqual(nameValidation, RequiredFieldValidation(fieldName: "name", fieldLabel: "Nome"))
        XCTAssertEqual(emailFieldValidation, RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"))
        XCTAssertEqual(emailValidation, EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy()))
        XCTAssertEqual(passwordValidation, RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha"))
        XCTAssertEqual(passwordConfirmationValidation, RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar senha"))
        XCTAssertEqual(compareFieldsValidation, CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar senha"))

    }
}

extension SignUpComposerTests {
    func makeSut(file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: SignUpViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSignUpComtroller(addAccount: MainQueueDispatchDecorator(addAccountSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)

        return (sut, addAccountSpy)
    }
}
