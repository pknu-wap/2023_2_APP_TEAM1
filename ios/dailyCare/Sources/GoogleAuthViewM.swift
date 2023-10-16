import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import Combine

class GoogleAuthM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    @Published var isLoggedIn : Bool = false
    
    lazy var loginStatusInfo : AnyPublisher<String?, Never> =
    $isLoggedIn.compactMap{ $0 ? "로그인 상태" : "로그아웃 상태"}.eraseToAnyPublisher()
    

    func GoogleSignIn(withPresenting presentingViewController: UIViewController){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        print("hello1")
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [unowned self] result, error in
            guard error == nil else {
                print("An error occurred: \(String(describing: error))")
                return // Error occurred, just exit the guard block
            }
            
            print("hello2")
            guard let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                // Handle the case where user or idToken is nil
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [self] (authResult, error) in
                    if let error = error {
                        print("Firebase Sign-In Error: \(error.localizedDescription)")
                        return
                }
                // Firebase 사용자 인증 성공
                isLoggedIn = true // Set the login state to true
            }
        }
    }
}
