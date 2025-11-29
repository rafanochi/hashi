{-# LANGUAGE DeriveGeneric #-}

module MyProtocol where

import Data.Aeson
import GHC.Generics

data Status = Ok | Error deriving (Show, Generic)
instance FromJSON Status
instance ToJSON Status

data Response = Response
  { status :: Status
  , result :: Maybe Value
  }
  deriving (Show, Generic)
instance FromJSON Response
instance ToJSON Response

data Request = Request
  { method :: String
  , json :: Maybe Value
  }
  deriving (Show, Generic)
instance FromJSON Request
instance ToJSON Request
