{-# LANGUAGE DeriveGeneric #-}

module Main where

import Control.Monad
import Data.Aeson
import GHC.Generics
import FFI

data Waifu = Waifu {name :: String, age :: Int} deriving (Show, Generic)
instance FromJSON Waifu
instance ToJSON Waifu

response :: Waifu
response = Waifu{name = "Asuna", age = 18}

main :: IO ()
main = do
  sockfd <- c_create_socket 8081
  forever $ do
    new_sockfd <- c_run_server sockfd
    guard $ (fromIntegral new_sockfd :: Int) >= 0

    msg <- recvJson new_sockfd 1024
    putStrLn msg

    sendJson new_sockfd response

    c_close new_sockfd
