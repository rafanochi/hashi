module Handler where

import ADT (User (User))
import Data.Aeson
import FFI (sendJson)
import Foreign.C (CInt)
import Hanekawa (Status (Ok))

createUser :: CInt -> Value -> IO ()
createUser sockfd json = do
  case fromJSON json :: Result User of
    Success user -> sendJson sockfd Ok $ "User created successfully: " ++ show user
    Error msg -> sendJson sockfd Ok $ "Can't parse params: " ++ show msg
