//: [Previous](@previous)

/*: @Published
変更した内容をモデル側から通知するために使う
 */
import Combine
import Foundation
import Security

final class Account {
    private(set) var userId = ""
    private(set) var password = ""
    @Published private(set) var isValid = false

    func update(userId: String, password: String) {
        self.userId = userId
        self.password = password
        isValid = userId.count >= 4 && password.count >= 4
    }
}

final class Receiver {
    private var subscriptions = Set<AnyCancellable>()
    private let account = Account()

    init() {
        account.$isValid.sink { isValid in
            print("isValid : ", isValid)
        }
        .store(in: &subscriptions)
    }


    func load() {
        account.update(userId: "hoge", password: "pass")
    }
}

let receiver = Receiver()
receiver.load()

final class AccountCurrent {
    private(set) var userId = ""
    private(set) var password = ""
    private let isValidSubject: CurrentValueSubject<Bool, Never>
    let isValid: AnyPublisher<Bool, Never>

    init() {
        isValidSubject = CurrentValueSubject<Bool, Never>(false)
        isValid = isValidSubject.eraseToAnyPublisher()
    }

    func update(userId: String, password: String) {
        self.userId = userId
        self.password = password
        let isValid = userId.count >= 4 && password.count >= 4
        isValidSubject.send(isValid)
    }
}

final class ReciverCurrnet {
    private var subscriptions = Set<AnyCancellable>()
    private let account = AccountCurrent()

    init() {
        account.isValid
            .sink { isValid in
                print("isValid: ", isValid)
            }
            .store(in: &subscriptions)
    }
    func load() {
        account.update(userId: "hoge", password: "huga")
    }

}
let current = ReciverCurrnet()
current.load()

/*:
 - callout(Using subject every property): How to use?\

 - note: interaction valiable such as input text should create user subject
 - important: Don't forget this !
 - example: Something like this
 */

final class AccountWithOperator {
    private let userIdSubject: CurrentValueSubject<String, Never>
    var userId: String { userIdSubject.value }
    private let passwordSubject: CurrentValueSubject<String, Never>
    var password: String { passwordSubject.value }
    let isValid: AnyPublisher<Bool, Never>

    init() {
        userIdSubject = CurrentValueSubject<String, Never>("")
        passwordSubject = CurrentValueSubject<String, Never>("")
        isValid = userIdSubject.combineLatest(passwordSubject)
            .map({ userId, password in
                userId.count >= 4 && password.count >= 4
            })
            .eraseToAnyPublisher()
    }

    func update(userId: String, password: String) {
        userIdSubject.value = userId
        passwordSubject.value = password
    }
}

//: [Next](@next)
