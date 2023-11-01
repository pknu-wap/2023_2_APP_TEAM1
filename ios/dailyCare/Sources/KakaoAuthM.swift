//
//  KakaoAuthViewM.swift
//  kakaologinUIkit
//
//  Created by 서성원 on 2023/10/02.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import Firebase
import FirebaseAuth

class KakaoAuthM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()

    @Published var isLoggedIn : Bool = false
    @Published var userEmail: String? = nil
    
    lazy var loginStatusInfo : AnyPublisher<String?, Never> =
    $isLoggedIn.compactMap{ $0 ? "로그인 상태" : "로그아웃 상태"}.eraseToAnyPublisher()
    
    init() {
        print("kakaoAuthVM - init() called")
    }
    
    // 카카오톡 앱으로 로그인 인증
    func kakaoLoginwithApp() async -> Bool{
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    _ = oauthToken
                    UserApi.shared.me { kuser, error in
                        if let error = error {
                            print("------KAKAO : user loading failed------")
                            print(error)
                        } else {
                            if let email = kuser?.kakaoAccount?.email {
                                DispatchQueue.main.async {
                                    self.userEmail = email // userEmail 업데이트
                                }
                                Auth.auth().createUser(withEmail: email, password: "\(String(describing: kuser?.id))") { fuser, error in
                                    if let error = error {
                                        print("FB : signup failed")
                                        print(error)
                                        Auth.auth().signIn(withEmail: email, password: "\(String(describing: kuser?.id))", completion: nil)
                                    } else {
                                        print("FB : signup success")
                                    }
                                }


                            } else {
                                // email이 nil일 경우에 대한 처리
                                print("Kakao user email is nil.")
                            }
                        }
                    }
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // 카카오 계정으로 로그인
    func kakaoLoginWithAccount() async -> Bool{
        
        await withCheckedContinuation{ continuation in
            
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    //do something
                    _ = oauthToken
                    // 로그인 성공 시
                    UserApi.shared.me { kuser, error in
                        if let error = error {
                            print("------KAKAO : user loading failed------")
                            print(error)
                        } else {
                            if let email = kuser?.kakaoAccount?.email {
                                DispatchQueue.main.async {
                                    self.userEmail = email // userEmail 업데이트
                                    print("User email is: \(self.userEmail ?? "N/A")")
                                }
                                Auth.auth().createUser(withEmail: email, password: "\(String(describing: kuser?.id))") { fuser, error in
                                    if let error = error {
                                        print("FB : signup failed")
                                        print(error)
                                        Auth.auth().signIn(withEmail: email, password: "\(String(describing: kuser?.id))", completion: nil)
                                    } else {
                                        print("FB : signup success")
                                    }
                                }
                            } else {
                                // email이 nil일 경우에 대한 처리
                                print("Kakao user email is nil.")
                            }
                        }
                        continuation.resume(returning: true)
                    }
                }
            }
        }
    }
    
    @MainActor
    func KakaoLogin() {
        print("KakaoAuthM - handleKakaoLogin() called")
        
        Task{
            // 카카오톡 설치 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오톡 앱으로 로그인 인증
                isLoggedIn = await kakaoLoginwithApp()
            } else { // 카톡 설치 안되어 있으면
                // 카카오 계정으로 로그인
                isLoggedIn = await kakaoLoginWithAccount()
            }
        } // log in
        
    }
    
    @MainActor
    func kakaoLogout(){
        Task {
            if await kakaoLogout() {
                self.isLoggedIn = false
            }
        }
    }
    
    func kakaoLogout() async -> Bool{
        await withCheckedContinuation{ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
}
