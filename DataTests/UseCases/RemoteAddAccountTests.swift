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

    func test_shouldCompleteWithErrorIfClientCompleteWithError() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")

        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .success:
                XCTFail("Expected error received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivityError)
        wait(for: [exp], timeout: 1)
    }

    func test_shouldCompleteWithAccountIfClientCompleteWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedAccount = makeAccountModel()

        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .success(let receivedAccount):
                XCTAssertEqual(receivedAccount, expectedAccount)
            case .failure:
                XCTFail("Expected success received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(expectedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }

    func test_shouldCompleteWithErrorIfClientCompleteWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")

        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .success:
                XCTFail("Expected error received \(result) instead")
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(Data("invalid_data".utf8))
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

    func makeAccountModel() -> AccountModel {
        AccountModel(id: "any_id",
                     name: "any_name",
                     email: "any_email@email.com",
                     password: "any_password")
    }

    class HTTPClientSpy: HttpPostClient {
        var urls: [URL?] = []
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?

        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            urls.append(url)
            self.data = data
            self.completion = completion
        }

        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }

        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}
