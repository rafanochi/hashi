module Main where

import FFI
import Control.Monad

main :: IO ()
main = do
  sockfd <- c_create_socket (fromIntegral 8080)
  let loop = do
        new_sockfd <- c_run_server sockfd
        c_close new_sockfd
        when (1==1) loop
  loop

