////
////  SwiftUIView.swift
////  SuitUp
////
////  Created by 이지원 on 2022/07/20.
//
//import SwiftUI
//import AuthenticationServices
//import FirebaseAuth
//
//// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
//private func randomNonceString(length: Int = 32) -> String {
//  precondition(length > 0)
//  let charset: [Character] =
//    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//  var result = ""
//  var remainingLength = length
//
//  while remainingLength > 0 {
//    let randoms: [UInt8] = (0 ..< 16).map { _ in
//      var random: UInt8 = 0
//      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//      if errorCode != errSecSuccess {
//        fatalError(
//          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
//        )
//      }
//      return random
//    }
//
//    randoms.forEach { random in
//      if remainingLength == 0 {
//        return
//      }
//
//      if random < charset.count {
//        result.append(charset[Int(random)])
//        remainingLength -= 1
//      }
//    }
//  }
//
//  return result
//}
//
//    
//@available(iOS 13, *)
//private func sha256(_ input: String) -> String {
//  let inputData = Data(input.utf8)
//  let hashedData = SHA256.hash(data: inputData)
//  let hashString = hashedData.compactMap {
//    String(format: "%02x", $0)
//  }.joined()
//
//  return hashString
//}
//
//import CryptoKit
//
//// Unhashed nonce.
//fileprivate var currentNonce: String?
//
//@available(iOS 13, *)
//func startSignInWithAppleFlow() {
//  let nonce = randomNonceString()
//  currentNonce = nonce
//  let appleIDProvider = ASAuthorizationAppleIDProvider()
//  let request = appleIDProvider.createRequest()
//  request.requestedScopes = [.fullName, .email]
//  request.nonce = sha256(nonce)
//
//  let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//  authorizationController.delegate = self
//  authorizationController.presentationContextProvider = self
//  authorizationController.performRequests()
//}
//
//@available(iOS 13.0, *)
//extension MainViewController: ASAuthorizationControllerDelegate {
//
//  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//      guard let nonce = currentNonce else {
//        fatalError("Invalid state: A login callback was received, but no login request was sent.")
//      }
//      guard let appleIDToken = appleIDCredential.identityToken else {
//        print("Unable to fetch identity token")
//        return
//      }
//      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//        return
//      }
//      // Initialize a Firebase credential.
//      let credential = OAuthProvider.credential(withProviderID: "apple.com",
//                                                IDToken: idTokenString,
//                                                rawNonce: nonce)
//      // Sign in with Firebase.
//      Auth.auth().signIn(with: credential) { (authResult, error) in
//        if error {
//          // Error. If error.code == .MissingOrInvalidNonce, make sure
//          // you're sending the SHA256-hashed nonce as a hex string with
//          // your request to Apple.
//          print(error.localizedDescription)
//          return
//        }
//        // User is signed in to Firebase with Apple.
//        // ...
//      }
//    }
//  }
//
//  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//    // Handle error.
//    print("Sign in with Apple errored: \(error)")
//  }
//
//}
//
//// Initialize a fresh Apple credential with Firebase.
//let credential = OAuthProvider.credential(
//  withProviderID: "apple.com",
//  IDToken: appleIdToken,
//  rawNonce: rawNonce
//)
//// Reauthenticate current Apple user with fresh Apple credential.
//Auth.auth().currentUser.reauthenticate(with: credential) { (authResult, error) in
//  guard error != nil else { return }
//  // Apple user successfully re-authenticated.
//  // ...
//}
