import Foundation

struct TempTarget: JSON, Identifiable, Equatable {
    var id = UUID().uuidString
    let name: String?
    var createdAt: Date
    let targetTop: Decimal?
    let targetBottom: Decimal?
    let duration: Decimal
    let enteredBy: String?
    let reason: String?

    static let manual = "freeaps-x"
    static let custom = "Temp target"
    static let cancel = "Cancel"

    var displayName: String {
        name ?? reason ?? TempTarget.custom
    }
}

extension TempTarget {
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case createdAt = "created_at"
        case targetTop
        case targetBottom
        case duration
        case enteredBy
        case reason
    }
}
