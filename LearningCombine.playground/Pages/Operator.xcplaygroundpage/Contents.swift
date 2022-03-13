//: [Previous](@previous)
/*: # Operator
 Publisher を別の Publisher に変換するメソッドを、Combine の用語で「Operator」と呼びます。
 */

import Combine
import Foundation

let subject = PassthroughSubject<Int, Never>()

final class Receiver {
    private var subscriptions = Set<AnyCancellable>()
    private let formatter = NumberFormatter()

    init() {
        formatter.numberStyle = .spellOut

        subject
            .map { value in
                self.formatter.string(
                    from: NSNumber(integerLiteral: value)) ?? ""
            }
            .sink { value in
                print("Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver = Receiver()
subject.send(0)
subject.send(1)
subject.send(2)
subject.send(3)
subject.send(4)


let strings = PassthroughSubject<String, Never>()
strings.map { value in
    Int(value) ?? 0
}
.sink { result in
    print("Receive value : ", result)
}

strings.send("333")


//: [Next](@next)
