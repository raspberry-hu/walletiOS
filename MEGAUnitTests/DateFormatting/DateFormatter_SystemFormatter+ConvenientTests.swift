import XCTest
@testable import MEGA

class DateFormatter_System_ConvenientTests: XCTestCase {

    func testShortTemplateDateFormatter_FormatDates_InDifferentLanguage() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]

        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)

        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateShort(locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short

        let resultDates = locales.map { locale -> String in
            formatter.locale = locale
            return formatter.string(from: date)
        }

        // Then
        XCTAssertEqual(formattedDates, resultDates)
    }

    func testShortTemplateDateFormatter_FormatDates_InDifferentLanguage_CalendarGregorian() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]

        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)
        let calendar = Calendar(identifier: .gregorian)

        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateShort(calendar: calendar, locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }
        
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateStyle = .short

        let resultDates = locales.map { locale -> String in
            formatter.locale = locale
            return formatter.string(from: date)
        }

        // Then
        XCTAssertEqual(formattedDates, resultDates)
    }

    // MARK: - Medium Formatter

    func testMediumTemplateDateFormatter_FormatDates_InDifferentLanguage() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]
        
        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)
        
        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateMedium(locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }
        
        // Then
        XCTAssertEqual(formattedDates, ["Jan 1, 1970", "1 ene 1970", "Jan 1, 1970", "1 gen 1970", "1 jan. 1970", "1 ??????. 1970????.", "1970???1???1???", "1 de jan. de 1970", "1 janv. 1970", "1970/01/01", "01.01.1970", "1970. 1. 1.", "01.01.1970", "1 Jan 1970", "1 ian. 1970", "ng??y 1 thg 1, 1970", "1970???1???1???", "???????/???????/????????", "1 ???.???. 2513"])
    }
    
    func testMediumTemplateDateFormatter_FormatDates_InDifferentLanguage_CalendarGregorian() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]
        
        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)
        let calendar = Calendar(identifier: .gregorian)
        
        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateMedium(calendar: calendar, locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }
        
        // Then
        XCTAssertEqual(formattedDates, ["Jan 1, 1970", "1 ene 1970", "Jan 1, 1970", "1 gen 1970", "1 jan. 1970", "1 ??????. 1970????.", "1970???1???1???", "1 de jan. de 1970", "1 janv. 1970", "1970/01/01", "01.01.1970", "1970. 1. 1.", "01.01.1970", "1 Jan 1970", "1 ian. 1970", "ng??y 1 thg 1, 1970", "1970???1???1???", "???????/???????/????????", "1 ???.???. 1970"])
    }

    // MARK: - Long Formatter

    func testLongTemplateDateFormatter_FormatDates_InDifferentLanguage() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]

        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)

        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateLong(locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }

        // Then
        XCTAssertEqual(formattedDates, ["January 1, 1970", "1 de enero de 1970", "January 1, 1970", "1 gennaio 1970", "1 januari 1970", "1 ???????????? 1970????.", "1970???1???1???", "1 de janeiro de 1970", "1 janvier 1970", "1970???1???1???", "1. Januar 1970", "1970??? 1??? 1???", "1 stycznia 1970", "1 Januari 1970", "1 ianuarie 1970", "ng??y 1 th??ng 1, 1970", "1970???1???1???", "?? ???????????? ????????", "1 ?????????????????? 2513"])
    }

    func testLongTemplateDateFormatter_FormatDates_InDifferentLanguage_CalendarGregorian() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]

        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)
        let calendar = Calendar(identifier: .gregorian)

        // When format with `medium` formatter
        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateLong(calendar: calendar, locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }

        // Then
        XCTAssertEqual(formattedDates, ["January 1, 1970", "1 de enero de 1970", "January 1, 1970", "1 gennaio 1970", "1 januari 1970", "1 ???????????? 1970????.", "1970???1???1???", "1 de janeiro de 1970", "1 janvier 1970", "1970???1???1???", "1. Januar 1970", "1970??? 1??? 1???", "1 stycznia 1970", "1 Januari 1970", "1 ianuarie 1970", "ng??y 1 th??ng 1, 1970", "1970???1???1???", "?? ???????????? ????????", "1 ?????????????????? ???.???. 1970"])
    }

    // MARK: - Full Formatter

    func testFullTemplateDateFormatter_FormatDates_InDifferentLanguage() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]

        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)

        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateFull(locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }

        // Then
        XCTAssertEqual(formattedDates, ["Thursday, January 1, 1970", "jueves, 1 de enero de 1970", "Thursday, January 1, 1970", "gioved?? 1 gennaio 1970", "donderdag 1 januari 1970", "??????????????, 1 ???????????? 1970????.", "1970???1???1??? ?????????", "quinta-feira, 1 de janeiro de 1970", "jeudi 1 janvier 1970", "1970???1???1??? ?????????", "Donnerstag, 1. Januar 1970", "1970??? 1??? 1??? ?????????", "czwartek, 1 stycznia 1970", "Kamis, 01 Januari 1970", "joi, 1 ianuarie 1970", "Th??? N??m, ng??y 1 th??ng 1, 1970", "1970???1???1??? ?????????", "?????????????? ?? ???????????? ????????", "?????????????????????????????????????????? 1 ?????????????????? ???.???. 2513"])
    }

    func testFullTemplateDateFormatter_FormatDates_InDifferentLanguage_CalendarGregorian() {
        let languageIdentifiers = [
            "en", "es", "en", "it", "nl", "ru", "zh-TW", "pt-BR", "fr", "ja", "de", "ko", "pl", "id", "ro", "vi", "zh-CN", "ar", "th"
        ]

        // Given 1 Jan 1970
        let date = Date(timeIntervalSince1970: 0)
        let locales = languageIdentifiers.map(Locale.init)
        let calendar = Calendar(identifier: .gregorian)

        let formattedDates = locales.map { (locale) -> String in
            let formatter = DateFormatter.dateFull(calendar: calendar, locale: locale)
            let result = formatter.localisedString(from: date)
            return result
        }

        // Then
        XCTAssertEqual(formattedDates, ["Thursday, January 1, 1970", "jueves, 1 de enero de 1970", "Thursday, January 1, 1970", "gioved?? 1 gennaio 1970", "donderdag 1 januari 1970", "??????????????, 1 ???????????? 1970????.", "1970???1???1??? ?????????", "quinta-feira, 1 de janeiro de 1970", "jeudi 1 janvier 1970", "1970???1???1??? ?????????", "Donnerstag, 1. Januar 1970", "1970??? 1??? 1??? ?????????", "czwartek, 1 stycznia 1970", "Kamis, 01 Januari 1970", "joi, 1 ianuarie 1970", "Th??? N??m, ng??y 1 th??ng 1, 1970", "1970???1???1??? ?????????", "?????????????? ?? ???????????? ????????", "?????????????????????????????????????????? 1 ?????????????????? ???.???. 1970"])
    }
}
