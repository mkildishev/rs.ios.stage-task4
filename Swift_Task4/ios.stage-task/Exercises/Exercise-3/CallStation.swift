import Foundation

final class CallStation {
    var userStorage: Set<User>
    var callStorage: Set<Call> 
    
    init() {
        userStorage = []
        callStorage = []
    }
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
            callStorage.insert(Call(id: uuid, incomingUser: from, outgoingUser: to, status: getStartStatus(user: to)))
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
            if let currentCall = currentCall(user: from) {
                currentCall.status = getEndStatus(currentCall.status)!
                return currentCall.id
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

extension CallStation {
    
    func getStartStatus(user: User) -> CallStatus {
        if !userStorage.contains(user) {
            return .ended(reason: .error)
        }
        if currentCall(user: user) != nil {
            return .ended(reason: .userBusy)
        }
        return .calling
    }
    
    func getEndStatus(_ currentCallStatus : CallStatus) -> CallStatus? {
        if (currentCallStatus == .talk) {
            return .ended(reason: .end)
        }
        if (currentCallStatus == .calling) {
            return .ended(reason: .cancel)
        }
        return nil
    }
        
}
    
