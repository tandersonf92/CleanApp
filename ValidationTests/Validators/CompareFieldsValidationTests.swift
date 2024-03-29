import Presentation
import Validation
import XCTest

final class CompareFieldsValidationTests: XCTestCase {

    func test_WhenValidate_ShouldReturnErrorIfComparationFails() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Senha")

        let errorMessage = sut.validate(data: ["password": "123", "passwordConfirmation": "1234"])

        XCTAssertEqual(errorMessage, "O campo Senha é inválido")
    }

    func test_WhenValidate_ShouldReturnErrorWithCorrectFieldLabel() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar Senha")

        let errorMessage = sut.validate(data: ["password": "123", "passwordConfirmation": "1234"])

        XCTAssertEqual(errorMessage, "O campo Confirmar Senha é inválido")
    }

    func test_WhenValidate_ShouldReturnNilIfComparationSucceeds() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Senha")

        let errorMessage = sut.validate(data: ["password": "123", "passwordConfirmation": "123"])

        XCTAssertNil(errorMessage)
    }

    func test_WhenValidate_ShouldReturnNilIfNoDataIsProvided() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Senha")

        let errorMessage = sut.validate(data: nil)

        XCTAssertEqual(errorMessage, "O campo Senha é inválido")
    }
}

extension CompareFieldsValidationTests {
    func makeSut(fieldName: String,
                 fieldNameToCompare: String,
                 fieldLabel: String,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> Validation {
        let sut = CompareFieldsValidation(fieldName: fieldName, fieldNameToCompare: fieldNameToCompare, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
