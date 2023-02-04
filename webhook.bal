import ballerina/log;
import wso2/choreo.sendemail;
import wso2/choreo.sendsms;
import ballerinax/trigger.github;
import ballerina/http;

configurable string toMobileNo = ?;
configurable string toEmail = ?;
configurable github:ListenerConfig config = ?;

listener http:Listener httpListener = new (8090);
listener github:Listener webhookListener = new (config, httpListener);

service github:IssuesService on webhookListener {

    remote function onOpened(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onClosed(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onReopened(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onAssigned(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onUnassigned(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
    remote function onLabeled(github:IssuesEvent payload) returns error? {
        //Not Implemented
        github:Label? label = payload.label;
        if label is github:Label && label.name == "bug" {

            sendemail:Client sendemailEndpoint = check new ();
            sendsms:Client sendsmsEndpoint = check new ();

            string subject = "Bug reported: " + payload.issue.title;
            string messageBody = "A bug has been reported. Please check " + payload.issue.html_url;
            string sendEmailResponse = check sendemailEndpoint->sendEmail(body = messageBody, subject = subject, recipient = toEmail);
            string sendSmsResponse = check sendsmsEndpoint->sendSms(toMobile = toMobileNo, message = subject);

            log:printInfo("Email sent " + sendEmailResponse);
            log:printInfo("SMS sent " + sendSmsResponse);
        } else {

        }
    }
    remote function onUnlabeled(github:IssuesEvent payload) returns error? {
        //Not Implemented
    }
}

service /ignore on httpListener {
}
