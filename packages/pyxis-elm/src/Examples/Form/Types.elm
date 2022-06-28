module Examples.Form.Types exposing
    ( Claim(..)
    , Insurance(..)
    , Option(..)
    , Vehicles(..)
    )


type Insurance
    = Motor
    | Household


type Claim
    = CarAccident
    | OtherClaims


type Option
    = AcceptPrivacy


type Vehicles
    = Car
    | Motorcycle
    | Van
