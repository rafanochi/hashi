module Handler where

import FFI (sendJson)
import Foreign.C (CInt)
import Hanekawa (Status (Ok))

createUser :: CInt -> IO ()
createUser sockfd = sendJson sockfd Ok "User created successfully!"
