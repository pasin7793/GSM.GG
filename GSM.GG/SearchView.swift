//
//  SearchView.swift
//  GSM.GG
//
//  Created by GSM06 on 2021/09/14.
//

import UIKit
import SnapKit
import Then
import Alamofire

struct userModel: Codable{
    let id: String
    let name: String
    let profileIconId: Int
    let summonerLevel: Int
}
struct leagueModel: Codable{
    let tier: String
    let rank: Int
    let leaguePoint: Int
    let wins: Int
    let loses: Int
}

struct userProfileModel: Codable{
    let id: String
    let name: String
    let profileIconId: Int
    let summonerLevel: Int
    let tier: String
    let rank: Int
    let leaguePoint: Int
    let wins: Int
    let loses: Int
}
class SearchView: UIViewController, UITextFieldDelegate{
    override func viewDidLoad() {
        
        func getId(nickname: String, completion: @escaping(userProfileModel) -> Void) {
            let url = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/\(nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)?api_key=\(ProcessInfo.processInfo.environment["API"]!)"
            print(nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                AF.request(
                    
                    "\(url)",
                           method: .get,
                           parameters: nil,
                    encoding: URLEncoding.default,
                    headers: ["Content-Type":"application/json", "Accept":"application/json"])
                    .validate(statusCode: 200..<500)
                    .responseJSON { j in
                        
                        let json = try? JSONDecoder().decode(userModel.self, from: j.data!)
                        guard let json = json else { return }
                        print(json)
                        let url = "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/\(json.id)?api_key=\(ProcessInfo.processInfo.environment["API"]!)"
                        AF.request(url,
                                   method: .get,
                                   parameters: nil,
                                   encoding: URLEncoding.default,
                                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
                            .validate(statusCode: 200..<500)
                            .responseJSON { j1 in
                                switch j1.result {
                                case .success(let data):
                                    print(data)
                                    let json1 = try? JSONDecoder().decode(leagueModel.self, from: data as! Data)
                                    guard let json1 = json1 else { return }
                                    let userProfile = userProfileModel(id: json.id, name: json.name, profileIconId: json.profileIconId, summonerLevel: json.summonerLevel, tier: json1.tier, rank: json1.rank, leaguePoint: json1.leaguePoint, wins: json1.wins, loses: json1.loses)
                                    print(userProfile)
                                    completion(userProfile)
                                case .failure(let err):
                                    print(err.localizedDescription)
                        }
                    }
                }
            }
        getId(nickname: "FFF급 고철 포탑") { s in
            print(s)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 189, alpha: 1).cgColor,
            UIColor(red: 0, green: 255, blue: 36, alpha: 100).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 1)
        self.view.backgroundColor = .white
        let logo = UILabel()
        let bound = UIScreen.main.bounds
        logo.text = "GSM.GG"
        logo.font = UIFont(name: "SFMono-Heavy", size: 48)
        logo.textColor = #colorLiteral(red: 0.2640570104, green: 0.4860324264, blue: 0.8808010817, alpha: 1)
        self.view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bound.height*0.2)
            make.height.equalTo(bound.height*0.1)
        }
        let searchText = UITextField()
        searchText.backgroundColor = #colorLiteral(red: 0.9384269118, green: 0.9317232966, blue: 0.9435605407, alpha: 1)
        searchText.textColor = .black
        searchText.attributedPlaceholder = NSAttributedString(string: "소환사 이름 검색!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        searchText.borderStyle = .none
        searchText.layer.cornerRadius = 5
        searchText.clearButtonMode = .whileEditing
        
        searchText.setLeftPaddingPoints(20)
        //searchText.setRightPaddingPoints(40)
        view.addSubview(searchText)
        searchText.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(bound.height*0.03)
            make.centerX.equalToSuperview()
            make.width.equalTo(bound.width*0.8)
            make.top.equalTo(bound.height*0.3)
            make.height.equalTo(bound.height*0.06)
        }
        let enterBtn = UIButton()
        enterBtn.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.8509803922, alpha: 1)
        enterBtn.layer.cornerRadius = 10
        self.view.addSubview(enterBtn)
        enterBtn.setTitle("검색", for: .normal)
        enterBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        enterBtn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 17)
        enterBtn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        enterBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(bound.width*0.33)
            make.height.equalTo(bound.height*0.04)
            make.top.equalTo(bound.height*0.43)
        }
        
    }
    @objc func buttonClicked(_ button: UIButton){
        print("button clicked")
        UIView.animate(withDuration: 1.5) {
            button.backgroundColor = .gray
        };
        UIView.animate(withDuration: 1.5) {
            button.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.8509803922, alpha: 1)
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
    func addleftimage(image:UIImage) {
            let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            leftimage.image = image
            self.leftView = leftimage
            self.leftViewMode = .always
        }
}
