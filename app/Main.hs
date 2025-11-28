{-# LANGUAGE DeriveGeneric #-}
module Main where

import FFI
import Control.Monad
import Data.Aeson
import GHC.Generics

data Waifu = Waifu {name::String, age::Int} deriving (Show, Generic)
instance FromJSON Waifu
instance ToJSON Waifu

response :: Waifu
response = Waifu {name="Asuna", age=18} 

main :: IO ()
main = do
  sockfd <- c_create_socket (fromIntegral 8080)
  forever $ do
        new_sockfd <- c_run_server sockfd
        guard (fromIntegral new_sockfd>=0)

        msg <- recv new_sockfd 1024 
        putStrLn msg 

        sendJson new_sockfd response

        c_close new_sockfd


