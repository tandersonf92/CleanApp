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

    func test_shouldNotCompleteIfSutHasBeenDeallocated() {
        let httpClientSpy = HTTPClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeURL(), httpClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?

        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }

        sut = nil
        httpClientSpy.completeWithError(.noConnectivityError)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {

    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy: HTTPClientSpy) {
        let httpClientSpy = HTTPClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }

    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath,
line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }

    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath,
                line: UInt = #line) {
        let exp = expectation(description: "waiting")

        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case  (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            case  (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
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
