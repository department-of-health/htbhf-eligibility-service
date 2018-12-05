package uk.gov.dhsc.htbhf.eligibility

import com.jayway.restassured.response.Response
import groovy.transform.CompileStatic
import org.skyscreamer.jsonassert.JSONAssert
import org.skyscreamer.jsonassert.JSONCompareMode
import spock.lang.Specification

import static com.jayway.restassured.RestAssured.given
import static com.jayway.restassured.config.LogConfig.logConfig
import static com.jayway.restassured.config.RestAssuredConfig.newConfig

class NewApplicantSpec extends Specification {

    @CompileStatic
    def request() {
        given()
                .config(newConfig().logConfig(logConfig().enableLoggingOfRequestAndResponseIfValidationFails()))
                .baseUri(System.getenv("BASE_URL"))
                .contentType("application/json")
    }

    def "New applicant is eligible"() {

        given: "A request that will in future contain applicant details"
        def requestBody = "{}"

        when: "The request is received by the REST api"
        Response response = request().body(requestBody).post("/eligibility")


        then: "The response should indicate that the applicant is eligible"
        response.statusCode() == 200
        JSONAssert.assertEquals('{"decision":"ELIGIBLE"}', response.body().asString(), JSONCompareMode.LENIENT)
    }

}
