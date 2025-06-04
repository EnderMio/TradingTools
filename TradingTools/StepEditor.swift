import SwiftUI

struct StepEditor: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .padding()
                .navigationTitle(title)
        }
    }
}

struct StepEditor_Previews: PreviewProvider {
    static var previews: some View {
        StepEditor(title: "示例", text: .constant(""))
    }
}
