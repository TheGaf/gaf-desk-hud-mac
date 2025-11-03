import SwiftUI

struct PlaceholderTile: View {
    let title: String
    let subtitle: String

    var body: some View {
        ZStack {
            VisualEffectBlur(material: .hudWindow, cornerRadius: 14)

            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.45))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Text(String(title.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.85))
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding(12)
        }
        .frame(minWidth: 220, idealHeight: 100, maxHeight: 140)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal, 6)
    }
}