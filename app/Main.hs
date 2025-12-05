{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Control.Monad.Logger (runStdoutLoggingT)
import DB (migrateAll)
import Data.Aeson
import Database.Persist.Sql (runMigration, runSqlPool)
import Database.Persist.Sqlite (createSqlitePool)
import FFI
import GHC.Generics
import Router (router)

main :: IO ()
main = do
  sockfd <- c_create_socket 8080
  pool <- runStdoutLoggingT $ createSqlitePool "hashi.db" 10
  runSqlPool (runMigration migrateAll) pool

  forever $ do
    new_sockfd <- c_run_server sockfd
    guard $ (fromIntegral new_sockfd :: Int) >= 0

    maybeReq <- recvJson new_sockfd 1024
    print maybeReq

    router pool new_sockfd maybeReq

    c_close new_sockfd
