import Presentation
import XCTest

@testable import Validation

final class EmailValidatorAdapterTests: XCTestCase {

    func test_InvalidEmails() {
        let sut = makeSut()

        XCTAssertFalse(sut.isValid(email: "rr"))
        XCTAssertFalse(sut.isValid(email: "rr@"))
        XCTAssertFalse(sut.isValid(email: "rr@rr"))
        XCTAssertFalse(sut.isValid(email: "rr@rr."))
        XCTAssertFalse(sut.isValid(email: "@rr.com"))
    }

    func test_ValidEmails() {
        let sut = makeSut()

        XCTAssertTrue(sut.isValid(email: "rr@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "rodrigo@hotmail.com"))
        XCTAssertTrue(sut.isValid(email: "rr.rr@outlook.com"))
    }

    func makeSut() -> EmailValidatorAdapter {
        EmailValidatorAdapter()
    }
}
