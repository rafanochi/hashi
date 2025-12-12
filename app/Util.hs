module Util where

import DB (Hub (hubCity), HubConnection (hubConnectionFromHub, hubConnectionToHub))

instance Ord HubConnection where
  compare a b = compare (hubConnectionDistance a) (hubConnectionDistance b)

-- check if the city is same
(=?) :: Hub -> Hub -> Bool
a =? b = hubCity a == hubCity b

(~) :: [HubConnection] -> [HubConnection] -> [HubConnection]
x ~ y = max x y

short :: [HubConnection] -> (Hub, Hub) -> [Hub]
short edges (from, to) = 
    where 
        that :: Hub -> [HubConnection] -> [HubConnection] -> [Hub]
        that hub hubcs state = case length $ filter (\y->hubConnectionToHub y =? to) $ 
            filter (\x-> hubConnectionFromHub x =? hub) hubcs of
                1 -> state 
                _ -> 
                
