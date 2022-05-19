## @pyxis/elm

Pyxis' components in Elm.

_Disclaimer: this package is highly opinionated._

_Disclaimer 2: we're aware that Elm doesn't have components but only modules.
We'll refer to components in order to keep consistency with @pyxis/react._

---

## Table of contents

1. [Setup](#setup)
2. [Structure](#structure)
3. [Requiring a component](#requiring-a-component)
4. [Dictionary](#dictionary)
5. [Stateless components usage](#stateless-components-usage)
6. [Stateful components usage](#stateful-components-usage)
7. [Real application example](#real-application-example)
8. [Documentation](#documentation)

---

### Setup

**Prerequisite**: having `@pyxis/scss` installed. This package relies on SCSS/CSS core in order to properly work.

Add `@pyxis/elm` as a project dependency by running:

```sh
$ ./node_modules/.bin/elm add primait/@pyxis/elm
```

---

## Structure

This package offer you ready-to-use components with a ton of customization options.

Take a look at the [elm.json](./elm.json) to see which components are exposed and usable.

You'll find out that Pyxis' exposed modules are made up of:

1. `Pyxis.Components.xxx` which define components to be used in your interface.
2. `Pyxis.Commons.xxx` which define some useful apis, data and types that you'll need to use in order to properly set up the `Pyxis.Components.xxx`.

## Requiring a Component

All the Pyxis' components are available under the `Pyxis.Components.componentName` namespace.

Here's an example of requiring a component in Pyxis:

```elm
import Pyxis.Components.Field.Text as Text
import Pyxis.Components.Form as Form
import Pyxis.Component.Form.Grid.Row as Row
import Pyxis.Components.Icon as Icon
```

**We recommend to always use an `alias` for the Pyxis' stuff.**

---

## Dictionary

We tried to enforce consistency in our api so you can quickly guess how to use a component once after been playing with the previous one.

| Terminology | Meaning                                                                                                                                                                | Usage                                                            |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | --- | ---------------------------------------------------------------- |
| `Config`    | The configuration for the component's _view_. This **should not be stored on your application model**. You can configure a component right before its rendering phase. | Every component.                                                 |
| `config`    | The method which instantiate a component's `Config`.                                                                                                                   | Nearly every component. Some others have a more meaningful name. |
| `render`    | The method which renders a component.                                                                                                                                  | Every component.                                                 |     | Nearly every component. Some others have a more meaningful name. |
| `Model`     | The _state_ of the component which **should be stored in your own application model**.                                                                                 | Stateful components only.                                        |
| `init`      | The method which instantiates a component's `Model`.                                                                                                                   | Stateful components only.                                        |
| `update`    | The method which updates a component's `Model`. This may give return you a side effect (`Cmd msg`).                                                                    | Stateful components only.                                        |
| `withXXX`   | A method which maps over `Config`. Used to customize a component _view_.                                                                                               | Every component.                                                 |
| `setXXX`    | A method which maps over `Model`. Used to customize a component _state_.                                                                                               | Stateful components.                                             |

---

## Stateless components usage

This is the simplest kind of component you'll use in Pyxis.

To use a stateless component you'll need:

1. to obtain a `Config` from the homonymous method.
2. to apply modifiers to the `config` to customize your component appearance and behaviour. (_optional_)
3. to invoke the `render` method by passing it the `Config`.

```elm
import Components.Field.Label

-- Your application model
type alias Model {}

-- Your application view
view : Model -> Html msg
view model =
    Label.config "Your email address"
        |> Label.withSubText "You will receive a confirmation email"
        |> Label.render


```

---

## Stateful components usage

This is the most complex kind of component you'll use in Pyxis.

To use a stateful component you'll need:

1. to obtain a `Config` from the homonymous method.
2. to apply modifiers to the `config` to customize your component appearance and behaviour. (_optional_)
3. to obtain a `Model` from the `init` method.
4. to store the `Model` instance in your application's `Model`.
5. to define a `Msg` in your application which wraps (or tags) the `Msg` provided by the component.
6. to handle that `Msg` inside your application's `update` method.
7. to invoke the `render` method by passing it the `Msg` (_from step 5_), the `Model` (_from steps 3 and 4_) and the `Config` (_from step 1_).

```elm
import Html exposing (Html)
import Components.Field.Text as Text
import Components.Field.Label as Label

-- Your application model which should contain the component's model.
type alias Model = {
    email : Text.Model ()
}

initialModel : Model
initialModel =
    { email = Text.init "" (always Ok) }


-- Your application Msg
type Msg =
    EmailFieldChanged Text.Msg

-- Your update function
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- Your stateful component will need to handle this message.
        EmailFieldChanged subMsg ->
            ({ model | email = Text.update subMsg model.email }, Cmd.none)

-- Your view function
view : Model -> Html Msg
view model =
    {--  Note that the Text module doesn't have a "config" method like few others components.
    This because it's much more expressive to use "Text.email" or "Text.password" than "Text.config Password" or "Text.config Email".
    --}
    Text.email "email"
        |> Text.withLabel (Label.config "Your email address")
        |> Text.withPlaceholder "it-department@prima.it"
        |> Text.render EmailFieldChanged model.email


```

---

## Real application example

You can see a Pyxis-based working application example by looking at [the source code](./src/Examples/Form/Main.elm) or running the application by yourself.

To do the latter you should run:

```sh

## Clone the Pyxis' repository
$ git clone git@github.com:primait/pyxis.git

## Install dependencies
$ cd pyxis
$ npm i

## Enter the @pyxis/elm package folder
$ cd packages/pyxis-elm

## Run the elm reactor
$ npm run example:serve
```

You'll now should see the interactive application running on `http://localhost:8001/src/Examples/Form/Main.elm`.

---

## Documentation

You can find the documentation for each single component and also a preview of its appeareance and usage by following these links:

- [Elmbook documentation](https://elm.prima.design)
- ~~[Elm packages documentation](https://to-be-defined)~~
