

import Foundation

class Activity: NSObject, NSCoding{
    
    var rev: String?
    var aid: String?
    var authorID: String?
    var userName: String?
    var groupID: String?
    var activity: String?
    var activityText: String?
    var locationOfActivity: String?
    var isInProcess: Bool?
    var status: Int?
    var wellBeingState: Int?
    var wellBeingText: String?
    var addictionState: Int?
    var addictionText: String?
    var dateString: String?
    var timeString: String?
    var dateObject: Date?
    var timeObject: Date?
    var commentIDs: [String]?
    var likeIDs: [String]?
    var hasBeenUpdated = false
    
    init(rev: String?, aid: String?, authorID: String?, authorUsername: String? ,groupID: String?,activity: String?,activityText: String?,locationOfActivity: String?,isInProcess: Bool?,status: Int?,wellBeingState: Int?,wellBeingText: String?,addictionState: Int?,addictionText: String?,dateObject: Date?,timeObject: Date?,dateString: String?, timeString: String?, commentIDs: [String]?, likeIDs: [String]?) {
        
        if let revision = rev {
            self.rev = revision
        }
        if let ID = aid {
            self.aid = ID
        }
        if let adID = authorID {
            self.authorID = adID
        }
        if let username = authorUsername {
            self.userName = username
        }
        if let group = groupID {
            self.groupID = group
        }
        if let act = activity {
            self.activity = act
        }
        if let actText = activityText {
            self.activityText = actText
        }
        if let loc = locationOfActivity {
            self.locationOfActivity = loc
        }
        if let inProcess = isInProcess{
            self.isInProcess = inProcess
        }
        if let stat = status{
            self.status = stat
        }
        if let wellBeStat = wellBeingState{
            self.wellBeingState = wellBeStat
        }
        if let wellBeText = wellBeingText{
            self.wellBeingText = wellBeText
        }
        if let addState = addictionState{
            self.addictionState = addState
        }
        if let addText = addictionText{
            self.addictionText = addText
        }
        if let comments = commentIDs {
            self.commentIDs = comments
        }
        if let likes = likeIDs {
            self.likeIDs = likes
        }
        if let dat = dateObject{
            self.dateObject = dat
            self.dateString = dat.getDateTimeFormatted()
        }
        
        if let datStr = dateString{
            self.dateString = datStr
            self.dateObject = Date(dateString: datStr)
        }

        if let timeStr = timeString{
        self.timeString = timeStr
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.timeObject = formatter.date(from: timeStr)
        }
        
        if let timO = timeObject{
            self.timeObject = timO
            self.timeString = timO.getTimePart()
        }
    }
    
