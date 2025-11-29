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

import ADT (UserRole, VehicleType)
import Data.Time
import Database.Persist.Sqlite
import Database.Persist.TH

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|

Vehicle
  vahicleType VehicleType  
  brand String
  model String
  number String
  deriving Show

User 
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

Order 
  address String
  destination String
  client UserId
  courier UserId
  volume Double 
  mass Double
  time Day
  deriving Show
|]
