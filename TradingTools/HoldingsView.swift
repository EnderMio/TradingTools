import SwiftUI

struct HoldingsView: View {
    @Binding var text: String

    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .padding()
                .navigationTitle("持仓")
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.secondarySystemBackground))
                        .padding()
                )
        }
    }
}

#Preview {
    HoldingsView(text: .constant(""))
}
