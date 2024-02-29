import Data
import Domain
import XCTest


final class RemoteAddAccountTests: XCTestCase {
    func test_add_shouldCallHttpClientWithCorrectUrl() {
        let (sut, httpClientSpy) = makeSut()
        let url = makeURL()

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

        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivityError)
        })
    }

    func test_shouldCompleteWithAccountIfClientCompleteWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let expectedAccount = makeAccountModel()

        expect(sut, completeWith: .success(expectedAccount), when: {
            httpClientSpy.completeWithData(expectedAccount.toData()!)
        })
    }

    func test_shouldCompleteWithErrorIfClientCompleteWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()

        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
}

extension RemoteAddAccountTests {

    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HTTPClientSpy) {
        let httpClientSpy = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)

        return (sut, httpClientSpy)
    }

    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void) {
        let exp = expectation(description: "waiting")

        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case  (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount)
            case  (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }

    func makeInvalidData() -> Data {
        Data("invalid_data".utf8)
    }

    func makeURL() -> URL {
        URL(string: "http://any-url.com")!
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
