import Data
import Domain
import XCTest


final class RemoteAuthenticationTests: XCTestCase {
    func test_add_shouldCallHttpClientWithCorrectUrl() {
        let (sut, httpClientSpy) = makeSut()
        let url = makeURL()

        sut.auth(authenticationModel: makeAuthenticationModel())

        XCTAssertEqual(httpClientSpy.urls, [url])
    }

    func test_add_shouldCallHttpClientWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        let authenticationModel = makeAuthenticationModel()

        sut.auth(authenticationModel: authenticationModel)

        XCTAssertEqual(httpClientSpy.data, authenticationModel.toData())
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

//    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: AddAccountUseCase.Result, when action: () -> Void, file: StaticString = #filePath,
//                line: UInt = #line) {
//        let exp = expectation(description: "waiting")
//
//        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
//            switch (expectedResult, receivedResult) {
//            case  (.success(let expectedAccount), .success(let receivedAccount)):
//                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
//            case  (.failure(let expectedError), .failure(let receivedError)):
//                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
//            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
//            }
//            exp.fulfill()
//        }
//        action()
//        wait(for: [exp], timeout: 1)
//    }
}

