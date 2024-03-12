import Presentation
import XCTest

@testable import Validation

public final class EmailValidatorAdapter: EmailValidator {
    private let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        if let regex = try? NSRegularExpression(pattern: pattern) {
            return regex.firstMatch(in: email, range: range) != nil
        }
        return false
    }
}

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
