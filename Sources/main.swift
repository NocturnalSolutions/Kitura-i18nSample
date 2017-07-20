import Kitura
import KituraLangNeg
import LoggerAPI
import HeliumLogger
import KituraTranslation
import Foundation

HeliumLogger.use()

guard let ln = try? LanguageNegotiation(["en", "ja", "es", "zh-hans"], methods: .pathPrefix) else {
    Log.error("Something went horribly wrong.")
    exit(1)
}

let poDir = URL(fileURLWithPath: #file + "/../../Translations").standardizedFileURL.path

let settings = TranslationSettings(lang: "en", poDir: poDir)
Translation.settings = settings

let router = Router()

router.get("/") { request, response, next in
    defer {
        next()
    }

    if request.userInfo["LangNeg"] == nil {
        Translation.settings!.lang = "en"
    }
    else {
        let match = request.userInfo["LangNeg"] as! LanguageNegotiation.NegMatch
        Translation.settings!.lang = match.lang
    }
    response.send("Hello!".t())
    response.send("\n")
}

let parentRouter = Router()
parentRouter.all(ln.routerPaths, middleware: [ln, router])

Kitura.addHTTPServer(onPort: 8080, with: parentRouter)
Kitura.run()
