//: [Previous](@previous)

/*: # Sbuscription
- Word Defeniton
 1. __subscribe__\
 Setting the event that publisher send is called subscribe

 2. **subscription**\
 Return value of subscribe

 sink method used to subscribe and return subscription
 */

import Combine

let subject = PassthroughSubject<String, Never>()

final class Receiver {
    private var subscriptions = Set<AnyCancellable>()

    init() {
        subject
            .sink { value in
                print("Received value:", value)
            }
        .store(in: &subscriptions)
    }
}

let receiver = Receiver()
subject.send("あ")
subject.send("い")
subject.send("う")
subject.send("え")
subject.send("お")

/*:
 - callout(store method): Why does it use store?\
- Reason\
 If discarded return value of subscription, receving implementaiton process also discard.
Then, store method comes in
 */


let subject1 = PassthroughSubject<String, Never>()
let subject2 = PassthroughSubject<String, Never>()

final class MutilpleReciving {
    private var subscriptions = Set<AnyCancellable>()

    init() {
        subject1
            .sink { value in
                print("[1] Received value:", value)
            }
            .store(in: &subscriptions)
        subject2
            .sink { value in
                print("[2] Received value:", value)
            }
            .store(in: &subscriptions)
    }
}

let multiReciever = MutilpleReciving()
subject1.send("あ")
subject2.send("い")
subject1.send("う")
subject2.send("え")
subject1.send("お")



//: [Next](@next)
