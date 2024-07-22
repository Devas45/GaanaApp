from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    try:
        #get the token from the headers
        if not x_auth_token:
            raise HTTPException(401,'Unauthorised Token!')
        #decode the token
        verified_token = jwt.decode(x_auth_token,'password_key',['HS256'])
        if not verified_token:
            raise HTTPException(401,'Token not verified,Authorisation Failed!!')
        print(verified_token)
        #get the id from the token
        uuid = verified_token['id']
        return {'uuid':uuid,'token':x_auth_token}
        #get the data from postgres
    except jwt.PyJWKError :
        raise HTTPException(401,'Token is not valid,Authorisation Failed!')