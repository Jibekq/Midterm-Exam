//
//  CaptchaWebView.swift
//  deemo
//
//  Created by Zhibek Nasipbekova on 12.03.2025.
//

import SwiftUI
import WebKit

struct CaptchaWebView: UIViewRepresentable {
    var captchaURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: captchaURL))
    }

    func makeCoordinator() -> CaptchaWebViewCoordinator {
        return CaptchaWebViewCoordinator(self)
    }

    class CaptchaWebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: CaptchaWebView

        init(_ parent: CaptchaWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Captcha loaded successfully.")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Captcha load failed: \(error.localizedDescription)")
        }
    }
}

