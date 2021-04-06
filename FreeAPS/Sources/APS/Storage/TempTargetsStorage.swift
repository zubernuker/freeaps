import Foundation
import SwiftDate
import Swinject

protocol TempTargetsObserver {
    func tempTargetsDidUpdate(_ targers: [TempTarget])
}

protocol TempTargetsStorage {
    func storeTempTargets(_ targets: [TempTarget])
    func syncDate() -> Date
    func recent() -> [TempTarget]
    func nightscoutTretmentsNotUploaded() -> [NigtscoutTreatment]
    func storePresets(_ targets: [TempTarget])
    func presets() -> [TempTarget]
    func current() -> TempTarget?
}

final class BaseTempTargetsStorage: TempTargetsStorage, Injectable {
    private let processQueue = DispatchQueue(label: "BaseTempTargetsStorage.processQueue")
    @Injected() private var storage: FileStorage!
    @Injected() private var broadcaster: Broadcaster!

    init(resolver: Resolver) {
        injectServices(resolver)
    }

    func storeTempTargets(_ targets: [TempTarget]) {
        storeTempTargets(targets, isPresets: false)
    }

    private func storeTempTargets(_ targets: [TempTarget], isPresets: Bool) {
        processQueue.sync {
            let file = isPresets ? OpenAPS.FreeAPS.tempTargetsPresets : OpenAPS.Settings.tempTargets
            var uniqEvents: [TempTarget] = []
            self.storage.transaction { storage in
                storage.append(targets, to: file, uniqBy: \.createdAt)
                uniqEvents = storage.retrieve(file, as: [TempTarget].self)?
                    .filter {
                        guard !isPresets else { return true }
                        return $0.createdAt.addingTimeInterval(1.days.timeInterval) > Date()
                    }
                    .sorted { $0.createdAt > $1.createdAt } ?? []
                storage.save(Array(uniqEvents), as: file)
            }
            broadcaster.notify(TempTargetsObserver.self, on: processQueue) {
                $0.tempTargetsDidUpdate(uniqEvents)
            }
        }
    }

    func syncDate() -> Date {
        guard let events = storage.retrieve(OpenAPS.Settings.tempTargets, as: [TempTarget].self),
              let recent = events.filter({ !($0.enteredBy?.contains(TempTarget.manual) ?? false) }).first
        else {
            return Date().addingTimeInterval(-1.days.timeInterval)
        }
        return recent.createdAt
    }

    func recent() -> [TempTarget] {
        storage.retrieve(OpenAPS.Settings.tempTargets, as: [TempTarget].self)?.reversed() ?? []
    }

    func current() -> TempTarget? {
        guard let last = recent().last else {
            return nil
        }
        guard last.createdAt.addingTimeInterval(Int(last.duration).minutes.timeInterval) > Date() else {
            return nil
        }
        return last
    }

    func nightscoutTretmentsNotUploaded() -> [NigtscoutTreatment] {
        let uploaded = storage.retrieve(OpenAPS.Nightscout.uploadedTempTargets, as: [NigtscoutTreatment].self) ?? []

        let eventsManual = recent().filter { $0.enteredBy == TempTarget.manual }
        let treatments = eventsManual.map {
            NigtscoutTreatment(
                duration: Int($0.duration),
                rawDuration: nil,
                rawRate: nil,
                absolute: nil,
                rate: nil,
                eventType: .nsTempTarget,
                createdAt: $0.createdAt,
                enteredBy: TempTarget.manual,
                bolus: nil,
                insulin: nil,
                notes: nil,
                carbs: nil,
                targetTop: $0.targetTop,
                targetBottom: $0.targetBottom
            )
        }
        return Array(Set(treatments).subtracting(Set(uploaded)))
    }

    func storePresets(_ targets: [TempTarget]) {
        storage.remove(OpenAPS.FreeAPS.tempTargetsPresets)

        storeTempTargets(targets, isPresets: true)
    }

    func presets() -> [TempTarget] {
        storage.retrieve(OpenAPS.FreeAPS.tempTargetsPresets, as: [TempTarget].self)?.reversed() ?? []
    }
}
