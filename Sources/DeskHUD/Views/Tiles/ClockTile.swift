import SwiftUI

struct ClockTile: View {
    @EnvironmentObject var clock: ClockModel

    var body: some View {
        ZStack {
            VisualEffectBlur(material: .hudWindow, cornerRadius: 14)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(clock.timeString)
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(clock.dateString)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.85))
                }
                Spacer()
            }
            .padding(14)
        }
        .frame(minWidth: 160, idealHeight: 120, maxHeight: 200)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal, 6)
    }
}