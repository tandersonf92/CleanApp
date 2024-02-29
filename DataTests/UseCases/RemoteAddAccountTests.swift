import Data
import Domain
import XCTest


final class RemoteAddAccountTests: XCTestCase {
    func test_add_shouldCallHttpClientWithCorrectUrl() {
        let (sut, httpClientSpy) = makeSut()
        let url = URL(string: "http://any-url.com")!

        sut.add(addAccountModel: makeAddAccountModel()) { _ in }

        XCTAssertEqual(httpClientSpy.urls, [url])
    }

    func test_add_shouldCallHttpClientWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()

        sut.add(addAccountModel: addAccountModel) { _ in }

        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }

    func test_shouldNotCompleteWithErrorIfClientFails() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { error in
            XCTAssertEqual(error, .unexpected)
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivityError)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteAddAccountTests {

    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HTTPClientSpy) {
        let httpClientSpy = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)

        return (sut, httpClientSpy)
    }

    func makeAddAccountModel() -> AddAccountModel {
        AddAccountModel(name: "any_name",
                        email: "any_email@email.com",
                        password: "any_password",
                        passwordConfirmation: "any_password")
    }

    class HTTPClientSpy: HttpPostClient {
        var urls: [URL?] = []
        var data: Data?
        var completion: ((HttpError) -> Void)?

        func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void) {
            urls.append(url)
            self.data = data
            self.completion = completion
        }

        func completeWithError(_ error: HttpError) {
            completion?(error)
        }
    }
}
