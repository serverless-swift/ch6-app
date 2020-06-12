# ch6-app - 02-SWIFT-ACTIONS
This is the section on building the Serverless Backend explained in Serverless Swift by Apress.

The following steps need to be taken in order to get the Serverless MBaaS working.

- setup for Serverless MBaaS (Mobile Backend as a Service)
  - cloning the code
  - provisioning of the services NLU and Cloudant DB
- creating the package
- creating NLUaction (processing of the url thru Watson NLU)
- GetALLHNewsIds action 
- InsertHNewsIdsCloudant
- creating the sequence
- creating the Cloudant Feed action from the template
- updating the process-change action
- adding NLUaction to the sequence
- creating NLUanalysis2DBaction and adding it to the sequence
- creating GetHNewsNLUanalysis
- adding the parameters for NLU and Cloudant DB



## setup for Serverless MBaaS (Mobile Backend as a Service)
  
  ### cloning the code
Clone this repository with `git` or just download the zip file:  
```
git clone https://github.com/serverless-swift/ch6-app
```
Now setting up and connecting to IBM Cloud:
```
$ ls
01-basic-app		03-nlu-app		README.md
02-swift-actions	LICENSE			image
$ cd 02-swift-actions/
$ ls
GetAllHNewsIds		InsertHNewsIdsCloudant	NLUanalysis2DBaction	process-change
GetHNewsNLUanalysis	NLUaction		ReadHNewsDetails
$ cd NLUaction/
$ ls
Package.swift	Source
$ more Package.swift 
// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Action",
    products: [
    .executable(
        name: "Action",
        targets:  ["Action"]
    )
    ],
    dependencies: [
    .package(url: "https://github.com/IBM-Swift/SwiftyRequest.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "3.4.0")
    ],
    targets: [
    .target(
        name: "Action",
        dependencies: ["SwiftyRequest","NaturalLanguageUnderstandingV1","LanguageTranslatorV3"],
        path: "."
    )
    ]
)
```
Now you are ready to start building your action. Start by logging in to IBM Cloud Functions environment.

```
$ ibmcloud login -a cloud.ibm.com -o "serverless.swift@roboticsinventions.com" -s "dev"
Warning: option -o or -s is deprecated. Use command ibmcloud target -o ORG -s SPACE instead.

API endpoint: https://cloud.ibm.com

Email> serverless.swift@roboticsinventions.com

Password> 
Authenticating...
OK

Targeted account Serverless Marek Lennart's Account (f2778562401f459fba824892c1f2d761)


Select a region (or press enter to skip):
1. au-syd
2. in-che
3. jp-tok
4. kr-seo
5. eu-de
6. eu-gb
7. us-south
8. us-east
Enter a number> 7
Targeted region us-south

Targeted Cloud Foundry (https://api.us-south.cf.cloud.ibm.com)

Targeted org serverless.swift@roboticsinventions.com

Targeted space dev

                      
API endpoint:      https://cloud.ibm.com   
Region:            us-south   
User:              serverless.swift@roboticsinventions.com   
Account:           Serverless Marek Lennart's Account (f2778562401f459fba824892c1f2d761)   
Resource group:    No resource group targeted, use 'ibmcloud target -g RESOURCE_GROUP'   
CF API endpoint:   https://api.us-south.cf.cloud.ibm.com (API version: 2.147.0)   
Org:               serverless.swift@roboticsinventions.com   
Space:             dev   
$ ibmcloud target -g Default
Targeted resource group Default


                      
API endpoint:      https://cloud.ibm.com   
Region:            us-south   
User:              serverless.swift@roboticsinventions.com   
Account:           Serverless Marek Lennart's Account (f2778562401f459fba824892c1f2d761)   
Resource group:    Default   
CF API endpoint:   https://api.us-south.cf.cloud.ibm.com (API version: 2.147.0)   
Org:               serverless.swift@roboticsinventions.com   
Space:             dev   
$ ibmcloud fn list
Entities in namespace: default
packages
actions
triggers
rules
```


### provisioning of the services NLU and Cloudant DB
When provisioning Cloudant DB make sure you would use `IAM and legacy credentials`
Use the respective region `Dallas` was used in the videos.
Create the credentials with `manager` rights. See the video.

### creating the package

Now you create a Openwhisk package:

```
$ ibmcloud fn package create hacker-news-pak
ok: created package hacker-news-pak

$ ibmcloud fn package list
packages
/serverless.swift@roboticsinventions.com_dev/hacker-news-pak           private

```

### creating NLUaction (processing of the url thru Watson NLU)

```
$ zip ../action-src.zip -r *
updating: Package.swift (deflated 48%)
updating: Source/ (stored 0%)
updating: Source/nluAnalyze.swift (deflated 69%)
$ docker run -i openwhisk/action-swift-v4.2 -compile main <../action-src.zip >../action-bin.zip

```

### GetALLHNewsIds action 
### InsertHNewsIdsCloudant
### creating the sequence
### creating the Cloudant Feed action from the template
### updating the process-change action
### adding NLUaction to the sequence
### creating NLUanalysis2DBaction and adding it to the sequence
### creating GetHNewsNLUanalysis
### adding the parameters for NLU and Cloudant DB
