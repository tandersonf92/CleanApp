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

        // Flacky test
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }

    func test_shouldCompleteWithErrorIfClientCompleteWithError() {
        let (sut, httpClientSpy) = makeSut()

        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivityError)
        })
    }

    func test_shouldCompleteWithEmailInUseErrorIfClientCompleteWithForbidden() {
        let (sut, httpClientSpy) = makeSut()

        expect(sut, completeWith: .failure(.emailInUse), when: {
            httpClientSpy.completeWithError(.forbidden)
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
}
