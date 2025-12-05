{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}

module Types where

import Data.Aeson
import Database.Persist.TH
import GHC.Generics

data VehicleType = Light | Medium | Heavy deriving (Show, Read, Eq, Generic)
derivePersistField "VehicleType"
instance FromJSON VehicleType
instance ToJSON VehicleType

data UserRole = Client | Courier deriving (Show, Read, Eq, Generic)
derivePersistField "UserRole"
instance ToJSON UserRole
instance FromJSON UserRole
