import Foundation

final class CallStation {
    var userStorage: Set<User> = []
    var callStorage: Set<Call> = []
    
    init() {}
}

extension CallStation: Station {
    func users() -> [User] {
        Array(userStorage)
    }
    
    func add(user: User) {
        userStorage.insert(user)
    }
    
    func remove(user: User) {
        userStorage.remove(user)
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case .start(let from, let to):
            let uuid = UUID()
            if !userStorage.contains(from) {
                return nil
            }
            if !userStorage.contains(to) {
                callStorage.insert(Call(id: uuid, incomingUser: from, outgoingUser: to, status: .ended(reason: .error)))
                return uuid
            }
            if currentCall(user: to) != nil {
                callStorage.insert(Call(id: uuid, incomingUser: from, outgoingUser: to, status: .ended(reason: .userBusy)))
                return uuid
            }
            callStorage.insert(Call(id: uuid, incomingUser: from, outgoingUser: to, status: .calling))
            return uuid
        case .answer(let from):
            if let currentCall = currentCall(user: from) {
                if !userStorage.contains(from) {
                    currentCall.status = .ended(reason: .error)
                    return nil
                }
                currentCall.status = .talk
                return currentCall.id
            }
        case .end(let from):
            if let currectCall = currentCall(user: from) {
                if (currectCall.status == .talk) {
                    currectCall.status = .ended(reason: .end)
                }
                if (currectCall.status == .calling) {
                    currectCall.status = .ended(reason: .cancel)
                }
                return currectCall.id
            }
        }
        return nil
    }
    
    func calls() -> [Call] {
        Array(callStorage)
    }
    
    func calls(user: User) -> [Call] {
        Array(callStorage.filter{$0.incomingUser == user || $0.outgoingUser == user})
    }
    
    func call(id: CallID) -> Call? {
        callStorage.first(where: {$0.id == id})
    }
    
    func currentCall(user: User) -> Call? {
        callStorage.first(where: {($0.incomingUser == user || $0.outgoingUser == user) && ($0.status == .calling || $0.status == .talk)})
    }
}
