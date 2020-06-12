# creating the mobile app

This is the MVP of a mobile app to analyze with Waston NLU the articles presented at Hacker News (analyzing only articles by their URL).

Follow the steps:

1. if you haven't done it before - clone tha app
```
$ git clone https://github.com/serverless-swift/ch6-app
Cloning into 'ch6-app'...

remote: Enumerating objects: 100, done.
remote: Counting objects: 100% (100/100), done.
remote: Compressing objects: 100% (77/77), done.
remote: Total 100 (delta 38), reused 61 (delta 15), pack-reused 0
Receiving objects: 100% (100/100), 4.91 MiB | 231.00 KiB/s, done.
Resolving deltas: 100% (38/38), done.
```

Now change the directory to teh app folder:

```
$ cd ch6-app/
$ cd 03-nlu-app/
$ cd hacker-news/
$ ls
Podfile			hacker-news		hacker-news.xcodeproj
```

Run `pod install` to initialize the dependencies of the app:

```

$ pod install
Analyzing dependencies
Pre-downloading: `OpenWhisk` from `https://github.com/apache/incubator-openwhisk-client-swift.git`, tag `0.3.0`
Downloading dependencies
Installing OpenWhisk (0.3.0)
Installing SwiftyJSON (4.3.0)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `hacker-news.xcworkspace` for this project from now on.
Pod installation complete! There are 2 dependencies from the Podfile and 2 total pods installed.

[!] Automatically assigning platform `iOS` with version `13.5` on target `hacker-news` because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.
Mareks-MBP:hacker-news mareksadowski$ ls
Podfile			Pods			hacker-news.xcodeproj
Podfile.lock		hacker-news		hacker-news.xcworkspace

```

Use XCode IDE to open the `hacker-news.xcworkspace` file.

From the previous steps and basing on the Serverless Swift instructions set up the environment in the app:

```swift

   /**
     Update your whisk data - follow the instructions in chapter 4 and chapter 6 of Serverless Swift@Apress 2020
     by Marek Sadowski and Lennart Frantzell
     
    // Change to your whisk app key and secret.
    let WhiskAppKey = "<your WhiskAppKey>"
    let WhiskAppSecret = "<your WhiskAppSecret"
    
    // the URL for Whisk backend
    let baseUrl: String? = "https://openwhisk.ng.bluemix.net"

    // Choice: specify components
    let MyNamespace: String = "serverless.swift@roboticsind.com_dev"
    
    // Specify you package
    let MyPackage: String? = "hacker-news-pak"
*/
    
    //Update your whisk data - follow the instructions in chapter 4 and chapter 6 of Serverless Swift@Apress 2020
    //by Marek Sadowski and Lennart Frantzell
     
    // Change to your whisk app key and secret.
    let WhiskAppKey = "<your WhiskAppKey>"
    let WhiskAppSecret = "<your WhiskAppSecret"
    
    // the URL for Whisk backend something like "https://openwhisk.ng.bluemix.net"
    let baseUrl: String? = "<the URL for Whisk backend>"

    // Choice: specify components "serverless.swift@roboticsind.com_dev"
    let MyNamespace: String = "<your CloudFoundry namespace>"
    
    // Specify you package
    let MyPackage: String? = "hacker-news-pak"
    
    // The actions to invoke.
    let MyWhiskAction0: String = "analyzeTopHNewsSequence"
    let MyWhiskAction1: String = "getAllHNewsIds"
    let MyWhiskAction2: String = "GetHNewsNLUanalysis"


```

Run the app in the simulator.
