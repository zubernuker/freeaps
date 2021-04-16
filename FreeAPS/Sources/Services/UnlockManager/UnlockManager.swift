import Combine
import LocalAuthentication

protocol UnlockManager {
    func unlock() -> AnyPublisher<Void, Error>
}

struct UnlockError: Error {
    let error: Error?
}

final class BaseUnlockManager: UnlockManager {
    func unlock() -> AnyPublisher<Void, Error> {
        Future { promise in
            let context = LAContext()
            var error: NSError?

            let handler: (Bool, Error?) -> Void = { success, error in
                if success {
                    promise(.success(()))
                } else {
                    promise(.failure(UnlockError(error: error)))
                }
            }

            let reason = "We need to make sure you are the owner of the device."

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason,
                    reply: handler
                )
            } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                context.evaluatePolicy(
                    .deviceOwnerAuthentication,
                    localizedReason: reason,
                    reply: handler
                )
            } else {
                promise(.failure(UnlockError(error: error)))
            }
        }
        .eraseToAnyPublisher()
    }
}
