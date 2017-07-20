# Kitura i18n Sample

This project is a fully pre-built [Kitura](http://www.kitura.io) site (dependencies aside) which demonstrates how [Kitura Translation](https://github.com/NocturnalSolutions/Kitura-Translation) and [Kitura Language Negotiation](https://github.com/NocturnalSolutions/Kitura-LanguageNegotiation) (which are also projects of mine) can be used together to build a site which supports common i18n (internationalization) functionality. It shows a simple message in English, or translated into Spanish, Simplified Chinese or Japanese.

*Note: As the projects mentioned above are still in an early development state, their APIs may break in a way which breaks this site and it may take me a while to notice it. If you're playing with this site and something doesn't seem to be working as expected, please contact me and let me know so I can fix it.)*

## Instructions

Note that these instructions assume you have some basic experience with Kitura; at the least, you've worked your way through the "[Getting started](http://www.kitura.io/en/starter/gettingstarted.html)" and "[Tutorial](http://www.kitura.io/en/resources/tutorials.html)" pages on the Kitura site.

Build the site with `swift build`. Run the created binary.

Now access the `/en`, `/es`, `/ja`, or `/zh-hans` path.

```
> curl localhost:8080/en
Hello!
> curl localhost:8080/es
¡Hola!
> curl localhost:8080/zh-hans
你好！
> curl localhost:8080/ja
こんにちは！
```

(Or use `wget` or `fetch` or what have you.)

Okay, so that's not very interesting by itself. But open up `main.swift` and see what's going on here.

First, note there's only one route, the "`/`" route. But what about the routes I had you access above? Those are defined by Kitura Language Negotiation when it is configured in "path prefix" mode (see KLN's README.md for more information on how it can be configured). KLN is then set as middleware on routes corresponding to the languages it is configured for. This may sound more complex than it is; again, just have a look at the code and you should be able to get it.

There's only one route which is actually defined in this project and it doesn't specify the non-English translations in there. It just says:

```swift
    // Send "Hello!" translated.
    response.send("Hello!".t())
```

That `t()` method on strings is what kicks off the translation. Kitura Translation will search for a translation for "Hello!" for the given language. Translations are stored in standard [PO files](https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/PO-Files.html), though only the `msgid`, `msgstr` and `msgctxt` keys are supported thus far. In this project, they are stored in the "Translations" directory in the root level of the project, but they can be stored in any readable directory.

This code can be modified pretty easily to work with subdomains (such as `en.example.com`, `ja.example.com`, etc) instead of path prefixes. See the README.md for Kitura Language Negotiation for guidance.

Thanks for checking out this project! Please get in touch if you have any questions, comments, or suggestions.
