//
//  DatabaseController.swift
//  Colorfeel
//
//  Created by Michael Cheng on 10/4/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

import Foundation
import UIKit

class DatabaseController {
    var db: FMDatabase
    
    init() {
        let databasePath = "\(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])" + "/colors.sqlite"
        print("\(databasePath)\n")
        db = FMDatabase(path: databasePath)
        db.open()
    }
    
    deinit {
        db.close()
    }
    
    func initializeDB() -> Bool {
        let sqlcreate = "CREATE TABLE IF NOT EXISTS ENTRIES (ID INTEGER PRIMARY KEY AUTOINCREMENT," +
                                                           "RED FLOAT, GREEN FLOAT, BLUE FLOAT, ALPHA FLOAT," +
                                                           "NOTE VARCHAR(140), TIME INT)"
        var initialized = db.executeUpdate(sqlcreate, withArgumentsInArray: nil)
        if(!initialized) {
            print(db.lastError())
            return false
        }
        print("INITIALIZATION SUCCESSFUL")
        println()
        return true
    }
    
    func getEntries(startDate: NSDate, endDate: NSDate? = nil) -> [ColorEntry] {
        let sqlquery = "SELECT * FROM ENTRIES WHERE TIME BETWEEN ? AND ?"
        var interval = [Int]()
        if endDate == nil {
            interval = getTimeInterval(startDate, end: startDate)
        } else {
            interval = getTimeInterval(startDate, end: endDate!)
        }
        var results: FMResultSet = db.executeQuery(sqlquery, withArgumentsInArray: interval)
        return convert(results)
    }
    
    func createEntry(color: UIColor, note: String? = nil) {
        var sqlinsert = "INSERT INTO ENTRIES (RED, GREEN, BLUE, ALPHA, TIME) VALUES (?, ?, ?, ?, ?)"
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        var args: [AnyObject] = [r, g, b, a, NSInteger(NSDate().timeIntervalSince1970)]
        if note? != nil {
            args.append(note!)
            sqlinsert = "INSERT INTO ENTRIES (RED, GREEN, BLUE, ALPHA, TIME, NOTE) VALUES (?, ?, ?, ?, ?, ?)"
        }
        db.executeUpdate(sqlinsert, withArgumentsInArray: args)
    }
    
    func convert(results: FMResultSet) -> [ColorEntry] {
        var retArray = [ColorEntry]()
        while (results.next()) {
            var color: UIColor = UIColor(
                red: CGFloat(results.objectForColumnName("RED") as NSNumber),
                green: CGFloat(results.objectForColumnName("GREEN") as NSNumber),
                blue: CGFloat(results.objectForColumnName("BLUE") as NSNumber),
                alpha: CGFloat(results.objectForColumnName("ALPHA") as NSNumber))
            var time: NSDate = results.dateForColumn("TIME")
            var note: String? = results.columnIsNull("NOTE") ? nil : results.stringForColumn("NOTE")
            retArray.append(ColorEntry(color: color, time: time, note: note))
        }
        return retArray
    }
    
    //returns size 2 array: first is unix-time(start at midnight), second is unix-time(end at 23:59:59PM)
    func getTimeInterval(start: NSDate, end: NSDate) -> [Int]{
        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var startcomp = cal.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: start)
        //midnight of start day
        var tstart = NSInteger((cal.dateFromComponents(startcomp))!.timeIntervalSince1970)
        var endcomp = cal.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: end)
        endcomp.hour = 23; endcomp.minute = 59; endcomp.second = 59;
        var tend = NSInteger((cal.dateFromComponents(endcomp))!.timeIntervalSince1970)
        return [tstart, tend]
    }
}

struct ColorEntry: Printable {
    var color: UIColor
    var time: NSDate
    var note: String?
    
    init(color: UIColor, time: NSDate, note: String? = nil) {
        self.color = color
        self.time = time
        self.note = note
    }
    
    var description: String {
        return "ColorEntry:\n\tColor: \(color)\n\tTime: \(time)\n\tNote: \(note)\n"
    }
}