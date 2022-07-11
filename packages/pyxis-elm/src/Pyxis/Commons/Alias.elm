module Pyxis.Commons.Alias exposing (ErrorMessage, Href, Id, IsSubmitted, Name, Validation)


type alias IsSubmitted =
    Bool


type alias Validation validationData value parsedValue =
    validationData -> value -> Result ErrorMessage parsedValue


type alias Name =
    String


type alias Id =
    String


type alias ErrorMessage =
    String


type alias Href =
    String
