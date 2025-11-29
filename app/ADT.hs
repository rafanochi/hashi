{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}

module ADT where

import Data.Aeson
import Data.Time
import GHC.Generics
import Database.Persist.TH

data VehicleType = Light | Medium | Heavy deriving (Show, Read, Eq, Generic) 

derivePersistField "VehicleType"
instance FromJSON VehicleType
instance ToJSON VehicleType

data Vehicle = Vehicle
  { vehicle_type :: VehicleType
  , brand :: String
  , model :: String
  , number :: String
  }
  deriving (Show, Generic)
instance FromJSON Vehicle
instance ToJSON Vehicle

data UserRole = Client | Courier deriving (Show, Read, Eq, Generic)

derivePersistField "UserRole"
instance ToJSON UserRole
instance FromJSON UserRole

data User = User
  { name :: String
  , surname :: String
  , username :: String
  , email :: String
  , password :: String
  , phone_number :: String
  , car :: Maybe Vehicle
  , driver_licence :: Maybe Bool
  , role :: UserRole
  }
  deriving (Show, Generic)
instance ToJSON User
instance FromJSON User

data Order = Order
  { address :: String
  , destination :: String
  , client :: User
  , courier :: User
  , volume :: Double
  , mass :: Double
  , time :: Day
  }
  deriving (Show, Generic)
instance ToJSON Order
instance FromJSON Order
