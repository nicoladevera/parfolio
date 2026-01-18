from pydantic import BaseModel
from typing import Optional, List
from enum import Enum

class CareerStage(str, Enum):
    early_career = "early_career"      # 0-3 years
    mid_career = "mid_career"          # 4-10 years
    senior_leadership = "senior_leadership"

class TransitionType(str, Enum):
    same_role_new_company = "same_role_new_company"
    role_change = "role_change"        # e.g., IC → Manager
    industry_change = "industry_change"
    company_type_shift = "company_type_shift"  # Big Tech → Startup

class CompanySize(str, Enum):
    startup = "startup"           # <50 employees
    small = "small"               # 50-500 employees
    medium = "medium"             # 500-5K employees
    enterprise = "enterprise"     # 5K+ employees

class ProfileUpdateRequest(BaseModel):
    current_role: Optional[str] = None
    target_role: Optional[str] = None
    current_industry: Optional[str] = None
    target_industry: Optional[str] = None
    career_stage: Optional[CareerStage] = None
    transition_types: Optional[List[TransitionType]] = None
    profile_photo_url: Optional[str] = None
    current_company: Optional[str] = None
    target_companies: Optional[List[str]] = None
    current_company_size: Optional[CompanySize] = None
    target_company_size: Optional[CompanySize] = None

class ProfileResponse(BaseModel):
    user_id: str
    email: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    display_name: Optional[str] = None
    current_role: Optional[str] = None
    target_role: Optional[str] = None
    current_industry: Optional[str] = None
    target_industry: Optional[str] = None
    career_stage: Optional[CareerStage] = None
    transition_types: Optional[List[TransitionType]] = None
    profile_photo_url: Optional[str] = None
    current_company: Optional[str] = None
    target_companies: Optional[List[str]] = None
    current_company_size: Optional[CompanySize] = None
    target_company_size: Optional[CompanySize] = None
