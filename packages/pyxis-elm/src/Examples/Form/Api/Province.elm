module Examples.Form.Api.Province exposing
    ( Province
    , capitalProvince
    , getName
    , list
    )


type Province
    = Roma
    | Napoli
    | Genova
    | Torino
    | Bologna
    | Bari
    | Palermo
    | Milano
    | Venezia
    | Firenze


list : List Province
list =
    [ Roma
    , Napoli
    , Genova
    , Torino
    , Bologna
    , Bari
    , Palermo
    , Milano
    , Venezia
    , Firenze
    ]


capitalProvince : Province
capitalProvince =
    Roma


getName : Province -> String
getName province =
    case province of
        Roma ->
            "Roma"

        Napoli ->
            "Napoli"

        Genova ->
            "Genova"

        Torino ->
            "Torino"

        Bologna ->
            "Bologna"

        Bari ->
            "Bari"

        Palermo ->
            "Palermo"

        Milano ->
            "Milano"

        Venezia ->
            "Venezia"

        Firenze ->
            "Firenze"
