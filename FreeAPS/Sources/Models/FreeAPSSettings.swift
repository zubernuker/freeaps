import Foundation

struct FreeAPSSettings: JSON {
    var units: GlucoseUnits
    var closedLoop: Bool
    var allowAnnouncements: Bool
    var useAutotune: Bool
    var isUploadEnabled: Bool?
    var useLocalGlucoseSource: Bool?
    var localGlucosePort: Int?
    var debugOptions: Bool?
    var insulinReqFraction: Decimal?
}
