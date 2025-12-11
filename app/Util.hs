module Util where

import DB (Hub (hubCity), HubConnection (hubConnectionFromHub, hubConnectionToHub))

-- check if the city is same
(=?=) :: Hub -> Hub -> Bool
a =?= b = hubCity a == hubCity b

short :: [HubConnection] -> (Hub, Hub) -> [Hub]
short edges (from, to) =
  (filter (\x -> hubConnectionFromHub x =?= from) edges)
