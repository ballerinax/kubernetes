import ballerina/http;
import ballerina/knative;
import ballerina/log;

//Add the `@knative:Service` to a Ballerina service to generate a Knative Service artifact and push the docker image to docker hub
@knative:Service {
    //Enable pushing the docker image.
    push: true,
    //Set the name of the docker image.
    name: "hello-world-knative",
    //Sets username credential to push the docker image using `DOCKER_USERNAME` environment  variable.
    username: "$env{DOCKER_USERNAME}",
    //Sets password credential to push the docker image using `DOCKER_PASSWORD` environment  variable.
    password: "$env{DOCKER_PASSWORD}",
    //Setting the registry url.
    registry: "index.docker.io/$env{DOCKER_USERNAME}"
}
@http:ServiceConfig {
    basePath: "/*"
}
service helloWorld on new http:Listener(8080) {
    @http:ResourceConfig {
        path: "/*"
    }
    resource function sayHello(http:Caller outboundEP, http:Request request) {
        http:Response response = new;
        response.setTextPayload("Hello, World from service helloWorld ! \n");
        var responseResult = outboundEP->respond(response);
        if (responseResult is error) {
            log:printError("error responding back to client.", responseResult);
        }
    }
}