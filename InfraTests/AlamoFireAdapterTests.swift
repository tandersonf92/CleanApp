import Alamofire
import Data
import Infra
import XCTest

final class AlamoFireAdapterTests: XCTestCase {
    func test_post_ShouldMakeRequestWithValidUrlAndMethod() {
        let url = makeURL()
        testRequestFor(data: makeValidData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }

    func test_post_ShouldMakeRequestWithNoData() {
        testRequestFor(url: makeURL(), data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }

    func test_post_ShouldCompleteWithErrorWhenRequestCompletesWithError() {
        expectResult(.failure(.noConnectivityError), when: (data: nil, response: nil, error: makeError()))
    }

    func test_post_ShouldCompleteWithErrorOnAllInvalidCases() {
        expectResult(.failure(.noConnectivityError), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivityError), when: (data: makeValidData(), response: nil, error: makeError()))
        expectResult(.failure(.noConnectivityError), when: (data: makeValidData(), response: nil, error: nil))
        expectResult(.failure(.noConnectivityError), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivityError), when: (data: nil, response: makeHttpResponse(), error: nil))
        expectResult(.failure(.noConnectivityError), when: (data: nil, response: nil, error: nil))
    }

    func test_post_ShouldCompleteWithDataWhenRequestCompletesWith200() {
        expectResult(.success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
    }

    func test_post_ShouldCompleteWithNoDataWhenRequestCompletesWith204() {
        expectResult(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }

    func test_post_ShouldCompleteWithErrorWhenRequestCompletesWithNon200() {
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 450), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 499), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 550), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 599), error: nil))
        expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
    }
}

extension AlamoFireAdapterTests {
    func makeSut(file: StaticString = #filePath,
                 line: UInt = #line) -> AlamoFireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamoFireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }

    func testRequestFor(url: URL = makeURL(), data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")

        sut.post(to: url, with: data) { _ in exp.fulfill() }
        var request: URLRequest?

        URLProtocolStub.observerRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }

    func expectResult(_ expectedResult: Result<Data?, HttpError>,
                      when stub: (data: Data?, response: HTTPURLResponse?, error: Error?),
                      file: StaticString = #filePath,
                      line: UInt = #line) {
        let sut = makeSut()
        URLProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.post(to: makeURL(), with: makeValidData()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)    }
}
