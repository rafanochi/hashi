module Util where

import DB (Hub (hubCity), HubConnection (hubConnectionDistance, hubConnectionFromHub, hubConnectionToHub))

instance Eq HubConnection where
  a == b = hubConnectionDistance a == hubConnectionDistance b

instance Ord HubConnection where
  compare a b = compare (hubConnectionDistance a) (hubConnectionDistance b)

-- check if the city is same
(=?) :: Hub -> Hub -> Bool
a =? b = hubCity a == hubCity b

onlyHubs :: [HubConnection] -> [Hub]
onlyHubs [] = []
onlyHubs [x] = [hubConnectionToHub x]
onlyHubs (x : xs) = hubConnectionFromHub x : onlyHubs xs

getPath :: Hub -> HubConnection -> Bool
getPath node edge = 


that :: Hub -> [HubConnection] -> [HubConnection]
that node edges state =  

-- short :: [HubConnection] -> (Hub, Hub) -> [Hub]
-- short edges (from, to) =
--     where
--         that :: Hub -> [HubConnection] -> [HubConnection] -> [Hub]
--         that hub hubcs state = case length $ filter (\y->hubConnectionToHub y =? to) $
--             filter (\x-> hubConnectionFromHub x =? hub) hubcs of
--                 1 -> state
--                 _ ->
