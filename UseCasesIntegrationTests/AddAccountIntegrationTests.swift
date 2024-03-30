import Data
import Domain
import Infra
import XCTest

final class AddAccountIntegrationTests: XCTestCase {

    func test_AddAccount() throws {
        let alamofireAdapter = AlamoFireAdapter()
        let url = try XCTUnwrap(URL(string: "https://fordevs.herokuapp.com/api/signup"))
        let addAccountModel = AddAccountModel(name: "Anderson Oliveira", email: "\(UUID().uuidString)@gmail.com", password: "secret", passwordConfirmation: "secret")
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure: XCTFail("Expect success got \(result) instead")
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)

        let exp2 = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error) where error == .emailInUse:
                XCTAssertNotNil(error)
            default:
                XCTFail("Expect success got \(result) instead")            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5)
    }
}