    convenience init(props: [String: Any]) {
        self.init(rev: props["_rev"] as! String?, aid: props["_id"] as! String?, authorID: props["authorID"] as! String?, authorUsername: nil, groupID: props["groupID"] as! String?, activity: props["activity"] as! String?, activityText: props["activityText"] as! String?, locationOfActivity: props["locationOfActivity"] as! String?, isInProcess: props["isInProcess"] as! Bool?, status: props["status"] as! Int?, wellBeingState: props["wellBeingState"] as! Int?, wellBeingText: props["wellBeingText"] as! String?, addictionState: props["addictionState"] as! Int?, addictionText: props["addictionText"] as! String?, dateObject: nil, timeObject: nil, dateString: props["date"] as! String?, timeString: props["time"] as! String?, commentIDs: props["commentIDs"] as! [String]?, likeIDs: props["likeIDs"] as! [String]?)
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _rev = aDecoder.decodeObject(forKey: "rev") as? String{
            self.rev = _rev
        }
        if let ID = aDecoder.decodeObject(forKey: "aid") as? String{
            self.aid = ID
        }
        if let adID = aDecoder.decodeObject(forKey: "authorID") as? String{
            self.authorID = adID
        }
        if let username = aDecoder.decodeObject(forKey: "username") as? String{
            self.userName = username
        }
        if let group = aDecoder.decodeObject(forKey: "groupID") as? String{
            self.groupID = group
        }
        if let act = aDecoder.decodeObject(forKey: "activity") as? String{
            self.activity = act
        }
        if let actText = aDecoder.decodeObject(forKey: "activityText") as? String{
            self.activityText = actText
        }
        if let loc = aDecoder.decodeObject(forKey: "locationOfActivity") as? String{
            self.locationOfActivity = loc
        }
        if let inProcess = aDecoder.decodeObject(forKey: "isInProcess") as? Bool{
            self.isInProcess = inProcess
        }
        if let stat = aDecoder.decodeObject(forKey: "status") as? Int{
            self.status = stat
        }
        if let wellBeState = aDecoder.decodeObject(forKey: "wellBeingState") as? Int{
            self.wellBeingState = wellBeState
        }
        if let wellBeText = aDecoder.decodeObject(forKey: "wellBeingText") as? String{
            self.wellBeingText = wellBeText
        }
        if let addState = aDecoder.decodeObject(forKey: "addictionState") as? Int{
            self.addictionState = addState
        }
        if let addText = aDecoder.decodeObject(forKey: "addictionText") as? String{
            self.addictionText = addText
        }
        if let com = aDecoder.decodeObject(forKey: "commentIDs") as? [String]{
            self.commentIDs = com
        }
        if let likes = aDecoder.decodeObject(forKey: "likeIDs") as? [String]{
            self.likeIDs = likes
        }
        if let update = aDecoder.decodeObject(forKey: "hasBeenUpdated") as? Bool{
            self.hasBeenUpdated = update
        }
        if let dateStr = aDecoder.decodeObject(forKey: "dateString") as? String{
            self.dateString = dateStr
        }
        if let timeStr = aDecoder.decodeObject(forKey: "timeString") as? String{
            self.timeString = timeStr
        }
        if let tim = aDecoder.decodeObject(forKey: "timeOfActivity") as? Date{
            self.timeObject = tim
        }
        if let dateO = aDecoder.decodeObject(forKey: "dateOfActivity") as? Date{
            self.dateObject = dateO
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let _rev = self.rev {
            aCoder.encode(_rev, forKey: "rev")
        }
        if let ID = self.aid {
            aCoder.encode(ID, forKey: "aid")
        }
        if let username = self.userName {
            aCoder.encode(username, forKey: "username")
        }
        if let group = self.groupID {
            aCoder.encode(group, forKey: "groupID")
        }
        if let act = self.activity {
            aCoder.encode(act, forKey: "activity")
        }
        if let stat = self.status {
            aCoder.encode(stat, forKey: "status")
        }
        if let loc = self.locationOfActivity {
            aCoder.encode(loc, forKey: "locationOfActivity")
        }
        if let inProcess = self.isInProcess {
            aCoder.encode(inProcess, forKey: "isInProcess")
        }
        if let actText = self.activityText {
            aCoder.encode(actText, forKey: "activityText")
        }
        if let addText = self.addictionText {
            aCoder.encode(addText, forKey: "addictionText")
        }
        if let addState = self.addictionState {
            aCoder.encode(addState, forKey: "addictionState")
        }
        if let wellBeText = self.wellBeingText {
            aCoder.encode(wellBeText, forKey: "wellBeingText")
        }
        if let wellBeState = self.wellBeingState {
            aCoder.encode(wellBeState, forKey: "wellBeingState")
        }
        if let dateOb = self.dateObject {
            aCoder.encode(dateOb, forKey: "dateObject")
        }
        if let timeOb = self.timeObject {
            aCoder.encode(timeOb, forKey: "timeObject")
        }
        if let comments = self.commentIDs {
            aCoder.encode(comments, forKey: "commentIDs")
        }
        if let likes = self.likeIDs {
            aCoder.encode(likes, forKey: "likeIDs")
        }
        aCoder.encode(hasBeenUpdated, forKey: "hasBeenUpdated")
        
        if let dateStr = self.dateString {
            aCoder.encode(dateStr, forKey: "dateString")
        }
        if let timeStr = self.timeString {
            aCoder.encode(timeStr, forKey: "timeString")
        }
    }
    
    
    
    func getPropertyPackageCreateActivity() -> [String: Any]{
        var properties = [String: Any]()
        
        properties["type"] = "DailyActivity"
        properties["commentIDs"] = [String]()
        properties["likeIDs"] = [String]()
        properties["isInProcess"] = true
        properties["wellBeingState"] = -1
        properties["wellBeingText"] = ""
        properties["addictionState"] = -1
        properties["addictionText"] = ""
        properties["status"] = -1
        properties["activityText"] = ""
        
        if let group = self.groupID {
            properties["groupID"] = group
        }
        if let loc = self.locationOfActivity {
            properties["locationOfActivity"] = loc
        }
        
        if let aID = self.authorID {
            properties["authorID"] = aID
        }
        if let aUserName = self.userName {
            properties["authorUsername"] = aUserName
        }
        
        if let act = self.activity {
            properties["activity"] = act
        }
        if let tim = self.timeString{
            properties["time"] = tim
        }
        
        if let dat = self.dateString{
            properties["date"] = dat
        }
        return properties
    }
    
    func getUpdatedPropertyPackageActivity() -> [String: Any]{
        var properties = [String: Any]()
        
        properties["type"] = "DailyActivity"
        properties["commentIDs"] = [String]()
        properties["likeIDs"] = [String]()
        
        if let addictionTe = self.addictionText {
            properties["addictionText"] = addictionTe
        }
        if let stat = self.status {
            properties["status"] = stat
        }
        if let statText = self.activityText {
            properties["activityText"] = statText
        }
        if let addictionSta = self.addictionState {
            properties["addictionState"] = addictionSta
        }
        if let wellBeingTe = self.wellBeingText {
            properties["wellBeingText"] = wellBeingTe
        }
        
        if let wellBeingSta = self.wellBeingState {
            properties["wellBeingState"] = wellBeingSta
        }
        
        if let inProcess = self.isInProcess {
            properties["isInProcess"] = inProcess
        }
        if let group = self.groupID {
            properties["groupID"] = group
        }
        
        if let loc = self.locationOfActivity {
            properties["locationOfActivity"] = loc
        }
        
        if let aID = self.authorID {
            properties["authorID"] = aID
        }
        if let aUserName = self.userName {
            properties["authorUsername"] = aUserName
        }
        
        if let act = self.activity {
            properties["activity"] = act
        }
        if let tim = self.timeString{
            properties["time"] = tim
        }
        
        if let dat = self.dateString{
            properties["date"] = dat
        }
        return properties
    }
}
