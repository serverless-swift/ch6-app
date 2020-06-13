# creating the mobile app

This is the MVP of a mobile app to analyze with Waston NLU the articles presented at Hacker News (analyzing only articles by their URL).

[Watch the youtube video with the detailed steps](https://youtu.be/MIFshouo780)

Follow the steps:

1. if you haven't done it before - clone the basic app 
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

Now change the directory to the app folder:

```
$ cd 01-basic-app/hacker-news/
$ ls
Podfile			hacker-news		hacker-news.xcodeproj
```

Run `pod install` to initialize the dependencies of the app:

```

i$ pod install
Analyzing dependencies
Downloading dependencies
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `hacker-news.xcworkspace` for this project from now on.
Pod installation complete! There are 0 dependencies from the Podfile and 0 total pods installed.

[!] The Podfile does not contain any dependencies.

[!] Automatically assigning platform `iOS` with version `13.5` on target `hacker-news` because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.
$ ls
Podfile			Pods			hacker-news.xcodeproj
Podfile.lock		hacker-news		hacker-news.xcworkspace

```

Use XCode IDE to open the `hacker-news.xcworkspace` file.
