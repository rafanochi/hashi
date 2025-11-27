module Main where

import FFI
import Control.Monad

response :: String
response = "HTTP/1.1 200 OK\r\n\
           \Content-Length: 27\r\n\
           \Content-Type: text/plain\r\n\
           \\r\n\
           \Hello from ASUNA: be gentle..."

main :: IO ()
main = do
  sockfd <- c_create_socket (fromIntegral 8080)
  forever $ do
        new_sockfd <- c_run_server sockfd
        guard (fromIntegral new_sockfd>=0)

        msg <- recv new_sockfd 1024 
        putStrLn msg

        send new_sockfd response

        c_close new_sockfd


