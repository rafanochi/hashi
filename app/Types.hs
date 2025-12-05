{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TemplateHaskell #-}

module Types where

import DB (User, UserId)
import Data.Aeson
import Database.Persist.TH
import GHC.Generics

data VehicleType = Light | Medium | Heavy
  deriving stock (Read, Eq, Show, Generic)
  deriving anyclass (FromJSON, ToJSON)
derivePersistField "VehicleType"

data UserRole = Client | Courier
  deriving stock (Read, Eq, Show, Generic)
  deriving anyclass (FromJSON, ToJSON)
derivePersistField "UserRole"

data ReplaceUser = ReplaceUser
  { uid :: UserId
  , user :: User
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)
