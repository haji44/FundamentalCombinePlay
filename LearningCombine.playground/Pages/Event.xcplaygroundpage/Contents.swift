//: [Previous](@previous)
import Combine

enum MyError: Error {
    case failed
}

let subject = PassthroughSubject<String, MyError>()

final class Receiver {
    private var subscriptions = Set<AnyCancellable>()

    init() {
        subject
            .sink(receiveCompletion: { completion in
                print("Received completion:", completion)
            }, receiveValue: { value in
                print("Received value:", value)
            })
            .store(in: &subscriptions)
    }
}

let receiver = Receiver()
subject.send("あ")
subject.send("い")
subject.send("う")
subject.send(completion: .failure(.failed))
subject.send("え")
subject.send("お")
//: [Next](@next)
