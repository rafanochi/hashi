{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TemplateHaskell #-}

module Types where

import DB (Order, OrderId, User, UserId, Vehicle, VehicleId)
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

data ReplaceOrder = ReplaceOrder
  { oid :: OrderId
  , order :: Order
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)

data ReplaceVehicle = ReplaceVehicle
  { vid :: VehicleId
  , vehicle :: Vehicle
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)
