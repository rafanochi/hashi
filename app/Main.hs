module Main where

import FFI

main :: IO ()
main = do
  c_create_socket (fromIntegral 8080)
  return ()
