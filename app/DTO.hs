module DTO where

import Data.Time

data VehicleType = Light | Medium | Heavy

data Vehicle = Vehicle
  { vehicle_type :: VehicleType
  , brand :: String
  , model :: String 
  , number :: String
  }

data User
  = Client
      { name :: String
      , surname :: String
      , username :: String
      , email :: String
      , password :: String
      , phone_number :: Integer
      }
  | Courier
      { name :: String
      , surname :: String
      , username :: String
      , email :: String
      , password :: String
      , phone_number :: Integer
      , car :: Vehicle
      , driver_licence :: Bool
      }

data Order = Order
  { address :: String
  , destination :: String
  , client :: User
  , courier :: User
  , voulme :: Double
  , mass :: Double
  , time :: Day 
  }
