{-# LANGUAGE TypeApplications #-}

module Handler where

import DB
import Data.Aeson
import Database.Persist.Sql (ConnectionPool, PersistStoreWrite (insert, replace), runSqlPool)
import FFI (sendJson)
import Foreign.C (CInt)
import Hanekawa (Status (Err, Ok))
import Types (ReplaceUser (ReplaceUser, uid, user))

handleRequestError :: CInt -> IO ()
handleRequestError sockfd = do
  let msg = "Wrong Request"
  putStrLn msg
  sendJson sockfd Err msg

createUser :: ConnectionPool -> CInt -> Value -> IO ()
createUser pool sockfd json = do
  case fromJSON @DB.User json of
    Success _user -> do
      _ <- runSqlPool (insert _user) pool
      sendJson sockfd Ok $ "User created successfully: " ++ show _user
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg

replaceUser :: ConnectionPool -> CInt -> Value -> IO ()
replaceUser pool sockfd json = do
  case fromJSON @ReplaceUser json of
    Success ReplaceUser{uid = _uid, user = _user} -> do
      _ <- runSqlPool (replace _uid _user) pool
      sendJson sockfd Ok $ "User updated successfully: " ++ show _user
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg

getUser :: ConnectionPool -> CInt -> Value -> IO ()
getUser pool sockfd json = do
  case fromJSON @ReplaceUser json of
    Success ReplaceUser{uid = _uid, user = _user} -> do
      _ <- runSqlPool (replace _uid _user) pool
      sendJson sockfd Ok $ "User updated successfully: " ++ show _user
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg
