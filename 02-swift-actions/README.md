# ch6-app - 02-SWIFT-ACTIONS
This is the section on building the Serverless Backend explained in Serverless Swift by Apress.

The following steps need to be taken in order to get the Serverless MBaaS working.

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
