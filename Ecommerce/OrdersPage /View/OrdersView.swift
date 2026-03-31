//
//  OrdersView.swift
//  Ecommerce
//

import SwiftUI

struct OrdersView: View {

    @AppStorage("userId") private var userId: String = ""
    @StateObject private var viewModel = OrdersViewModel()

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
            } else if viewModel.isLoading && viewModel.orders.isEmpty {
                ProgressView()
            } else if let message = viewModel.errorMessage, viewModel.orders.isEmpty {
                VStack(spacing: 12) {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button(OrderCopy.retry) {
                        Task { await viewModel.fetchOrders(userId: userId, reset: true) }
                    }
                }
                .padding()
            } else if viewModel.orders.isEmpty {
                Text(OrderCopy.emptyOrders)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if let banner = viewModel.errorMessage, !viewModel.orders.isEmpty {
                            Text(banner)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ForEach(viewModel.orders) { order in
                            NavigationLink {
                                OrderDetailView(orderId: order.id)
                            } label: {
                                OrderCard(
                                    status: order.displayStatusLabel(),
                                    orderId: orderNumberLabel(order.id),
                                    details: order.summaryLineItemText(),
                                    price: order.displayTotalFormatted()
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        if viewModel.pagination?.hasNextPage == true {
                            Button {
                                Task { await viewModel.loadMore(userId: userId) }
                            } label: {
                                HStack {
                                    Spacer()
                                    if viewModel.isLoadingMore {
                                        ProgressView()
                                    } else {
                                        Text(OrderCopy.loadMore)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                            }
                            .disabled(viewModel.isLoadingMore)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: userId) {
            await viewModel.fetchOrders(userId: userId, reset: true)
        }
    }

    private func orderNumberLabel(_ id: String) -> String {
        let tail = id.count > 6 ? String(id.suffix(6)) : id
        return "#\(tail)"
    }
}

struct OrderCard: View {

    var status: String
    var orderId: String
    var details: String
    var price: String
    var buttonText: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(status)
                .font(.subheadline)
                .foregroundStyle(.gray)

            Text("Order \(orderId)")
                .font(.headline)
                .fontWeight(.bold)

            Text("\(details) · \(price)")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .fixedSize(horizontal: false, vertical: true)

            if let buttonText {
                Button {
                    // Reserved for track / reorder flows
                } label: {
                    Text(buttonText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray4))
                        .cornerRadius(20)
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        OrdersView()
    }
}
