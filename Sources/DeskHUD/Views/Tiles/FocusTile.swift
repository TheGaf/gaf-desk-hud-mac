import SwiftUI

struct FocusTile: View {
    @EnvironmentObject var focusModel: FocusModel

    var body: some View {
        ZStack {
            VisualEffectBlur(material: .hudWindow, cornerRadius: 14)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Today Focus")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: { focusModel.addTask() }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(focusModel.tasks.count >= 3)
                }

                ForEach(focusModel.tasks.indices, id: \.self) { idx in
                    HStack {
                        TextField("Task", text: Binding(
                            get: { focusModel.tasks[idx] },
                            set: { focusModel.tasks[idx] = $0 }
                        ))
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .lineLimit(2)

                        if focusModel.tasks.count > 1 {
                            Button(action: { focusModel.removeTask(at: idx) }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red.opacity(0.85))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("Remove task")
                        }
                    }
                }

                Spacer()
            }
            .padding(12)
        }
        .frame(minWidth: 360, idealHeight: 140, maxHeight: 220)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal, 6)
    }
}