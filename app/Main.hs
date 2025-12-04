{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Main where

import Control.Monad
import Data.Aeson
import FFI
import GHC.Generics
import Hanekawa (Hanekawa)

data Waifu = Waifu
  { name :: String
  , age :: Int
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON, Hanekawa)

response :: Waifu
response = Waifu{name = "Asuna", age = 18}

main :: IO ()
main = do
  sockfd <- c_create_socket 8081
  forever $ do
    new_sockfd <- c_run_server sockfd
    guard $ (fromIntegral new_sockfd :: Int) >= 0

    msg <- recvJson new_sockfd 1024
    print msg

    sendJson new_sockfd response

    c_close new_sockfd
