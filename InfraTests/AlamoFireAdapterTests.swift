import Alamofire
import XCTest
import Data

class AlamoFireAdapter {
    private var session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
            guard dataResponse.response?.statusCode != nil else {
                return completion(.failure(.noConnectivityError))
            }
            switch dataResponse.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let failure):
                completion(.failure(.noConnectivityError))
            }
        }
    }
}

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
        let sut = makeSut()
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

    func expectResult(_ expectedResult: Result<Data, HttpError>,
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

class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var error: Error?
    static var data: Data?
    static var response: HTTPURLResponse?

    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }

    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        URLProtocolStub.data = data
        URLProtocolStub.response = response
        URLProtocolStub.error = error
    }

    override open class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override open func startLoading() {
        URLProtocolStub.emit?(request)
        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)

    }

    override open func stopLoading() {}
}
