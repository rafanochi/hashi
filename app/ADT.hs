{-# LANGUAGE DeriveGeneric #-}

module ADT where

import Data.Aeson
import Data.Time
import GHC.Generics

data VehicleType = Light | Medium | Heavy deriving (Show, Generic)
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
  deriving (Show, Generic)
instance ToJSON User
instance FromJSON User

data Order = Order
  { address :: String
  , destination :: String
  , client :: User
  , courier :: User
  , voulme :: Double
  , mass :: Double
  , time :: Day
  }
  deriving (Show, Generic)
instance ToJSON Order
instance FromJSON Order
