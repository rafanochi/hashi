{-# LANGUAGE CApiFFI #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module FFI where

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BL
import Foreign
import Foreign.C.String
import Foreign.C.Types

foreign import capi "socket.h create_socket"
  c_create_socket :: CInt -> IO CInt

foreign import capi "socket.h recieve_req"
  c_recive :: CInt -> Ptr CChar -> CInt -> IO CInt

foreign import capi "socket.h send_resp"
  c_send :: CInt -> Ptr CChar -> IO CInt

foreign import capi "socket.h run_server"
  c_run_server :: CInt -> IO CInt

foreign import capi "unistd.h close"
  c_close :: CInt -> IO CInt

-- intended to use like: recv sockfd 1024
recv :: CInt -> Int -> IO String
recv sockfd size =
  allocaBytes size $ \buffer -> do
    c_recive sockfd buffer (fromIntegral size)
    peekCStringLen (buffer, fromIntegral size)

send :: CInt -> String -> IO ()
send sockfd msg =
  withCString msg $ \resp -> do
    c_send sockfd resp
    return ()

sendJson :: (ToJSON a) => CInt -> a -> IO ()
sendJson sockfd msg = do
  let str = BL.unpack $ encode msg
  send sockfd str
