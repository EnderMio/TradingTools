import Foundation
import SwiftUI

class RecapModel: ObservableObject {
    /// Notes about current holdings for reference with trade plans
    @Published var holdings: String = ""
}
