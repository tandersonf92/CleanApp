import Presentation
import XCTest

@testable import UI

final class LoginViewControllerTests: XCTestCase {

    func test_LoadingIsHiddenOnStart() {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }

    func test_SutImplementsLoadingView() {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
}

extension LoginViewControllerTests {
    func makeSut() -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.loadViewIfNeeded()

        return sut
    }
}
