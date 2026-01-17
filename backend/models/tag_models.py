from enum import Enum
from typing import List

class CompetencyTag(str, Enum):
    LEADERSHIP = "Leadership"
    OWNERSHIP = "Ownership"
    IMPACT = "Impact"
    COMMUNICATION = "Communication"
    CONFLICT = "Conflict"
    STRATEGIC_THINKING = "Strategic Thinking"
    EXECUTION = "Execution"
    ADAPTABILITY = "Adaptability"
    FAILURE = "Failure"
    INNOVATION = "Innovation"

    @classmethod
    def list_values(cls) -> List[str]:
        return [tag.value for tag in cls]
