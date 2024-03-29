import XCTest
import Validation

final class EmailValidationTests: XCTestCase {
    func test_ValidateShouldReturnErrorIfInvalidEmailsIsProvided() {
        let spy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: spy)

        spy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email" : "invalid_email@gmail.com"])

        XCTAssertEqual(errorMessage, "O campo Email é invalido")
    }

    func test_ValidateShouldReturnErrorWithCorrectFieldLabel() {
        let spy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email", fieldLabel: "Email2", emailValidator: spy)

        spy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email" : "invalid_email@gmail.com"])

        XCTAssertEqual(errorMessage, "O campo Email2 é invalido")
    }

    func test_ValidateShouldReturnNilIfValidEmailsIsProvided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy())

        let errorMessage = sut.validate(data: ["email" : "valid_email@gmail.com"])

        XCTAssertNil(errorMessage)
    }

    func test_ValidateShouldReturnErrorIfNoDataIsProvided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorSpy())

        let errorMessage = sut.validate(data: nil)

        XCTAssertEqual(errorMessage, "O campo Email é invalido")
    }
}

extension EmailValidationTests {
    func makeSut(fieldName: String,
                 fieldLabel: String,
                 emailValidator: EmailValidatorSpy,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> EmailValidation {
        let sut = EmailValidation(fieldName: fieldName, fieldLabel: fieldLabel, emailValidator: emailValidator)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
