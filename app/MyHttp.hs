module MyHttp where

toHttpResponse :: String -> String
toHttpResponse jsonBody = 
            "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: application/json\r\n" ++
            "Content-Length: " ++ show (length jsonBody) ++ "\r\n" ++
            "\r\n" ++
            jsonBody 
