from pydantic import BaseModel, EmailStr, Field, ConfigDict
from typing import Optional, List
from datetime import datetime

class UserRegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)
    first_name: str
    last_name: str
    current_role: Optional[str] = None

class UserLoginRequest(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    user_id: str
    email: str
    display_name: Optional[str] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    current_role: Optional[str] = None
    target_role: Optional[str] = None
    current_industry: Optional[str] = None
    target_industry: Optional[str] = None
    career_stage: Optional[str] = None
    transition_types: Optional[List[str]] = None
    profile_photo_url: Optional[str] = None
    current_company: Optional[str] = None
    target_companies: Optional[List[str]] = None
    current_company_size: Optional[str] = None
    target_company_size: Optional[str] = None

    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

class TokenResponse(BaseModel):
    token: str
    user: UserResponse
