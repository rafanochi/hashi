{-# LANGUAGE TypeApplications #-}

module Handler where

import DB
import Data.Aeson
import Database.Persist.Sql (ConnectionPool, PersistStoreRead (get), PersistStoreWrite (delete, insert, replace), runSqlPool, selectList)
import FFI (sendJson)
import Foreign.C (CInt)
import Hanekawa (Status (Err, Ok))
import Types (ReplaceHub (ReplaceHub, hid, hub), ReplaceHubConnection (ReplaceHubConnection, hcid, hcub), ReplaceOrder (ReplaceOrder, oid, order), ReplaceUser (ReplaceUser, uid, user), ReplaceVehicle (ReplaceVehicle, vehicle, vid))

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
      let (fromArea, toArea) = (orderFromArea x, orderToArea x)
      hubs <- runSqlPool (selectList @Hub [] []) pool

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

-------------- Vehicle
createVehicle :: ConnectionPool -> CInt -> Value -> IO ()
createVehicle pool sockfd json = do
  case fromJSON @DB.Vehicle json of
    Success x -> do
      _ <- runSqlPool (insert x) pool
      sendJson sockfd Ok $ "Vehicle created successfully: " ++ show x
    Error msg -> handleParseError sockfd msg

getVehicle :: ConnectionPool -> CInt -> Value -> IO ()
getVehicle pool sockfd json = do
  case fromJSON @VehicleId json of
    Success x -> do
      _order <- runSqlPool (get x) pool
      sendJson sockfd Ok x
    Error msg -> handleParseError sockfd msg

replaceVehicle :: ConnectionPool -> CInt -> Value -> IO ()
replaceVehicle pool sockfd json = do
  case fromJSON @ReplaceVehicle json of
    Success ReplaceVehicle{vid = x, vehicle = y} -> do
      _ <- runSqlPool (replace x y) pool
      sendJson sockfd Ok $ "Vehicle updated successfully: " ++ show y
    Error msg -> handleParseError sockfd msg

deleteVehicle :: ConnectionPool -> CInt -> Value -> IO ()
deleteVehicle pool sockfd json = do
  case fromJSON @VehicleId json of
    Success x -> do
      y <- runSqlPool (delete x) pool
      sendJson sockfd Ok $ show y ++ "Vehicle deleted successfully"
    Error msg -> handleParseError sockfd msg

-------------- Hub
createHub :: ConnectionPool -> CInt -> Value -> IO ()
createHub pool sockfd json = do
  case fromJSON @DB.Hub json of
    Success x -> do
      _ <- runSqlPool (insert x) pool
      sendJson sockfd Ok $ "Hub created successfully: " ++ show x
    Error msg -> handleParseError sockfd msg

getHub :: ConnectionPool -> CInt -> Value -> IO ()
getHub pool sockfd json = do
  case fromJSON @HubId json of
    Success x -> do
      _order <- runSqlPool (get x) pool
      sendJson sockfd Ok x
    Error msg -> handleParseError sockfd msg

replaceHub :: ConnectionPool -> CInt -> Value -> IO ()
replaceHub pool sockfd json = do
  case fromJSON @ReplaceHub json of
    Success ReplaceHub{hid = x, hub = y} -> do
      _ <- runSqlPool (replace x y) pool
      sendJson sockfd Ok $ "Hub updated successfully: " ++ show y
    Error msg -> handleParseError sockfd msg

deleteHub :: ConnectionPool -> CInt -> Value -> IO ()
deleteHub pool sockfd json = do
  case fromJSON @HubId json of
    Success x -> do
      y <- runSqlPool (delete x) pool
      sendJson sockfd Ok $ show y ++ "Hub deleted successfully"
    Error msg -> handleParseError sockfd msg

-------------- HubConnection
createHubConnection :: ConnectionPool -> CInt -> Value -> IO ()
createHubConnection pool sockfd json = do
  case fromJSON @DB.HubConnection json of
    Success x -> do
      _ <- runSqlPool (insert x) pool
      sendJson sockfd Ok $ "HubConnection created successfully: " ++ show x
    Error msg -> handleParseError sockfd msg

getHubConnection :: ConnectionPool -> CInt -> Value -> IO ()
getHubConnection pool sockfd json = do
  case fromJSON @HubConnectionId json of
    Success x -> do
      _order <- runSqlPool (get x) pool
      sendJson sockfd Ok x
    Error msg -> handleParseError sockfd msg

replaceHubConnection :: ConnectionPool -> CInt -> Value -> IO ()
replaceHubConnection pool sockfd json = do
  case fromJSON @ReplaceHubConnection json of
    Success ReplaceHubConnection{hcid = x, hcub = y} -> do
      _ <- runSqlPool (replace x y) pool
      sendJson sockfd Ok $ "HubConnection updated successfully: " ++ show y
    Error msg -> handleParseError sockfd msg

deleteHubConnection :: ConnectionPool -> CInt -> Value -> IO ()
deleteHubConnection pool sockfd json = do
  case fromJSON @HubConnectionId json of
    Success x -> do
      y <- runSqlPool (delete x) pool
      sendJson sockfd Ok $ show y ++ "HubConnection deleted successfully"
    Error msg -> handleParseError sockfd msg
