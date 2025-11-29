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

import Database.Persist.Sqlite
import Database.Persist.TH
import ADT (UserRole, VehicleType)

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|

Vehicle
  vahicleType VehicleType  
User 
  name String 
  surname String 
  username String
  email String
  password String 
  phoneNumber Int
  role UserRole
  deriving Show
|]
