module Router where

import Database.Persist.Sql (ConnectionPool)
import Foreign.C (CInt)
import Handler (createUser, deleteUser, getUser, handleRequestError, replaceUser)
import Hanekawa (Request (method, params))

router :: ConnectionPool -> CInt -> Maybe Request -> IO ()
router _ sockfd Nothing = handleRequestError sockfd
router pool sockfd (Just req) = case (method req, params req) of
  ("createUser", Just ps) -> createUser pool sockfd ps
  ("getUser", Just ps) -> getUser pool sockfd ps
  ("replaceUser", Just ps) -> replaceUser pool sockfd ps
  ("deleteUser", Just ps) -> deleteUser pool sockfd ps
  _ -> handleRequestError sockfd
