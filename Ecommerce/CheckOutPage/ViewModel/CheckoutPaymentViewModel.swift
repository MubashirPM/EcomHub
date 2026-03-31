//
//  CheckoutPaymentViewModel.swift
//  Ecommerce
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class CheckoutPaymentViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    /// Set after create-order succeeds: server total in rupees (tax/shipping included).
    @Published var payableTotalRupees: Int?
    /// Set when `/payment/verify` succeeds; checkout UI listens to present order confirmation.
    @Published var paymentVerificationSucceeded = false

    private let paymentHandler = RazorpayPaymentHandler()

    func startPayment(
        userId: String,
        amount: Int,
        selectedAddressId: String,
        isBuyNow: Bool,
        prefillEmail: String,
        prefillContact: String,
        buyNowProduct: BuyNowProductPayload? = nil
    ) async {
        guard !userId.isEmpty else {
            errorMessage = "Please sign in to continue."
            return
        }
        guard amount > 0 else {
            errorMessage = "Invalid amount."
            return
        }
        let trimmedAddress = selectedAddressId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAddress.isEmpty else {
            errorMessage = "Please select a delivery address before placing your order."
            return
        }
        if isBuyNow {
            guard let buyNowProduct, !buyNowProduct.productId.isEmpty, buyNowProduct.quantity > 0 else {
                errorMessage = "Invalid buy now product. Go back and try again."
                return
            }
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil
        payableTotalRupees = nil
        paymentVerificationSucceeded = false

        do {
            let order = try await createOrder(
                userId: userId,
                buyNowProduct: isBuyNow ? buyNowProduct : nil
            )

            payableTotalRupees = order.payableTotalRupees

            paymentHandler.openCheckout(
                orderId: order.orderId,
                amount: order.amount,
                prefillEmail: prefillEmail,
                prefillContact: prefillContact,
                onSuccess: { [weak self] payload in
                    guard let self else { return }
                    Task { @MainActor in
                        await self.verifyPayment(
                            payload: payload,
                            userId: userId,
                            selectedAddressId: trimmedAddress,
                            isBuyNow: isBuyNow,
                            buyNowProduct: buyNowProduct
                        )
                    }
                },
                onFailure: { [weak self] message in
                    guard let self else { return }
                    Task { @MainActor in
                        self.errorMessage = message
                        self.isLoading = false
                    }
                }
            )
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func createOrder(
        userId: String,
        buyNowProduct: BuyNowProductPayload?
    ) async throws -> CreateOrderResponse {
        guard let url = URL(string: AppConfig.baseURL + EndPoints.createPaymentOrder) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid create-order URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let orderBody: CreateOrderRequest
        if let buyNowProduct {
            orderBody = CreateOrderRequest(userId: userId, buyNowProduct: buyNowProduct)
        } else {
            orderBody = CreateOrderRequest(userId: userId)
        }
        request.httpBody = try JSONEncoder().encode(orderBody)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from create-order"])
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            let detail = Self.messageFromVerifyResponse(data: data, statusCode: httpResponse.statusCode)
            throw NSError(domain: "CreateOrder", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: detail])
        }

        let decoder = JSONDecoder()
        return try decoder.decode(CreateOrderResponse.self, from: data)
    }

    private func verifyPayment(
        payload: RazorpaySuccessPayload,
        userId: String,
        selectedAddressId: String,
        isBuyNow: Bool,
        buyNowProduct: BuyNowProductPayload?
    ) async {
        do {
            guard !payload.razorpayPaymentId.isEmpty else {
                throw NSError(
                    domain: "PaymentVerify",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Missing payment id from Razorpay. Update the app or try again."]
                )
            }
            guard !payload.razorpayOrderId.isEmpty, !payload.razorpaySignature.isEmpty else {
                throw NSError(
                    domain: "PaymentVerify",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Missing order id or signature from Razorpay. Ensure checkout uses a server-created order_id."]
                )
            }

            guard let url = URL(string: AppConfig.baseURL + EndPoints.verifyPayment) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid verify URL"])
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            var body: [String: Any] = [
                "razorpay_payment_id": payload.razorpayPaymentId,
                "razorpay_order_id": payload.razorpayOrderId,
                "razorpay_signature": payload.razorpaySignature,
                "userId": userId,
                "selectedAddressId": selectedAddressId,
                "isBuyNow": isBuyNow
            ]
            if let buyNowProduct {
                body["buyNowProduct"] = [
                    "productId": buyNowProduct.productId,
                    "quantity": buyNowProduct.quantity
                ]
            }

            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response from verify"])
            }

            if (200...299).contains(httpResponse.statusCode) {
                let verifyResponse = try? JSONDecoder().decode(VerifyPaymentResponse.self, from: data)
                successMessage = verifyResponse?.message ?? "Payment successful."
                paymentVerificationSucceeded = true
            } else {
                let detail = Self.messageFromVerifyResponse(data: data, statusCode: httpResponse.statusCode)
                throw NSError(domain: "PaymentVerify", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: detail])
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private static func messageFromVerifyResponse(data: Data, statusCode: Int) -> String {
        if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let msg = obj["message"] as? String, !msg.isEmpty { return msg }
            if let err = obj["error"] as? String, !err.isEmpty { return err }
            if let desc = obj["description"] as? String, !desc.isEmpty { return desc }
            if let nested = obj["error"] as? [String: Any] {
                if let desc = nested["description"] as? String, !desc.isEmpty { return desc }
                if let code = nested["code"] as? String, !code.isEmpty { return code }
            }
        }
        if let text = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
            return text
        }
        return "Payment verification failed (HTTP \(statusCode))."
    }
}
