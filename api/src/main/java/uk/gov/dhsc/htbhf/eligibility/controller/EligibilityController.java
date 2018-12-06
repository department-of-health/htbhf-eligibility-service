package uk.gov.dhsc.htbhf.eligibility.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import uk.gov.dhsc.htbhf.eligibility.model.EligibilityRequest;
import uk.gov.dhsc.htbhf.eligibility.model.EligibilityResponse;

import java.util.Collections;

import static java.util.Collections.singletonList;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;
import static uk.gov.dhsc.htbhf.eligibility.model.Decision.ELIGIBLE;

/**
 * Responsible for obtaining a decision on eligibility from downstream services, sending the application to the claimant service
 * and returning the eligibility result.
 */
@Controller
@Slf4j
public class EligibilityController {

    /**
     * Invokes downstream services to obtain a decision on eligibility for the given request,
     * persists the request and decision with the claimant service.
     *
     * @param request the {@link EligibilityRequest}
     * @return the {@link EligibilityResponse}
     */
    @PostMapping(path = "/eligibility", consumes = APPLICATION_JSON_VALUE, produces = APPLICATION_JSON_VALUE)
    @ResponseBody
    public EligibilityResponse getDecision(@RequestBody EligibilityRequest request) {
        return EligibilityResponse.builder()
                .decision(ELIGIBLE)
                .build();
    }

}
