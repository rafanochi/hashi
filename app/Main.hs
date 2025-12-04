{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Main where

import Control.Monad
import Data.Aeson
import FFI
import Foreign.C (CInt)
import GHC.Generics
import Hanekawa (Request (method), Status (Err, Ok))
import Handler (createUser)

data Waifu = Waifu
  { name :: String
  , age :: Int
  }
  deriving stock (Show, Generic)
  deriving anyclass (FromJSON, ToJSON)

response :: Waifu
response = Waifu{name = "Asuna", age = 18}

handleRequestError :: CInt -> IO ()
handleRequestError sockfd = do
  let msg = "Wrong Request"
  putStrLn msg
  sendJson sockfd Err msg

handleRequest :: CInt -> Maybe Request -> IO ()
handleRequest sockfd Nothing = handleRequestError sockfd
handleRequest sockfd (Just req) = case method req of
  "createUser" -> createUser sockfd
  _ -> handleRequestError sockfd

main :: IO ()
main = do
  sockfd <- c_create_socket 8080
  forever $ do
    new_sockfd <- c_run_server sockfd
    guard $ (fromIntegral new_sockfd :: Int) >= 0

    maybeReq <- recvJson new_sockfd 1024
    print maybeReq

    handleRequest new_sockfd maybeReq

    c_close new_sockfd
