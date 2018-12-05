package uk.gov.dhsc.htbhf.eligibility.controller


import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.boot.web.server.LocalServerPort
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import spock.lang.Specification
import uk.gov.dhsc.htbhf.eligibility.model.Decision
import uk.gov.dhsc.htbhf.eligibility.model.EligibilityRequest
import uk.gov.dhsc.htbhf.eligibility.model.EligibilityResponse

import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT

@SpringBootTest(webEnvironment = RANDOM_PORT)
class NewApplicantSpec extends Specification {

    @LocalServerPort
    int port

    @Autowired
    TestRestTemplate restTemplate

    String endpointUrl = "/eligibility"

    def "New applicant is eligible"() {

        given: "A request that will in future contain applicant details"
        def request = EligibilityRequest.builder().build()

        when: "The request is received by the REST api"
        ResponseEntity<EligibilityResponse> response = restTemplate.postForEntity(endpointUrl, request, EligibilityResponse.class)

        then: "The response should indicate that the applicant is eligible"
        response.statusCode == HttpStatus.OK
        response.body != null
        response.body.decision == Decision.ELIGIBLE

    }
}