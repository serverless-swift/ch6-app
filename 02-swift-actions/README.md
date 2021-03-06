# ch6-app - 02-SWIFT-ACTIONS
This is the section on building the Serverless Backend explained in Serverless Swift by Apress.

[Check this video documenting the first part of compiling and setting up the mobile backend](https://youtu.be/0G3ji8RouKA)

[This is the second part documenting creating a cloudant trigger from a template, and adding parameters to actions](https://youtu.be/FYolLFvIsSc)

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

## creating the package

Now you create a Openwhisk package:

```
$ ibmcloud fn package create hacker-news-pak
ok: created package hacker-news-pak

$ ibmcloud fn package list
packages
/serverless.swift@roboticsinventions.com_dev/hacker-news-pak           private

```

## creating NLUaction (processing of the url thru Watson NLU)

```
$ zip ../action-src.zip -r *
updating: Package.swift (deflated 48%)
updating: Source/ (stored 0%)
updating: Source/nluAnalyze.swift (deflated 69%)
$ docker run -i openwhisk/action-swift-v4.2 -compile main <../action-src.zip >../action-bin.zip
$ ibmcloud fn action update hacker-news-pak/NLUaction ../action-bin.zip --kind swift:4.2
ok: updated action hacker-news-pak/NLUaction
$ ibmcloud fn action invoke hacker-news-pak/NLUaction --blocking
ok: invoked /_/hacker-news-pak/NLUaction with id a86f20f71d23402baf20f71d23202b04
{
    "activationId": "a86f20f71d23402baf20f71d23202b04",
    "annotations": [
        {
            "key": "path",
            "value": "serverless.swift@roboticsinventions.com_dev/hacker-news-pak/NLUaction"
        },
        {
            "key": "waitTime",
            "value": 433
        },
        {
            "key": "kind",
            "value": "swift:4.2"
        },
        {
            "key": "timeout",
            "value": false
        },
        {
            "key": "limits",
            "value": {
                "concurrency": 1,
                "logs": 10,
                "memory": 256,
                "timeout": 60000
            }
        },
        {
            "key": "initTime",
            "value": 66
        }
    ],
    "duration": 75,
    "end": 1591943192774,
    "logs": [],
    "name": "NLUaction",
    "namespace": "serverless.swift@roboticsinventions.com_dev",
    "publish": false,
    "response": {
        "result": {
            "error": "The action did not return a dictionary."
        },
        "size": 52,
        "status": "action developer error",
        "success": false
    },
    "start": 1591943192699,
    "subject": "serverless.swift@roboticsinventions.com",
    "version": "0.0.1"
}

```

Congratulations! That finishes the setup of NLUaction. 

## GetALLHNewsIds action 

Let's get all the Ids from Hacker News. Follow the steps below:

```
$ cd ../GetAllHNewsIds/
$ ls
Package.swift	Source
$ zip - -r * | docker run -i openwhisk/action-swift-v4.2 -compile main >../action.zip
  adding: Package.swift (deflated 51%)
  adding: Source/ (stored 0%)
  adding: Source/GetAllHNewsIds.swift (deflated 50%)
$ ibmcloud fn action update hacker-news-pak/getAllHNewsIds ../action.zip --kind swift:4.2
ok: updated action hacker-news-pak/getAllHNewsIds
$ ibmcloud fn action invoke hacker-news-pak/getAllHNewsIds --blocking
ok: invoked /_/hacker-news-pak/getAllHNewsIds with id c0f1ba655feb490fb1ba655feb990f75
{
    "activationId": "c0f1ba655feb490fb1ba655feb990f75",
    "annotations": [
        {
            "key": "path",
            "value": "serverless.swift@roboticsinventions.com_dev/hacker-news-pak/getAllHNewsIds"
        },
        {
            "key": "waitTime",
            "value": 395
        },
        {
            "key": "kind",
            "value": "swift:4.2"
        },
        {
            "key": "timeout",
            "value": false
        },
        {
            "key": "limits",
            "value": {
                "concurrency": 1,
                "logs": 10,
                "memory": 256,
                "timeout": 60000
            }
        },
        {
            "key": "initTime",
            "value": 91
        }
    ],
    "duration": 1855,
    "end": 1591943495489,
    "logs": [],
    "name": "getAllHNewsIds",
    "namespace": "serverless.swift@roboticsinventions.com_dev",
    "publish": false,
    "response": {
        "result": {
            "newsIds": [
                23494366,
                23490367,
                23495052,
                23496083,
                23491940,
                23495084,
                23476062,
                [about 500 rows]
                23474542,
                23496090
            ]
        },
        "size": 3191,
        "status": "success",
        "success": true
    },
    "start": 1591943493634,
    "subject": "serverless.swift@roboticsinventions.com",
    "version": "0.0.1"
}

```

Congratulations! You have added the GetALLHNewsIds action.

## InsertHNewsIdsCloudant

Now you are ready to add the bulk insert to Cloudant DB.

```
$ cd ../InsertHNewsIdsCloudant/
$ zip - -r * | docker run -i openwhisk/action-swift-v4.2 -compile main >../action.zip
  adding: Package.swift (deflated 53%)
  adding: Source/ (stored 0%)
  adding: Source/InsertHNewsIdsCloudant.swift (deflated 55%)
$ ibmcloud fn action update hacker-news-pak/insertHNewsIdsCloudant ../action.zip --kind swift:4.2
ok: updated action hacker-news-pak/insertHNewsIdsCloudant
$ ibmcloud fn action invoke hacker-news-pak/insertHNewsIdsCloudant --blocking
ok: invoked /_/hacker-news-pak/insertHNewsIdsCloudant, but the request has not yet finished, with id 42bf45f15e4a4bc1bf45f15e4a2bc1c6
```
Congratulations! That finishes the setup of InsertHNewsIdsCloudant

## creating the sequence

As soon as you have created the initial actions you are ready to create the sequence to populate the db with all the needed IDs. Running this action will start the Fanning Out pattern.

```
$ ibmcloud fn action create hacker-news-pak/analyzeTopHNewsSequence --sequence hacker-news-pak/getAllHNewsIds,hacker-news-pak/insertHNewsIdsCloudant
ok: created action hacker-news-pak/analyzeTopHNewsSequence
```
Congratulations! That finishes the setup of InsertHNewsIdsCloudant

## creating the Cloudant Feed action from the template

Creating the Cloudant Feed action requires you to use quick start templates, and to choose the Cloudant based actions. Set the language to Swift 4.2.

Select the table, the provisioned credentials.

### updating the process-change action

The default action from the template is not usable for us (it is checking the color of cats, you know :-) )
So you need to update it.

Use your CLI to do it:
```
$ cd ..
$ cd 02-swift-actions/process-change/
$ zip - -r * | docker run -i openwhisk/action-swift-v4.2 -compile main >../action.zip
  adding: Package.swift (deflated 51%)
  adding: Source/ (stored 0%)
  adding: Source/process-change.swift (deflated 55%)
$ ibmcloud fn action update cloudant-events/process-change ../action.zip --kind swift:4.2
ok: updated action cloudant-events/process-change
```

Congratulations! You have modified action and you are ready to add two additional services to the Cloudant feed

### adding NLUaction to the sequence

Use UI to add the NLUaction action to the Cloudant sequence.

### creating NLUanalysis2DBaction and adding it to the sequence

```
$ cd ../NLUanalysis2DBaction/
Mareks-MBP:NLUanalysis2DBaction mareksadowski$ zip - -r * | docker run -i openwhisk/action-swift-v4.2 -compile main >../action.zip
  adding: Package.swift (deflated 53%)
  adding: Source/ (stored 0%)
  adding: Source/NLUanalysis2DBaction.swift (deflated 57%)
Mareks-MBP:NLUanalysis2DBaction mareksadowski$ ibmcloud fn action update hacker-news-pak/NLUanalysis2DBaction ../action.zip --kind swift:4.2
ok: updated action hacker-news-pak/NLUanalysis2DBaction
```

When done use UI to add the NLUanalysis2DBaction action to the Cloudant sequence.

## creating GetHNewsNLUanalysis

```
$ cd ../GetHNewsNLUanalysis/
$ zip - -r * | docker run -i openwhisk/action-swift-v4.2 -compile main >../action.zip
  adding: Package.swift (deflated 53%)
  adding: Source/ (stored 0%)
  adding: Source/GetHNewsNLUanalysis.swift (deflated 63%)
$ ibmcloud fn action update hacker-news-pak/GetHNewsNLUanalysis ../action.zip --kind swift:4.2
ok: updated action hacker-news-pak/GetHNewsNLUanalysis
   
   ```

## adding the parameters for NLU and Cloudant DB

Check if everything is done. Validate actions within the package:

```
$ ibmcloud fn package get --summary hacker-news-pak
package /serverless.swift@roboticsinventions.com_dev/hacker-news-pak
   (parameters: none defined)
 action /serverless.swift@roboticsinventions.com_dev/hacker-news-pak/GetHNewsNLUanalysis
   (parameters: none defined)
 action /serverless.swift@roboticsinventions.com_dev/hacker-news-pak/NLUanalysis2DBaction
   (parameters: none defined)
 action /serverless.swift@roboticsinventions.com_dev/hacker-news-pak/analyzeTopHNewsSequence
   (parameters: none defined)
 action /serverless.swift@roboticsinventions.com_dev/hacker-news-pak/insertHNewsIdsCloudant
   (parameters: none defined)
 action /serverless.swift@roboticsinventions.com_dev/hacker-news-pak/getAllHNewsIds
   (parameters: none defined)
 action /serverless.swift@roboticsinventions.com_dev/hacker-news-pak/NLUaction
   (parameters: none defined)
```

Last thing to do is to add credentials used in your actions in the respective actions:

- NLU requires setting up the following credentials - it is required only here: hacker-news-pak/NLUaction (use the parameter section of the action UI):

```
NLU
apiKey: "my api key"
serviceURL: "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com/instances/<some instance number>"
```
See the screenshot:

![](../image/nluCredentials.png)

- actions that use DB (for reading or wrting) need these:
```
dbUsername: <some key ending with -bluemix or not>
dbPassword: <password available for the legacy Cloudant DB deployments - choose IAM and legacy credentials at setup! >
cloudantURL: https://<user:password@instance setup - the link is available in the created credentials: >.cloudantnosqldb.appdomain.cloud
```
I added those to the following actions (the parameter section of the action UI):
- hacker-news-pak/GetHNewsNLUanalysis
- hacker-news-pak/NLUanalysis2DBaction
- hacker-news-pak/insertHNewsIdsCloudant
