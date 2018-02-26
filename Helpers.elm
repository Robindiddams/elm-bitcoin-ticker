module Helpers exposing (..)

import Json.Decode exposing (..)
import List exposing (..)
import String

parse : String-> String
parse str = 
    case decodeString (field "price" string) str of
        Err msg ->
            "------.--"
        
        Ok value ->
            value


appendToEnd : a -> List a -> List a
appendToEnd a list = 
    reverse ( a :: (reverse list) )


-- appends at end of array, if the array length > 4 then it will pop one off the front
addPrice :  List Float -> Float -> List Float
addPrice prices price = 
    if length prices < 5 
        then appendToEnd price prices
        else case tail ( appendToEnd price prices ) of
            
            Nothing ->
            -- this will never happen
                prices

            Just list ->
                list


safelyConcatList : List Float -> String -> List Float
safelyConcatList list a = 
    case String.toFloat a of
        Err msg ->
            list

        Ok f ->
           addPrice list f

average : List Float -> Float
average list = 
    ( foldr (+) 0 list ) / toFloat ( length list )
