import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session,joinedload
from database import get_db
from middleware.auth_middleware import auth_middleware
import cloudinary
import cloudinary.uploader

from models.favorite import Favorite
from models.song import Song
from pydantic_schemas.favorite_song import FavoriteSong


router = APIRouter();

cloudinary.config( 
    cloud_name = "dgxak96hi", 
    api_key = "541895831188795", 
    api_secret = "8Lm7jki4rAVq9hHK8SqDOfJ5a2c", 
    secure=True
)

@router.post('/upload',status_code=201)
def upload_song(song : UploadFile=File(...),
                song_name : str = Form(...),
                artist : str = Form(...),
                # hex_code : str = Form(...),
                db: Session = Depends(get_db),
                auth_dict = Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file,resource_type='auto',folder=f'songs/{song_id}')
    print(song_res['url'])
    # store data in db
    new_song = Song(
        id=song_id,
        song_name = song_name,
        artist = artist,
        # hex_code = hex_code,
        song_url = song_res['url'],
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db:Session = Depends(get_db),auth_details=Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs


@router.post('/favorite')
def favorite_song(song: FavoriteSong,db:Session = Depends(get_db),auth_details=Depends(auth_middleware)):
    user_id = auth_details['uuid']
    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id,Favorite.user_id == user_id).first()
    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message':False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()),song_id=song.song_id,user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message':True}
    # song is already favorited by the user
    # if already favorite , unfavorite
    # if not  , favorite it 

@router.get('/list/favorites')
def list_fav_songs(db:Session = Depends(get_db),auth_details=Depends(auth_middleware)):
    user_id = auth_details['uuid']
    fav_songs = db.query(Favorite).filter(Favorite.user_id == user_id).options(
        joinedload(Favorite.song)
        ).all()
    return fav_songs