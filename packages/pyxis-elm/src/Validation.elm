module Validation exposing
    ( Validation
    , fromMaybe
    , fromPredicate
    , map
    )


type alias Validation from to =
    from -> Result String to


fromPredicate : (a -> Bool) -> String -> Validation a a
fromPredicate pred reason x =
    if pred x then
        Ok x

    else
        Err reason


fromMaybe : String -> (a -> Maybe b) -> Validation a b
fromMaybe reason toMaybe src =
    case toMaybe src of
        Nothing ->
            Err reason

        Just x ->
            Ok x


map : (from -> to) -> Validation from to
map f from =
    Ok (f from)
