import UIKit
import Combine

/*: ## Simple Example of Subject
 - やっていることイベントの送受信を行う
 - 送信処理: subject の send メソッドを呼ぶとイベントが送信されます。このコードでは、1 文字の値を送るイベントを 5 回に分けて送信しています。
 - 受信処理: Receiver クラスの中で、subject の sink メソッドを呼んでいます。sink メソッドは、イベントを受信したときの処理を指定します。このコードでは、print メソッドで値をコンソールに出力しています。
*/

// subject publishe event when calling send method or value change
let subject = PassthroughSubject<String, Never>()

final class Receiver {
    // this property play an role of keep publisher
    private var subscriptions = Set<AnyCancellable>()

    init() {
        subject
        // in sink method, we define the execution when event happen on subject
            .sink { value in
                print("Received value:", value)
            }
        // without store method, the reciever never get change or event
            .store(in: &subscriptions)
    }
}

let receiver = Receiver()
subject.send("あ")
subject.send("い")
subject.send("う")
subject.send("え")
subject.send("お")


/*: ## Publisher
 - Defenition
The object that send event is called publisher, and the sending event is called publish


### Various type of Publisher
There are some kind of built in publisher in swift
NotificationCenter calss is the publisher that used often in usual.
*/

/*: ## Usage of Notification center in combine
1. Declare the notification name
1. Create Publisher by Notification center
1. Setting the implementation when notificationcenter send event
1. post notification via notification center
 */
let myNotification = Notification.Name("MyNotification")
let notificationPublisher = NotificationCenter.default
    .publisher(for: myNotification)

notificationPublisher.sink { value in
    print("Received value: ", value)
}

NotificationCenter.default.post(Notification(name: myNotification))


/*: ## Usage of Timer in combine
1. Declare the notification name
1. Create Publisher by Notification center
1. Setting the implementation when notificationcenter send event
1. post notification via notification center

## when to use Timer?
Timer allow it to execute event over time.
 */


let timer = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()
    .sink { value in
        print("timer ", value)
    }

