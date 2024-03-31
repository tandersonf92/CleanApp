import Data
import Domain
import XCTest


final class RemoteAuthenticationTests: XCTestCase {
    func test_auth_shouldCallHttpClientWithCorrectUrl() {
        let (sut, httpClientSpy) = makeSut()
        let url = makeURL()

        sut.auth(authenticationModel: makeAuthenticationModel()) { _ in }

        XCTAssertEqual(httpClientSpy.urls, [url])
    }

    func test_auth_shouldCallHttpClientWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        let authenticationModel = makeAuthenticationModel()

        sut.auth(authenticationModel: authenticationModel) { _ in }

        XCTAssertEqual(httpClientSpy.data, authenticationModel.toData())
    }

    func test_auth_shouldCompleteWithErrorIfClientCompleteWithError() {
        let (sut, httpClientSpy) = makeSut()

        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivityError)
        })
    }

    func test_auth_shouldCompleteWithExpiredSessionErrorIfClientCompleteWithUnauthorized() {
        let (sut, httpClientSpy) = makeSut()

        expect(sut, completeWith: .failure(.expiredSession), when: {
            httpClientSpy.completeWithError(.unauthorized)
        })
    }

    func test_auth_shouldCompleteWithAccountIfClientCompleteWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let expectedAccount = makeAccountModel()

        expect(sut, completeWith: .success(expectedAccount), when: {
            httpClientSpy.completeWithData(expectedAccount.toData()!)
        })
    }
}


extension RemoteAuthenticationTests {

    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath,
                 line: UInt = #line) -> (sut: RemoteAuthentication, httpClientSpy: HTTPClientSpy) {
        let httpClientSpy = HTTPClientSpy()
        let sut = RemoteAuthentication(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }

    func expect(_ sut: RemoteAuthentication, completeWith expectedResult: AuthenticationUseCase.Result, when action: () -> Void, file: StaticString = #filePath,
                line: UInt = #line) {
        let exp = expectation(description: "waiting")

        sut.auth(authenticationModel: makeAuthenticationModel()) { receivedResult in
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

