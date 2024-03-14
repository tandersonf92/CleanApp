import UI
import XCTest

@testable import Main

final class SignUpComposerTests: XCTestCase {

    func test_BackgroundRequest_ShouldCompleteOnMainThread() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()
    }
}

extension SignUpComposerTests {
    func makeSut(file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: SignUpViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeControllerWith(addAccount: addAccountSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)

        return (sut, addAccountSpy)
    }
}
