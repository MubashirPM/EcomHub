//
//  OrderDetailView.swift
//  Ecommerce
//

import SwiftUI

struct OrderDetailView: View {

    let orderId: String

    @AppStorage("userId") private var userId: String = ""
    @State private var order: UserOrder?
    @State private var loadError: String?
    @State private var isLoading = true
    @State private var showCancelConfirmation = false
    @State private var showReturnConfirmation = false
    @State private var mutationInFlight = false
    @State private var mutationError: String?

    private static let timelineDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            if userId.isEmpty {
                Text(OrderCopy.signInHint)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if isLoading {
                ProgressView()
            } else if let loadError {
                VStack(spacing: 12) {
                    Text(loadError)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button(OrderCopy.retry) {
                        Task { await loadDetail() }
                    }
                }
                .padding()
            } else if let order {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection(order)

                        if let mutationError {
                            Text(mutationError)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        actionButtonsSection(order)

                        if let steps = order.statusTimeline, !steps.isEmpty {
                            timelineSection(steps)
                        }
                        itemsSection(order)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationTitle(OrderCopy.detailNavTitle)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            OrderCopy.cancelConfirmTitle,
            isPresented: $showCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button(OrderCopy.confirmAction, role: .destructive) {
                Task { await performCancelOrder() }
            }
            Button(OrderCopy.dismissAction, role: .cancel) {}
        } message: {
            Text(OrderCopy.cancelConfirmMessage)
        }
        .confirmationDialog(
            OrderCopy.returnConfirmTitle,
            isPresented: $showReturnConfirmation,
            titleVisibility: .visible
        ) {
            Button(OrderCopy.confirmAction) {
                Task { await performReturnRequest() }
            }
            Button(OrderCopy.dismissAction, role: .cancel) {}
        } message: {
            Text(OrderCopy.returnConfirmMessage)
        }
        .task {
            await loadDetail()
        }
    }

    @MainActor
    private func loadDetail() async {
        guard !userId.isEmpty else {
            isLoading = false
            loadError = nil
            order = nil
            return
        }
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        do {
            order = try await OrderDetailLoader.fetch(userId: userId, orderId: orderId)
        } catch {
            order = nil
            loadError = (error as? LocalizedError)?.errorDescription ?? OrderCopy.loadFailed
        }
    }

    @ViewBuilder
    private func headerSection(_ order: UserOrder) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(order.displayStatusLabel())
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(order.formattedOrderDate ?? shortDate(order.orderDate))
                .font(.headline)

            if let updated = order.formattedUpdatedAt {
                Text("Updated \(updated)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(order.displayTotalFormatted())
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func actionButtonsSection(_ order: UserOrder) -> some View {
        let showCancel = OrderStatusPolicy.canCancel(forStatus: order.status)
        let showReturn = OrderStatusPolicy.canRequestReturn(forStatus: order.status)

        if showCancel || showReturn {
            VStack(alignment: .leading, spacing: 12) {
                Text(OrderCopy.sectionActions)
                    .font(.headline)

                if mutationInFlight {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }

                VStack(spacing: 12) {
                    if showCancel {
                        Button {
                            showCancelConfirmation = true
                        } label: {
                            primaryOrderActionLabel(
                                title: OrderCopy.cancelOrder,
                                systemImage: "xmark.circle.fill"
                            )
                        }
                        .disabled(mutationInFlight)
                    }

                    if showReturn {
                        Button {
                            showReturnConfirmation = true
                        } label: {
                            primaryOrderActionLabel(
                                title: OrderCopy.requestReturn,
                                systemImage: "arrow.uturn.backward.circle.fill"
                            )
                        }
                        .disabled(mutationInFlight)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func primaryOrderActionLabel(title: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.headline)
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.custom)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    @MainActor
    private func performCancelOrder() async {
        guard !userId.isEmpty else { return }
        mutationInFlight = true
        mutationError = nil
        defer { mutationInFlight = false }
        do {
            _ = try await OrderActionService.cancelOrder(userId: userId, orderId: orderId)
            await loadDetail()
        } catch {
            mutationError = (error as? LocalizedError)?.errorDescription ?? OrderCopy.mutationFailed
        }
    }

    @MainActor
    private func performReturnRequest() async {
        guard !userId.isEmpty else { return }
        mutationInFlight = true
        mutationError = nil
        defer { mutationInFlight = false }
        do {
            _ = try await OrderActionService.requestReturn(userId: userId, orderId: orderId)
            await loadDetail()
        } catch {
            mutationError = (error as? LocalizedError)?.errorDescription ?? OrderCopy.mutationFailed
        }
    }

    private func shortDate(_ date: Date?) -> String {
        guard let date else { return "—" }
        return Self.timelineDateFormatter.string(from: date)
    }

    @ViewBuilder
    private func timelineSection(_ steps: [OrderStatusTimelineStep]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(OrderCopy.sectionTimeline)
                .font(.headline)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(steps.enumerated()), id: \.offset) { _, step in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: (step.completed ?? false) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle((step.completed ?? false) ? Color.custom : .secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.status)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            if let date = step.date {
                                Text(Self.timelineDateFormatter.string(from: date))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func itemsSection(_ order: UserOrder) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(OrderCopy.sectionItems)
                .font(.headline)

            let lines = order.items ?? []
            if lines.isEmpty {
                Text(OrderCopy.summaryEmpty)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    orderLineRow(line)
                }
            }
        }
    }

    private func orderLineRow(_ line: UserOrderLineItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            let name = line.imageFilenames.first ?? ""
            let url = name.isEmpty ? nil : URL(string: AppConfig.imageBaseURL + name)
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Color(.systemGray5)
                @unknown default:
                    Color(.systemGray5)
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(line.resolvedProductName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if let category = line.productId?.category?.categoryName, !category.isEmpty {
                    Text(category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    if let qty = line.quantity {
                        Text("Qty \(qty)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(lineTotalFormatted(line))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private func lineTotalFormatted(_ line: UserOrderLineItem) -> String {
        let unit = line.resolvedUnitPrice
        let qty = Double(line.quantity ?? 0)
        let total = unit * qty
        guard total > 0 else { return "—" }
        return UserOrder.formatINR(total)
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(orderId: "preview")
    }
}
