//
//  TenkiInfoViewController.swift
//  Swift5WeatherForecast
//
//  Created by 石塚直樹 on 2020/11/15.
//  Copyright © 2020 Naoki Ishizuka. All rights reserved.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseFirestore
import Alamofire
import SwiftyJSON

class TenkiInfoViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempratureLabel: UILabel!
    
    @IBOutlet weak var tenkiImage1: UIImageView!
    
    @IBOutlet weak var tenkiImage2: UIImageView!
    
    @IBOutlet weak var tenkiImage3: UIImageView!
    
    @IBOutlet weak var oneHourTempratureLabel: UILabel!
    
    @IBOutlet weak var threeHoursTempratureLabel: UILabel!
    
    @IBOutlet weak var sixHoursTempratureLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let formatter = DateFormatter()
    
    
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    var cityName = String()
    var cityNameGo = String()
    
    let cityPosition = ["北海道":[43.03, 141.20], "青森":[40.49, 140.44], "岩手":[39.42, 141.09], "宮城":[38.16, 140.52], "秋田":[39.43, 140.06], "山形":[38.14, 140.21], "福島":[37.45, 140.28], "茨城":[36.20, 140.26], "栃木":[36.33, 139.53], "群馬":[36.23, 139.03], "埼玉":[35.51, 139.38], "千葉":[35.36, 140.07], "東京":[35.41, 139.41], "神奈川":[35.26, 139.38], "山梨":[35.39, 138.34], "長野":[36.39, 138.10], "新潟":[37.54, 139.01], "富山":[36.41, 137.12], "石川":[36.35, 136.37], "福井":[36.03, 136.13], "岐阜":[35.23, 136.43], "静岡":[34.58, 138.22], "愛知":[35.10, 136.54], "三重":[34.43, 136.30], "滋賀":[35.00, 135.52], "京都":[35.01, 135.45], "大阪":[34.41, 135.31], "兵庫":[34.41, 135.10], "奈良":[34.41, 135.49], "和歌山":[34.13, 135.10], "鳥取":[35.30, 134.14], "島根":[35.28, 133.03], "岡山":[34.39, 133.56], "広島":[34.23, 132.27], "山口":[34.11, 131.28], "徳島":[34.03, 134.33], "香川":[34.20, 134.02], "愛媛":[33.50, 132.45], "高知":[33.33, 133.31], "福岡":[33.36, 130.25], "佐賀":[33.14, 130.17], "長崎":[32.45, 129.52], "熊本":[32.47, 130.44], "大分":[33.14, 131.36], "宮崎":[31.54, 131.25], "鹿児島":[31.33, 130.33], "沖縄":[26.12, 127.40]]
    
    let weatherName = ["Clear": "晴れ", "Clouds" : "曇り", "Rain" : "雨"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSV()

        let docRef = db.collection("users").document(String(userID!))

        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            self.placeLabel.text = data["liveTown"] as! String
            
            self.cityName = data["liveTown"] as! String
            if self.cityName.contains("都"){
                
                self.cityName = String(self.cityName.dropLast())
                print(self.cityName)
                
            } else if self.cityName.contains("府"){
                
                self.cityName = String(self.cityName.dropLast())
                print(self.cityName)
                
            } else if self.cityName.contains("県"){
            
                self.cityName = String(self.cityName.dropLast())
                print(self.cityName)
                
            }
            
            let latitude = String(self.cityPosition[self.cityName]![0])
            let longitude = String(self.cityPosition[self.cityName]![1])
            
            self.getApi(lat: latitude, lon: longitude)
            
            print("Current data: \(data)")
            
            
        }

        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        self.dayLabel.text = formatter.string(from: Date())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    

    func getApi(lat:String, lon:String){
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=daily&appid=3ba54a68fb17e13c4b2a9cced973a3d4"
        
        //Alamofireを使ってhttpリクエストを投げる
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response) in
            
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                let nowWeather = json["current"]["weather"][0]["main"].string
                
                self.weatherLabel.text = self.weatherName[nowWeather!]
                
                self.weatherImage.image = UIImage(named: nowWeather!)
                
                let now_temprature = json["current"]["temp"].int
                
                self.tempratureLabel.text = String(now_temprature! - 273) + "℃"
                
                let oneHourWeather = json["hourly"][1]["weather"][0]["main"].string
                
                self.tenkiImage1.image = UIImage(named: oneHourWeather!)
                
                let oneHourTemprature = json["hourly"][1]["temp"].int
                
                self.oneHourTempratureLabel.text = String(oneHourTemprature! - 273) + "℃"
                
                let threeHourWeather = json["hourly"][3]["weather"][0]["main"].string
                
                self.tenkiImage2.image = UIImage(named: threeHourWeather!)
                
                let threeHourTemprature = json["hourly"][3]["temp"].int
                
                self.threeHoursTempratureLabel.text = String(threeHourTemprature! - 273) + "℃"
                
                let sixHoursWeather = json["hourly"][6]["weather"][0]["main"].string
                
                self.tenkiImage3.image = UIImage(named: sixHoursWeather!)
                
                let sixHourTemprature = json["hourly"][6]["temp"].int
                
                self.sixHoursTempratureLabel.text = String(sixHourTemprature! - 273) + "℃"
                
                
            case .failure(let error):
                print("error")
                print(error)
                
            }
            
        }
        
        
    }
    
    
    
    
    //２画面目
    
    func createDayLabel(contentsView: UIView)-> UILabel{

        // labelを作る
        let dayLabel = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        dayLabel.textAlignment = NSTextAlignment.center
        dayLabel.frame = CGRect(x: 531, y: 22, width: 179, height: 34)
        
        return dayLabel
    }

    func createPlaceLabel(contentsView: UIView)-> UILabel{

        // labelを作る
        let placeLabel = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        placeLabel.textAlignment = NSTextAlignment.center
        placeLabel.frame = CGRect(x: 531, y: 94, width: 179, height: 34)
        
        return placeLabel
    }
    
    func createNowWeather(contentsView: UIView)-> UILabel{

        // labelを作る
        let nowWeather = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        nowWeather.textAlignment = NSTextAlignment.center
        nowWeather.frame = CGRect(x: 531, y: 155, width: 179, height: 34)
        nowWeather.text = "現在の天気"
        
        return nowWeather
    }
    
    func createNowWeatherLabel(contentsView: UIView)-> UILabel{

        // labelを作る
        let nowWeatherLabel = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        nowWeatherLabel.textAlignment = NSTextAlignment.center
        nowWeatherLabel.frame = CGRect(x: 531, y: 214, width: 179, height: 34)
        nowWeatherLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        return nowWeatherLabel
    }
    
    func createNowWeatherImage(contentsView: UIView)-> UIImageView{

        // labelを作る
        let nowWeatherImage = UIImageView()
        
        // labelの座標をcontentsViewの中心にする
        nowWeatherImage.frame = CGRect(x:534, y:273, width:174, height:174)
        
        return nowWeatherImage
    }
    
    func createNowTemprature(contentsView: UIView)-> UILabel{

        // labelを作る
        let nowTemprature = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        nowTemprature.textAlignment = NSTextAlignment.center
        nowTemprature.frame = CGRect(x: 577, y: 487, width: 87, height: 21)
        nowTemprature.text = "現在の気温"
        
        return nowTemprature
    }
    
    func createNowTempratureLabel(contentsView: UIView)-> UILabel{

        // labelを作る
        let nowTempratureLabel = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        nowTempratureLabel.textAlignment = NSTextAlignment.center
        nowTempratureLabel.frame = CGRect(x: 534, y: 537, width: 174, height: 34)
        nowTempratureLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        return nowTempratureLabel
    }
    
    func createHourLabel1(contentsView: UIView)-> UILabel{

        // labelを作る
        let hourLabel1 = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        hourLabel1.textAlignment = NSTextAlignment.center
        hourLabel1.frame = CGRect(x: 453, y: 595, width: 87, height: 34)
        hourLabel1.text = "1時間後"
        
        return hourLabel1
    }
    
    func createWeatherImage1(contentsView: UIView)-> UIImageView{

        // labelを作る
        let WeatherImage1 = UIImageView()
        
        // labelの座標をcontentsViewの中心にする
        WeatherImage1.frame = CGRect(x:455, y:637, width:83, height:83)
        
        return WeatherImage1
    }
    
    func createTempratureLabel1(contentsView: UIView)-> UILabel{

        // labelを作る
        let tempratureLabel1 = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        tempratureLabel1.textAlignment = NSTextAlignment.center
        tempratureLabel1.frame = CGRect(x: 465, y: 735, width: 63, height: 31)
        
        return tempratureLabel1
    }
    
    func createHourLabel2(contentsView: UIView)-> UILabel{

        // labelを作る
        let hourLabel2 = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        hourLabel2.textAlignment = NSTextAlignment.center
        hourLabel2.frame = CGRect(x: 577, y: 595, width: 87, height: 34)
        hourLabel2.text = "3時間後"
        
        return hourLabel2
    }
    
    func createWeatherImage2(contentsView: UIView)-> UIImageView{

        // labelを作る
        let WeatherImage2 = UIImageView()
        
        // labelの座標をcontentsViewの中心にする
        WeatherImage2.frame = CGRect(x:579, y:637, width:83, height:83)
        
        return WeatherImage2
    }
    
    func createTempratureLabel2(contentsView: UIView)-> UILabel{

        // labelを作る
        let tempratureLabel2 = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        tempratureLabel2.textAlignment = NSTextAlignment.center
        tempratureLabel2.frame = CGRect(x: 589, y: 735, width: 63, height: 31)
        
        return tempratureLabel2
    }
    
    func createHourLabel3(contentsView: UIView)-> UILabel{

        // labelを作る
        let hourLabel3 = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        hourLabel3.textAlignment = NSTextAlignment.center
        hourLabel3.frame = CGRect(x: 701, y: 595, width: 87, height: 34)
        hourLabel3.text = "6時間後"
        
        return hourLabel3
    }
    
    func createWeatherImage3(contentsView: UIView)-> UIImageView{

        // labelを作る
        let WeatherImage3 = UIImageView()
        
        // labelの座標をcontentsViewの中心にする
        WeatherImage3.frame = CGRect(x:705, y:637, width:83, height:83)
        
        
        
        return WeatherImage3
    }
    
    func createTempratureLabel3(contentsView: UIView)-> UILabel{

        // labelを作る
        let tempratureLabel3 = UILabel()
        
        // labelの座標をcontentsViewの中心にする
        tempratureLabel3.textAlignment = NSTextAlignment.center
        tempratureLabel3.frame = CGRect(x: 715, y: 735, width: 63, height: 31)
        
        return tempratureLabel3
    }
    
    func createContentsView() -> UIView {

        // contentsViewを作る
        let contentsView = UIView()
        contentsView.frame = CGRect(x: 0, y: 0, width: 828, height: 800)
        
        scrollView.isPagingEnabled = true

        // contentsViewにlabelを配置させる
        let dayLabel = createDayLabel(contentsView: contentsView)
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        dayLabel.text = formatter.string(from: Date())
        contentsView.addSubview(dayLabel)
        
        let goPlaceLabel = createPlaceLabel(contentsView: contentsView)
        contentsView.addSubview(goPlaceLabel)
        
        let nowWeather = createNowWeather(contentsView: contentsView)
        contentsView.addSubview(nowWeather)
        
        let nowWeatherLabel = createNowWeatherLabel(contentsView: contentsView)
        contentsView.addSubview(nowWeatherLabel)
        
        let nowWeatherImage = createNowWeatherImage(contentsView: contentsView)
        contentsView.addSubview(nowWeatherImage)
        
        let nowTemprature = createNowTemprature(contentsView: contentsView)
        contentsView.addSubview(nowTemprature)
        
        let nowTempratureLabel = createNowTempratureLabel(contentsView: contentsView)
        contentsView.addSubview(nowTempratureLabel)
        
        let hourLabel1 = createHourLabel1(contentsView: contentsView)
        contentsView.addSubview(hourLabel1)
        
        let weatherImage1 = createWeatherImage1(contentsView: contentsView)
        contentsView.addSubview(weatherImage1)
        
        let tempratureLabel1 = createTempratureLabel1(contentsView: contentsView)
        contentsView.addSubview(tempratureLabel1)
        
        let hourLabel2 = createHourLabel2(contentsView: contentsView)
        contentsView.addSubview(hourLabel2)
        
        let weatherImage2 = createWeatherImage2(contentsView: contentsView)
        contentsView.addSubview(weatherImage2)
        
        let tempratureLabel2 = createTempratureLabel2(contentsView: contentsView)
        contentsView.addSubview(tempratureLabel2)
        
        let hourLabel3 = createHourLabel3(contentsView: contentsView)
        contentsView.addSubview(hourLabel3)
        
        let weatherImage3 = createWeatherImage3(contentsView: contentsView)
        contentsView.addSubview(weatherImage3)
        
        let tempratureLabel3 = createTempratureLabel3(contentsView: contentsView)
        contentsView.addSubview(tempratureLabel3)
        
        let docRef = db.collection("users").document(String(userID!))

        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            goPlaceLabel.text = data["goTown"] as? String
            
            self.cityNameGo = data["goTown"] as! String
            if self.cityNameGo.contains("都"){
                
                self.cityNameGo = String(self.cityNameGo.dropLast())
                print(self.cityName)
                
            } else if self.cityNameGo.contains("府"){
                
                self.cityNameGo = String(self.cityNameGo.dropLast())
                
            } else if self.cityNameGo.contains("県"){
            
                self.cityNameGo = String(self.cityNameGo.dropLast())
                print(self.cityName)
                
            }
            
            let latitude = String(self.cityPosition[self.cityNameGo]![0])
            let longitude = String(self.cityPosition[self.cityNameGo]![1])
            
            //self.getApi2(lat: latitude, lon: longitude)
            
            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=daily&appid=3ba54a68fb17e13c4b2a9cced973a3d4"
            
            //Alamofireを使ってhttpリクエストを投げる
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
                (response) in
                
                switch response.result{
                case .success:
                    let json:JSON = JSON(response.data as Any)
                    var nowWeather = json["current"]["weather"][0]["main"].string
                    
                    nowWeatherLabel.text = self.weatherName[nowWeather!]
                    
                    nowWeatherImage.image = UIImage(named: nowWeather!)
                    
                    var now_temprature = json["current"]["temp"].int
                    
                    nowTempratureLabel.text = String(now_temprature! - 273) + "℃"
                    
                    var oneHourWeather = json["hourly"][1]["weather"][0]["main"].string
                    
                    weatherImage1.image = UIImage(named: oneHourWeather!)
                    
                    var oneHourTemprature = json["hourly"][1]["temp"].int
                    
                    tempratureLabel1.text = String(oneHourTemprature! - 273) + "℃"
                    
                    var threeHourWeather = json["hourly"][3]["weather"][0]["main"].string
                    
                    weatherImage2.image = UIImage(named: threeHourWeather!)
                    
                    var threeHourTemprature = json["hourly"][3]["temp"].int
                    
                    tempratureLabel2.text = String(threeHourTemprature! - 273) + "℃"
                    
                    var sixHoursWeather = json["hourly"][6]["weather"][0]["main"].string
                    
                    weatherImage3.image = UIImage(named: sixHoursWeather!)
                    
                    var sixHourTemprature = json["hourly"][6]["temp"].int
                    
                    tempratureLabel3.text = String(sixHourTemprature! - 273) + "℃"
                    
                case .failure(let error):
                    print("error")
                    print(error)
                    
                }
                
            }
            
            
            
            print("Current data: \(data)")
        }

        return contentsView
    }

    func configureSV() {

        // scrollViewにcontentsViewを配置させる
        let subView = createContentsView()
        scrollView.addSubview(subView)

        //scrollViewにcontentsViewのサイズを教える
        scrollView.contentSize = subView.frame.size
        

    }
    
    

}
