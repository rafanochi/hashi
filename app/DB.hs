{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

module DB where

import Data.Aeson
import Data.Time
import Database.Persist.Sqlite
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

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|

Vehicle json
  vehicleType VehicleType  
  brand String
  model String
  number String
  deriving Show

User json
  name String 
  surname String 
  username String
  email String
  password String 
  phoneNumber String
  role UserRole
  car VehicleId Maybe 
  driver_licence Bool Maybe
  deriving Show

Order json 
  address String
  destination String
  client UserId
  courier UserId
  volume Double 
  mass Double
  time Day
  deriving Show

Hub json
  address String
  city String
  deriving Show

HubConnection json
  fromHub HubId
  toId HubId
  distance Double
  deriving Show
|]
