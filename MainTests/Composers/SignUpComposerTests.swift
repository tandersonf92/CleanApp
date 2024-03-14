import XCTest
@testable import Main

final class SignUpComposerTests: XCTestCase {

    func test_Ui_Presentation_Integration() {
        let sut = SignUpComposer.composeControllerWith(addAccount: AddAccountSpy())

        checkMemoryLeak(for: sut)
    }
}
