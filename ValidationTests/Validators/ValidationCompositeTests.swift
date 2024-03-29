import XCTest
import Presentation
import Validation

final class ValidationCompositeTests: XCTestCase {

    func test_ValidateShouldReturnErrorIfValidationFails() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])

        validationSpy.simulateError("Erro 1")
        let errorMessage = sut.validate(data: ["name" : "Anderson"])

        XCTAssertEqual(errorMessage, "Erro 1")
    }

    func test_ValidateShouldReturnCorrectErrorMessage() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy, ValidationSpy()])

        validationSpy.simulateError("Erro 3")
        let errorMessage = sut.validate(data: ["name" : "Anderson"])

        XCTAssertEqual(errorMessage, "Erro 3")
    }

    func test_ValidateShouldReturnTheFirstErrorMessage() {
        let validationSpy2 = ValidationSpy()
        let validationSpy3 = ValidationSpy()
        let sut = makeSut(validations: [ValidationSpy(), validationSpy2, validationSpy3])

        validationSpy2.simulateError("Erro 2")
        validationSpy3.simulateError("Erro 3")
        let errorMessage = sut.validate(data: ["name" : "Anderson"])

        XCTAssertEqual(errorMessage, "Erro 2")
    }

    func test_ValidateShouldReturnNilIfValidationSucceeds() {
        let sut = makeSut(validations: [ValidationSpy(), ValidationSpy()])

        let errorMessage = sut.validate(data: ["name" : "Anderson"])

        XCTAssertNil(errorMessage)
    }

    func test_ValidateShouldCallValidationWithCorrectData() throws {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        let expectedData = ["name" : "Anderson"]

        let _ = sut.validate(data: expectedData)
        let data = try XCTUnwrap(validationSpy.data)

        XCTAssertTrue(NSDictionary(dictionary: data).isEqual(to: expectedData))
    }
}

extension ValidationCompositeTests {
    func makeSut(validations: [ValidationSpy],
                 file: StaticString = #filePath,
                 line: UInt = #line) -> ValidationComposite {
        let sut = ValidationComposite(validations: validations)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
