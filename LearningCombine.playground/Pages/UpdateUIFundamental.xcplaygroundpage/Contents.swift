//: [Previous](@previous)

import Combine
import PlaygroundSupport
import UIKit

/*: ## Define new Model
 */

final class Account {
    // 変更された値を受け取って通知をおくりたい
    private let nameSubject: CurrentValueSubject<String, Never>
    private let ageSubject: CurrentValueSubject<Int, Never>

    // View層とやり取りをする際に使うプロパティー
    var name: String { nameSubject.value }
    var age: Int { ageSubject.value }

    // 値を変更を通知したい
    let isVaild: AnyPublisher<Bool, Never>

    init() {
        // Initialzie subject value
        nameSubject = CurrentValueSubject<String, Never>("")
        ageSubject = CurrentValueSubject<Int, Never>(0)
        isVaild = nameSubject.combineLatest(ageSubject)
            .map({ name, age in
                name.count >= 4 && age >= 18
            }).eraseToAnyPublisher()
    }

    func update(userName: String, age: Int) {
        nameSubject.value = userName
        ageSubject.value = age
    }
}

/*: ## Defeine View and UIComponent

 */
let view = UIView()
view.frame = CGRect(x: 0, y: 0, width: 320, height: 160)
view.backgroundColor = .white
PlaygroundPage.current.liveView = view

let label = UILabel()
label.frame = CGRect(x: 20, y: 20, width: 280, height: 20)
label.textColor = .black
label.text = "initial text"
view.addSubview(label)


/*: ## Define new receiver
 */

final class Receiver {
    private var subscription = Set<AnyCancellable>()
    private let account = Account()

    init() {
        account.isVaild
            .map { "\($0)" }
            .assign(to: \.text, on: label)
            .store(in: &subscription)
    }

    func load(name: String, age: Int) {
        account.update(userName: name, age: age)
    }
}


let reciver = Receiver()
reciver.load(name: "hoge", age: 3)
reciver.load(name: "huga", age: 30)



//: [Next](@next)
