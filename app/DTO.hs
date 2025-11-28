module DTO where

data UserType = Sender | Reciever

data User = User {
  username :: String,
  password :: String,
  phone_number :: Integer,
  user_type :: UserType 
}

