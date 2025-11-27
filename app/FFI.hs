{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}

module FFI where

import Foreign
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
