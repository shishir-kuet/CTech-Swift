import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        .init(image: "cart", title: "Shop smarter", subtitle: "Browse the latest PC components and accessories with one tap."),
        .init(image: "creditcard", title: "Secure checkout", subtitle: "Choose local payment methods and complete orders with confidence."),
        .init(image: "chart.bar", title: "Order tracking", subtitle: "Track your order status and manage your purchases from one dashboard.")
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 24) {
                        Image(systemName: pages[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))

                        Text(pages[index].title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)

                        Text(pages[index].subtitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 360)

            Spacer()

            Button(action: advance) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal)

            Button("Skip onboarding") {
                hasSeenOnboarding = true
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.bottom)
        }
        .padding()
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        } else {
            hasSeenOnboarding = true
        }
    }
}

private struct OnboardingPage {
    let image: String
    let title: String
    let subtitle: String
}
