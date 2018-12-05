package uk.gov.dhsc.htbhf.eligibility.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor(onConstructor = @__(@JsonCreator))
public class EligibilityRequest {
    private String name;
}
