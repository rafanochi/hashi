{-# LANGUAGE TypeApplications #-}

module Handler where

import DB
import Data.Aeson
import Database.Persist.Sql (ConnectionPool, PersistStoreRead (get), PersistStoreWrite (delete, insert, replace), runSqlPool)
import FFI (sendJson)
import Foreign.C (CInt)
import Hanekawa (Status (Err, Ok))
import Types (ReplaceOrder (ReplaceOrder, oid, order), ReplaceUser (ReplaceUser, uid, user))

handleError :: CInt -> String -> IO ()
handleError sockfd = sendJson sockfd Err

handleRequestError :: CInt -> IO ()
handleRequestError sockfd = handleError sockfd "Wrong Request"

handleParseError :: (Show a) => CInt -> a -> IO ()
handleParseError sockfd msg = handleError sockfd $ "Can't parse params: " ++ show msg

------------ USER
createUser :: ConnectionPool -> CInt -> Value -> IO ()
createUser pool sockfd json = do
  case fromJSON @DB.User json of
    Success _user -> do
      _ <- runSqlPool (insert _user) pool
      sendJson sockfd Ok $ "User created successfully: " ++ show _user
    Error msg -> handleParseError sockfd msg

getUser :: ConnectionPool -> CInt -> Value -> IO ()
getUser pool sockfd json = do
  case fromJSON @UserId json of
    Success x -> do
      y <- runSqlPool (get x) pool
      sendJson sockfd Ok y
    Error msg -> handleParseError sockfd msg

replaceUser :: ConnectionPool -> CInt -> Value -> IO ()
replaceUser pool sockfd json = do
  case fromJSON @ReplaceUser json of
    Success ReplaceUser{uid = x, user = y} -> do
      _ <- runSqlPool (replace x y) pool
      sendJson sockfd Ok $ "User updated successfully: " ++ show y
    Error msg -> handleParseError sockfd msg

deleteUser :: ConnectionPool -> CInt -> Value -> IO ()
deleteUser pool sockfd json = do
  case fromJSON @UserId json of
    Success x -> do
      y <- runSqlPool (delete x) pool
      sendJson sockfd Ok $ show y ++ " user deleted successfully"
    Error msg -> handleParseError sockfd msg

-------------- ORDER
createOrder :: ConnectionPool -> CInt -> Value -> IO ()
createOrder pool sockfd json = do
  case fromJSON @DB.Order json of
    Success x -> do
      _ <- runSqlPool (insert x) pool
      sendJson sockfd Ok $ "Order created successfully: " ++ show x
    Error msg -> handleParseError sockfd msg

getOrder :: ConnectionPool -> CInt -> Value -> IO ()
getOrder pool sockfd json = do
  case fromJSON @OrderId json of
    Success x -> do
      _order <- runSqlPool (get x) pool
      sendJson sockfd Ok x
    Error msg -> handleParseError sockfd msg

replaceOrder :: ConnectionPool -> CInt -> Value -> IO ()
replaceOrder pool sockfd json = do
  case fromJSON @ReplaceOrder json of
    Success ReplaceOrder{oid = x, order = y} -> do
      _ <- runSqlPool (replace x y) pool
      sendJson sockfd Ok $ "Order updated successfully: " ++ show y
    Error msg -> handleParseError sockfd msg

deleteOrder :: ConnectionPool -> CInt -> Value -> IO ()
deleteOrder pool sockfd json = do
  case fromJSON @OrderId json of
    Success x -> do
      y <- runSqlPool (delete x) pool
      sendJson sockfd Ok $ show y ++ "Order deleted successfully"
    Error msg -> handleParseError sockfd msg
