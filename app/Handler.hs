{-# LANGUAGE TypeApplications #-}

module Handler where

import DB
import Data.Aeson
import Database.Persist.Sql (ConnectionPool, PersistStoreRead (get), PersistStoreWrite (delete, insert, replace), runSqlPool)
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

getUser :: ConnectionPool -> CInt -> Value -> IO ()
getUser pool sockfd json = do
  case fromJSON @UserId json of
    Success _uid -> do
      _user <- runSqlPool (get _uid) pool
      sendJson sockfd Ok _user
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg

replaceUser :: ConnectionPool -> CInt -> Value -> IO ()
replaceUser pool sockfd json = do
  case fromJSON @ReplaceUser json of
    Success ReplaceUser{uid = _uid, user = _user} -> do
      _ <- runSqlPool (replace _uid _user) pool
      sendJson sockfd Ok $ "User updated successfully: " ++ show _user
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg

deleteUser :: ConnectionPool -> CInt -> Value -> IO ()
deleteUser pool sockfd json = do
  case fromJSON @UserId json of
    Success _uid -> do
      _user <- runSqlPool (delete _uid) pool
      sendJson sockfd Ok $ show _user ++ " user deleted successfully"
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg
