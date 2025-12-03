{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

-- Custom ultimately simple Protocol
module Hanekawa where

import Data.Aeson
import GHC.Generics

data Status = Ok | Err
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)

data Response = Response
  { status :: Status
  , result :: Maybe Value
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)

data Request = Request
  { method :: String
  , params :: Maybe Value
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)

class (ToJSON a, FromJSON a) => Hanekawa a where
  wrap :: Maybe a -> Status -> Response
  wrap Nothing s = Response{status = s, result = Nothing}
  wrap (Just res) s = Response{status = s, result = Just (toJSON res)}

  unwrap :: Request -> (String, Maybe a) -- method and params
  unwrap (Request{method = m, params = p}) = case p of
    Nothing -> (m, Nothing)
    Just json -> case fromJSON json of
      Error _ -> (m, Nothing)
      Success x -> (m, Just x)
