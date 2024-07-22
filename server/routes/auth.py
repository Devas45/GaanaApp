from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin
import jwt

router = APIRouter()

@router.post('/signup',status_code=201)
def signup_user(user:UserCreate,db:Session=Depends(get_db)):
    #extract the data thats coming from req
    #check if user already exists in db
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(400,'User with same email already exists!')
    
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    #add user to db
    user_db = User(id=str(uuid.uuid4()),email=user.email,password=hashed_pw,name = user.name)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def login_user(user:UserLogin,db:Session=Depends(get_db)):
    # check if a user with same email already exits:
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(400,'Incorrect Email!')
    # if password is matched
    is_match = bcrypt.checkpw(user.password.encode(),user_db.password)
    if not is_match:
        return HTTPException(400,'Incorrect password!')
    token = jwt.encode({'id': user_db.id,},'password_key');

    return {'token':token,'user':user_db}


@router.get('/')
def get_current_user(db:Session=Depends(get_db),user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uuid']).first()
    if not user:
        raise HTTPException(404,'User Not Found!')
    return user