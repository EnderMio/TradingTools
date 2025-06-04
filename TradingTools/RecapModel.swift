import Foundation
import SwiftUI

class RecapModel: ObservableObject {
    @Published var news: String = ""
    @Published var market: String = ""
    @Published var topic: String = ""
    @Published var holdings: String = ""
    @Published var selection: String = ""
    @Published var plan: String = ""
}
