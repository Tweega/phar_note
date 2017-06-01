module PharNoteApp.Utils exposing (..)


first : List a -> Maybe a
first list =
    case list of
        first_item :: _ ->
            Just first_item

        [] ->
            Nothing
