import Presentation
import Validation
import XCTest

final class RequiredFieldValidationTests: XCTestCase {

    func test_WhenValidate_ShouldReturnErrorIfFieldIsNotProvided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")

        let errorMessage = sut.validate(data: ["name": "Rodrigo"])

        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }

    func test_WhenValidate_ShouldReturnErrorWithCorrectFieldLabel() {
        let sut = makeSut(fieldName: "age", fieldLabel: "Idade")

        let errorMessage = sut.validate(data: ["name": "Rodrigo"])

        XCTAssertEqual(errorMessage, "O campo Idade é obrigatório")
    }

    func test_WhenValidate_ShouldReturnNilIfFieldIsProvided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")

        let errorMessage = sut.validate(data: ["email": "any_email@gmail.com"])

        XCTAssertNil(errorMessage)
    }

    func test_WhenValidate_ShouldReturnNilIfNoDataIsProvided() {
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")

        let errorMessage = sut.validate(data: nil)

        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
}

extension RequiredFieldValidationTests {
    func makeSut(fieldName: String,
                 fieldLabel: String,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> Validation {
        let sut = RequiredFieldValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
