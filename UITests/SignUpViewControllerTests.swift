import Presentation
import XCTest

@testable import UI

final class SignUpViewControllerTests: XCTestCase {

    func test_LoadingIsHiddenOnStart() {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }

    func test_SutImplementsLoadingView() {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        XCTAssertNotNil(sut as LoadingView)
    }
}
