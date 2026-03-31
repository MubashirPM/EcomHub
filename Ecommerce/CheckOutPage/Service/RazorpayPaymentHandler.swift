//
//  RazorpayPaymentHandler.swift
//  Ecommerce
//

import Foundation
import UIKit

#if canImport(Razorpay)
import Razorpay
#endif

final class RazorpayPaymentHandler: NSObject {

    private let keyId = "rzp_test_TARR8c9vhmCeNc"
    private var successCallback: ((RazorpaySuccessPayload) -> Void)?
    private var failureCallback: ((String) -> Void)?

    #if canImport(Razorpay)
    /// SDK callbacks require a strong reference; a local `let checkout` is released when `openCheckout` returns.
    private var checkoutRetain: RazorpayCheckout?
    /// Razorpay may call success/error more than once; only the first terminal callback should run.
    private var didDeliverCheckoutResult = false
    #endif

    func openCheckout(
        orderId: String,
        amount: Int,
        prefillEmail: String,
        prefillContact: String,
        onSuccess: @escaping (RazorpaySuccessPayload) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        self.successCallback = onSuccess
        self.failureCallback = onFailure

        #if canImport(Razorpay)
        didDeliverCheckoutResult = false
        guard let topController = UIApplication.topViewController() else {
            onFailure("Unable to open checkout screen.")
            return
        }

        let checkout = RazorpayCheckout.initWithKey(keyId, andDelegateWithData: self)
        checkoutRetain = checkout
        var options: [String: Any] = [
            "key": keyId,
            "name": "Ecommerce",
            "description": "Order Payment",
            "order_id": orderId,
            "amount": amount,
            "currency": "INR"
        ]
        options["prefill"] = [
            "email": prefillEmail,
            "contact": prefillContact
        ]

        checkout.open(options, displayController: topController)
        Self.applyFullScreenToRazorpayIfPresented(from: topController)
        #else
        onFailure("Razorpay SDK is not installed. Add Razorpay iOS SDK first.")
        #endif
    }

    #if canImport(Razorpay)
    /// Razorpay often defaults to a page sheet; nudge the presented checkout to full screen when the SDK allows it.
    private static func applyFullScreenToRazorpayIfPresented(from anchor: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            var top = anchor
            while let presented = top.presentedViewController {
                presented.modalPresentationStyle = .fullScreen
                top = presented
            }
        }
    }
    #endif
}

#if canImport(Razorpay)
extension RazorpayPaymentHandler: RazorpayPaymentCompletionProtocolWithData {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable: Any]?) {
        let message = str.isEmpty ? "Payment failed. Please try again." : str
        let onFail = failureCallback
        finalizeCheckoutOnce {
            onFail?(message)
        }
    }

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable: Any]?) {
        let paymentId = Self.coalesceString(payment_id) ?? ""
        let orderId = Self.string(from: response, candidates: [
            "razorpay_order_id",
            "razorpayOrderId"
        ])
        let signature = Self.string(from: response, candidates: [
            "razorpay_signature",
            "razorpaySignature"
        ])
        let payload = RazorpaySuccessPayload(
            razorpayPaymentId: paymentId,
            razorpayOrderId: orderId,
            razorpaySignature: signature
        )
        let onSuccess = successCallback
        finalizeCheckoutOnce {
            onSuccess?(payload)
        }
    }

    /// Ignores duplicate SDK callbacks; clears stored closures after scheduling the first result.
    private func finalizeCheckoutOnce(_ deliver: @escaping () -> Void) {
        guard !didDeliverCheckoutResult else { return }
        didDeliverCheckoutResult = true
        checkoutRetain = nil
        successCallback = nil
        failureCallback = nil
        DispatchQueue.main.async(execute: deliver)
    }

    /// Razorpay passes `[AnyHashable: Any]` from Objective-C; subscripting with `String` alone often misses keys.
    private static func string(from response: [AnyHashable: Any]?, candidates: [String]) -> String {
        guard let response else { return "" }
        let wanted = Set(candidates.map { $0.lowercased() })
        for (rawKey, value) in response {
            let key = String(describing: rawKey)
            guard wanted.contains(key.lowercased()) else { continue }
            if let s = coalesceString(value), !s.isEmpty { return s }
        }
        for name in candidates {
            if let s = coalesceString(response[name]), !s.isEmpty { return s }
            if let s = coalesceString(response[name as NSString]), !s.isEmpty { return s }
        }
        return ""
    }

    private static func coalesceString(_ value: Any?) -> String? {
        guard let value else { return nil }
        if let s = value as? String { return s }
        if let s = value as? NSString { return s as String }
        if let n = value as? NSNumber { return n.stringValue }
        let t = String(describing: value)
        return t.isEmpty ? nil : t
    }

    private static func coalesceString(_ value: String) -> String? {
        value.isEmpty ? nil : value
    }
}
#endif

private extension UIApplication {
    static func topViewController(
        base: UIViewController? = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
