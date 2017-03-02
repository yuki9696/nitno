//
//  ModalClass.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 28/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PLIST {
    //MARK: Properties
    static let name = "Some"
    static let type = "plist"
    static let shared = PLIST()
    var mainArray = Array<[String:Any]>()
    fileprivate var path:URL! {
        get{
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = URL(fileURLWithPath: paths).appendingPathComponent(PLIST.name).appendingPathExtension(PLIST.type)
            print("DocumentDir = \(url)")
            return url
        }
    }
    
    //MARK:- initializer
    fileprivate init() {
        //let bundlePath = Bundle.main.path(forResource: PLIST.name, ofType: PLIST.type)!
        guard let sourceURL = Bundle.main.url(forResource: PLIST.name, withExtension: PLIST.type) else {
            return
        }
        let mngr = FileManager.default
        if mngr.fileExists(atPath: self.path.path) == true {
            self.read()
            return
        }
        do {
            try mngr.copyItem(at: sourceURL, to: self.path)
        } catch {
            print(error.localizedDescription)
        }
        self.read()
    }
}
extension PLIST {
    //MARK:- - functions
    func remove(_ object:[String:Any]) -> [String:Any] {
        let objID = object["id"] as! Int
        let index:Int = self.mainArray.index(where: {$0["id"] as! Int == objID})!
        return self.mainArray.remove(at: index)
    }
    
    func insert(_ object:[String:Any],atIndex idx:Int) {
        self.mainArray.insert(object, at: idx)
    }
    
    //Private Functions
}
extension PLIST {
    //*** this function reads the data of file.
    func read() {
        //If your plist contain root as Array
        guard let fileUrl = Bundle.main.url(forResource: PLIST.name, withExtension: PLIST.type) else {
            return
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            let result = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [[String:Any]]
            if let result = result {
                self.mainArray = result
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //*** this function will write the array in file.
    func write() {
        let array = self.mainArray as NSArray
        array.write(to: self.path, atomically: true)
    }
}
//MARK:- end Class PLIST

//MARK:- Start Class AudioPlayer
class AudioPlayer:NSObject {
    
    //var loadingUserBlock:((_ user:User?) -> Void)?
    var didStartPlaying:((_ dict:[String:Any],_ index:Int) -> Void)?
    var didStopPlaying:((_ index:Int) -> Void)?
    var currentIndex:Int = -1

    var files = Array<[String:Any]>()
    //var isSingle = true
    var isFromHeader = false
    
    var object:[String:Any]? {
        didSet{
            guard let object = self.object else { return }
            self.files = Array<[String:Any]>()
            if object.keys.contains("chats") == true {
                //THIS IS ROOT OBJECT
//                let id = object["id"] as! Int
//                let audio = object["audio"] as! String
//                self.files.append(["id":id,"audio":audio])
                
                let chats = object["chats"] as! Array<[String:Any]>
                for chat in chats {
                    let id = chat["id"] as! Int
                    let audio = chat["audio"] as! String
                    self.files.append(["id":id,"audio":audio])
                }
                //now sort data
                self.files.sort{ ($0["id"] as! Int) < ($1["id"] as! Int) }
                print(self.files)
                
                //now insert root audio at 0 index.
                let id = object["id"] as! Int
                let audio = object["audio"] as! String
                self.files.insert(["id":id,"audio":audio], at: 0)
                print(self.files)
                self.currentIndex = -1
            }else {
                //THIS IS SINGLE CHAT FROM CHAT ARRAY
                let idx = object["id"] as! Int
                let audio = object["audio"] as! String
                let dict:[String:Any] = ["id":idx,"audio":audio]
                self.files = [dict]
                print(idx)
                self.currentIndex = idx
                print(self.currentIndex)
                
                if self.isFromHeader == true {
                    self.currentIndex = -1
                }else {
                    self.currentIndex = idx + 1
                }
                print(self.currentIndex)
            }
            
            let first = self.files.first!
            self.setupPlayer(withData: first)
        }
    }
    fileprivate var player:AVAudioPlayer!
    
    init(withStartingClosure block1:@escaping(_ dict:[String:Any],_ index:Int) -> Void,andStopingClosure block2:@escaping(_ index:Int) -> Void) {
        self.didStartPlaying = block1
        self.didStopPlaying = block2
    }
    deinit {
        
        self.player.stop()
        self.player = nil
    }
}
extension AudioPlayer {
    func getURL(ofAudio name:String) -> URL {
        let url = URL(string: name)!
        let nm = url.deletingPathExtension().absoluteString
        let type = url.pathExtension
        let path = Bundle.main.url(forResource: nm, withExtension: type)!
        return path
    }
    
    func setupPlayer(withData data:[String:Any]){
        let name = data["audio"] as! String
        var idx = self.currentIndex - 1
        if idx < -1 {
            idx = -1
        }
//        if self.isFromHeader == true {
//            idx = -1
//        }
        print("\nCurrentIndex = \(idx),and Audio is = \(data)")
        let path = self.getURL(ofAudio: name)
        do {
            try self.setupAudioSession()
            self.player = try AVAudioPlayer(contentsOf: path)
            self.player.delegate = self
            if self.player.prepareToPlay() == true {
                self.player.play()
                self.didStartPlaying?(data, idx)
            }else{
                print("----------Can't Play \(data)")
            }
        }
        catch {
            print(error.localizedDescription)
            let alert = UIAlertView(title: "Error!", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func next() -> Bool {
        let count = self.files.count
        var nextIndex = self.currentIndex + 1
        if self.currentIndex == -1 && nextIndex == 0 {
            nextIndex = 1
        }
        //Make sure that nextIndex is not greater than count
        if nextIndex < count {
            self.didStopPlaying?(self.currentIndex)
            self.currentIndex = nextIndex
            let obj = self.files[nextIndex]
            self.setupPlayer(withData: obj)
            return true
        }
        self.didStopPlaying?(self.currentIndex)
        return false
    }
    func nextFromHeader() -> Bool {
        let count = self.files.count
        let nextIndex = self.currentIndex + 1
        self.currentIndex = 0
        if nextIndex < count {
            self.didStopPlaying?(-1)
            
            let obj = self.files[nextIndex]
            self.setupPlayer(withData: obj)
            return true
        }
        self.didStopPlaying?(-1)
        return false
    }
    
    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try audioSession.setMode(AVAudioSessionModeDefault)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
    }
}
extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            _ = self.next()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    }
}
