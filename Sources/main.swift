import Kitura
import KituraLangNeg
import LoggerAPI
import HeliumLogger
import KituraTranslation
import Foundation

// Initialize HeliumLogger
HeliumLogger.use()

// Try to initialize LanguageNegotiation
guard let ln = try? LanguageNegotiation(["en", "ja", "es", "zh-hans"], methods: .pathPrefix) else {
    Log.error("Something went horribly wrong.")
    exit(1)
}

// Get the directory of our translation files as included
// in the repo. Note that when running on a "real" server
// you're probably going to want to find a better place
// for them.
let poDir = URL(fileURLWithPath: #file + "/../../Translations").standardizedFileURL.path

// Set settings for Translation.
let settings = TranslationSettings(lang: "en", poDir: poDir)
Translation.settings = settings

//Initialze our router and define our callback.
let router = Router()
router.get("/") { request, response, next in
    defer {
        next()
    }

    // LanguageNegotiation should have put its match info
    // in request.userInfo["LangNeg"], so check for it
    // there.
    if request.userInfo["LangNeg"] == nil {
        Translation.settings!.lang = "en"
    }
    else {
        let match = request.userInfo["LangNeg"] as! LanguageNegotiation.NegMatch
        // Have Translation use the language that LangNeg
        // matched on.
        Translation.settings!.lang = match.lang
    }

    // Send "Hello!" translated.
    response.send("Hello!".t())
    // And then a line break for prettiness.
    response.send("\n")
}

// Since we're using the path prefix language matching
// method, we need to have our router be a "subrouter" of
// a router which will also have the LanguageNegotiation
// instance we defined above as middleware.
let parentRouter = Router()
parentRouter.all(ln.routerPaths, middleware: [ln, router])

// Set up Kitura to use our parent router and start
// serving!
Kitura.addHTTPServer(onPort: 8080, with: parentRouter)
Kitura.run()
