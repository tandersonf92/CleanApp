import Domain
import XCTest

class RemoteAddAccount {
    private let url: URL
    private let httpClient: HttpPostClient

    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    func add(addAccountModel: AddAccountModel) {
        httpClient.post(to: url, with: addAccountModel.toData())
    }
}

protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}

final class RemoteAddAccountTests: XCTestCase {
    func test_add_shouldCallHttpClientWithCorrectUrl() {
        let (sut, httpClientSpy) = makeSut()
        let url = URL(string: "http://any-url.com")!

        sut.add(addAccountModel: makeAddAccountModel())

        XCTAssertEqual(httpClientSpy.url, url)
    }

    func test_add_shouldCallHttpClientWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()

        sut.add(addAccountModel: addAccountModel)

        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
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
        var url: URL?
        var data: Data?

        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
