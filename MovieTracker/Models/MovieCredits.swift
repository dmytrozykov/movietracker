import Foundation

struct MovieCredits: Codable {
    let cast: [CastMember]
    let crew: [CrewMemeber]

    /// Get the director from the crew ( O(n) complexity )
    var director: CrewMemeber? {
        // FIXME: Get rid of the magic value by introducing the enum
        crew.first { $0.job == "Director" }
    }
}
