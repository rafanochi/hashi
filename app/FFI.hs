{-# LANGUAGE CApiFFI #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module FFI where

import Data.Aeson
import qualified Data.ByteString as BS
import qualified Data.ByteString as Bl
import qualified Data.ByteString.Lazy.Char8 as BL
import Foreign
import Foreign.C.String
import Foreign.C.Types
import Hanekawa (Request, Status, wrap)

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
    _ <- c_recive sockfd buffer (fromIntegral size)
    peekCStringLen (buffer, fromIntegral size)

send :: CInt -> String -> IO ()
send sockfd msg =
  withCString msg $ \resp -> do
    _ <- c_send sockfd resp
    return ()

sendJson :: (ToJSON a) => CInt -> Status -> a -> IO ()
sendJson sockfd s msg = do
  let str = BL.unpack $ encode $ wrap s (Just msg)
  send sockfd str

recvJson :: CInt -> Int -> IO (Maybe Request)
recvJson sockfd size =
  allocaBytes size $ \buffer -> do
    recieved_byte_size <- c_recive sockfd buffer (fromIntegral size)
    bs <- BS.packCStringLen (buffer, fromIntegral recieved_byte_size)
    let lazyBS = Bl.fromStrict bs
    return $ decode lazyBS
