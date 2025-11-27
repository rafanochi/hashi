{-# LANGUAGE ForeignFunctionInterface #-}

import Foreign
import Foreign.C.Types

foreign import ccall "sys/socket.h socket"
  c_socket :: CInt -> CInt -> CInt -> CInt


