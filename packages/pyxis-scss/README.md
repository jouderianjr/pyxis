# @pyxis/scss
Pyxis SCSS is part of Pyxis Design System, and contains all the foundations and the components developed in SCSS.

---

## Table of contents

1. [Structure of Pyxis SCSS](#-structure-of-pyxis-scss)
2. [Usage with React or Elm](#-usage-with-react-or-elm)
3. [Standalone usage](#-standalone-usage)
4. [Use Pyxis SCSS](#-use-pyxis-scss)
5. [Pyxis SCSS foundations' and components' documentation](#-pyxis-scss-foundations-and-components-documentation)
6. [Development](#-development)

---

## 💠 Structure of Pyxis SCSS
Pyxis SCSS is a complex entity made up of:
- a `base` module _(required)_
- a `foundation` module _(required)_
- a `components` module _(optional)_
- a `atoms` module _(optional)_

### Base module
This module contains a `normalizer` of all basic HTML tags and initializes the typography within Pyxis.
It is mandatory to use within `@pyxis/scss`.

> ⚠️ Be aware that Pyxis SCSS will modify global element styles as it contains a `normalizer` and operates on all basic HTML tags.

### Foundations module
This module contains all the pyxis `foundations`, a collection of functions and mixins which define a common look & feel for all our applications.
It is mandatory to use `@pyxis/scss`.

Foundations are made up of simple settings that follow our [Design Tokens](https://github.com/primait/pyxis/tree/master/packages/pyxis-tokens) and are used for:

- Breakpoint
- Color
- Container
- Elevation
- Hiding
- Layout
- Motion
- Radius
- Spacing
- Typography
- and some useful functions.

### Components module
Here is where the things get complex. Pyxis gives you a powerful UI kit in order to get things done easily.

Each of these modules is paired with a [React](https://github.com/primait/pyxis/tree/master/packages/pyxis-react) and an [Elm](https://github.com/primait/pyxis/tree/master/packages/pyxis-elm) version of the component.

### Atoms module
This module contains the atomic classes that we expose for all the modules contained in the foundations. For example, it contains classes like `color-brand-base` or `padding-m`.

**Please note:**
Pyxis is **NOT** a utility-first CSS framework (like Tailwind), it is advisable to use these classes only when they can avoid writing a custom class, in general it is better not to use more than 2-3 at the same time, in that case it is better to create a custom class.

---

## ⚙️ Usage with React or Elm
Using Pyxis SCSS paired with components developed in _Pyxis Elm_ or _Pyxis React_ is the most recommended way.
To do so, all you need to do is to install the React or Elm package and be sure to have the Pyxis SCSS package too, otherwise add it manually.

For more information check the specific package:

- [Use Pyxis with React](https://github.com/primait/pyxis/tree/master/packages/pyxis-react)
- [Use Pyxis with Elm](https://github.com/primait/pyxis/tree/master/packages/pyxis-elm)

---

## ⚙️ Standalone usage
Pyxis can be used as a standalone unit by projects which do not rely on _Elm_ or _React_ for the frontend.

### Npm module usage
**Prerequisite**: [had configured Jfrog Artifactory cli](https://github.com/primait/pyxis#-setup) chapter of the monorepo.
To install `@pyxis/scss` via _npm_ simply run:
```sh
$ npm i @pyxis/scss
```

### Configuring Pyxis (optional)
You can redefine some variables (those defined in `@pyxis/scss/src/scss/config.scss`) by writing something like that:

```scss
// Require the configuration module and override the $fontDisplay variable.
// Using the @use directive we ensure CSS is never repeated in case of multiple requirements.
@use "~@pyxis/scss/src/scss/config.scss" with ($fontDisplay: "fallback");

// Pyxis module will now use your $fontPath variable.
@forward "~@pyxis/scss/src/scss/pyxis.scss";
```

---

## 🪄 Use Pyxis SCSS
As seen in the previous section `@pyxis/scss` is built with the sass modules, we can use them in several ways.

- [Include all Pyxis SCSS](#include-all-pyxis-scss)
- [Include only base and foundations](#include-only-base-and-foundations)
- [Include components or atoms](#include-components-or-atoms)
- [Usage with CSS Modules](#usage-with-css-modules)
- [Include the compiled CSS (not recommended)](#include-the-compiled-css-not-recommended)
- [SCSS Linter](#scss-linter)

### Include all Pyxis SCSS
To use all `pyxis-scss` we can include the `pyxis` module, which contains all the main component modules (`base`, `foundations`, `components` and `atoms`) in our scss file.

This way we will include classes of all components and atomic classes. This means there will be many unused classes, in which case we recommend using [PurgeCSS](https://purgecss.com/).
```scss
// Include pyxis module
@use "~@pyxis/scss/src/scss/pyxis";

// Use it
.class {
  color: pyxis.color(brand);
}
```

### Include only base and foundations
If we don't want to include all the pyxis classes we can only insert the `base` and `foundations`.
```scss
// `app.scss`
// Include base and foundations module
@use "~@pyxis/scss/src/scss/base";
@use "~@pyxis/scss/src/scss/foundations" as pyxis;
// If we don't use CSS Modules we can also export the foundations,
// so that we can use them later in other files.
@forward "~@pyxis/scss/src/scss/foundations";

// Use it
.class {
  color: pyxis.color(brand);
}

// In case we don't use CSS Modules we can use this `app.scss` file
// to include foundations within another scss file, like this:
// `*.scss`
@use "app" as pyxis;

// Use it
.class {
  color: pyxis.color(brand);
}
```

### Include components or atoms
If you haven't included all pyxis, you can also include component and atom classes at any time, like so:
```scss
@use "~@pyxis/scss/src/scss/components";
@use "~@pyxis/scss/src/scss/atoms";

// You can also include a single component, like this:
@use "~@pyxis/scss/src/scss/components/badge";
```

### Usage with CSS Modules
If your project uses css modules the approach is slightly different, as you cannot include the `base` file inside the modules, as it contains base tags which are not allowed within the css modules.

In this case you can structure the project as follows:
```scss
// `app.scss`
// Include base module
@use "~@pyxis/scss/src/scss/base";

// `*.module.scss`
@use "~@pyxis/scss/src/scss/foundations" as pyxis;

// Use it
.class {
  color: pyxis.color(brand);
}
```

### Include the compiled CSS (not recommended)
If you want to include all the compiled CSS, you just need to add it in a stylesheet <link> into your <head> 
before all other stylesheets. However, this is not a recommended approach as it includes all the classes for all components and also
prevent you for using SCSS foundations tokens, mixins and functions.

```html
<link rel="stylesheet" href="dist/pyxis.css">
```


### SCSS Linter
You can import Pyxis' Linter configuration by adding it to the list
of the extension in your `.stylelintrc` file.

```json
{
  "extends": "@pyxis/scss/.stylelintrc"
}
```

---

## 📚 Pyxis SCSS foundations' and components' documentation

The complete documentation of Pyxis SCSS and its module is available at [prima.design](https://prima.design/).
Here you'll find all the mixins, functions and classes that let you use Pyxis foundations in fast and easy way,
and also the HTML structure and CSS classes that build our components.

---

## ⌨ ️Development

As `@pyxis/scss` is part of a `pyxis` monorepo, to develop it you need to download the [project](https://github.com/primait/pyxis).

Once you have installed the monorepo, you will be able to run commands directly from the root of `pyxis`.
Remember that the commands launched by the root are global and could launch commands that also affect other repositories, like: `yarn build`.

### Development mode
To start a development server on `localhost:8080`, please run:

```sh
# Go inside `pyxis-scss`
cd pyxis/packages/pyxis-scss
yarn serve
```

---

### Manage tokens
Pyxis SCSS is based on Design Tokens contained in Pyxis Tokens.
If you need to consult or modify them please follow the instructions that you can find [here](https://github.com/primait/pyxis/tree/master/packages/pyxis-tokens).

---

### Lint code
If you want to lint code and/or autofix lint errors, run the following commands.

```sh
# In pyxis root directory
yarn lint

# To autofix errors reported by stylelint
yarn lint:fix
```
---

### Build
To create a `dist` folder (inside `pyxis-scss`) in which there is the `pyxis.css` file, please run:

```sh
# In pyxis root directory
yarn build
```

---


