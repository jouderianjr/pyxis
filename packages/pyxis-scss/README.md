# @pyxis/scss
This repository is part of Pyxis Design System, and contain all the foundations and the components in SCSS.

## Usage
Pyxis can be used as a standalone unit by projects which do not rely on _Elm_ or _React_ for the frontend.

If you use one of the technologies above please check the following section.

### Using Pyxis UI Toolkit

- [Use Pyxis with React](https://github.com/primait/pyxis/tree/master/packages/pyxis-react)
- [Use Pyxis with Elm](https://github.com/primait/pyxis/tree/master/packages/pyxis-elm)

If you want to use Pyxis with a custom framework or for simple purposes please continue reading.

### Using Pyxis standalone version

- [Install Pyxis SCSS](#install-pyxis-scss)
- [Configuring Pyxis](#configuring-pyxis-optional)
- [Use Pyxis SCSS](#use-pyxis-scss)
- [Development](#development)

---

#### Install Pyxis SCSS
To install `@pyxis/scss` you will need to follow the instructions for installing through [JFrog Artifactory](https://www.jfrog.com/confluence/display/RTF/Npm+Registry) described in the [Setup](https://github.com/primait/pyxis#-setup) chapter of the monorepo.

#### Configuring Pyxis (optional)

You can redefine some variables (those defined in `@pyxis/scss/src/scss/config.scss`) by writing something like that:

```scss
// Require the configuration module and override the $fontDisplay variable.
// Using the @use directive we ensure CSS is never repeated in case of multiple requirements.
@use "~@pyxis/scss/src/scss/config.scss" with ($fontDisplay: "fallback");

// Pyxis module will now use your $fontPath variable.
@forward "~@pyxis/scss/src/scss/pyxis.scss";
```

---

### Structure of Pyxis SCSS

Pyxis is a complex entity made up of:
- a `base` module _(required)_
- a `foundation` module _(required)_
- a `components` module _(optional)_
- a `atoms` module _(optional)_

#### Base module
This module contains a `normalize` of all basic html tags and initializes the typography within pyxis.
It is mandatory to use `@pyxis/scss`.

#### Foundations module
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

#### Components module

Here is where the things get complex. Pyxis gives you a powerful UI kit in order to get things done easily.

Each of these modules is paired with a [React](https://github.com/primait/pyxis/tree/master/packages/pyxis-react) and an [Elm](https://github.com/primait/pyxis/tree/master/packages/pyxis-elm) version of the component.

#### Atoms module
This module contains the atomic classes that we expose for all the modules contained in the foundations. For example, it contains classes like `color-brand-base` or `padding-m`.

**Please note:**
Pyxis is **NOT** a utility-first CSS framework (like Tailwind), it is advisable to use these classes only when they can avoid writing a custom class, in general it is better not to use more than 2-3 at the same time, in that case it is better to create a custom class.

---

### Use Pyxis SCSS
As seen in the previous section `@pyxis/scss` is built with the sass modules, we can use them in several ways.

#### Include all pyxis
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

#### Include base and foundations
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


#### Usage with CSS Modules
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

#### Include components or atoms
If you haven't included all pyxis, you can also include component and atom classes at any time, like so:
```scss
@use "~@pyxis/scss/src/scss/components";
@use "~@pyxis/scss/src/scss/atoms";

// You can also include a single component, like this:
@use "~@pyxis/scss/src/scss/components/badge";
```
### Development

`@pyxis/scss` is part of a `pyxis` monorepo, to develop it you need to download the [project](https://github.com/primait/pyxis).

Once you have installed the monorepo, you will be able to run commands directly from the root of `pyxis`.
Remember that the commands launched by the root are global and could launch commands that also affect other repositories, like: `yarn build`.

#### Development mode

```sh
# Go inside `pyxis-scss`
cd pyxis/packages/pyxis-scss
yarn serve
```
This will start a development server on `localhost:8080`

---

#### Lint code
```sh
# In pyxis root directory
yarn lint

# To autofix errors reported by stylelint
yarn lint:fix
```
---

#### Build
```sh
# In pyxis root directory
yarn build
```

This will create a `dist` folder (inside `pyxis-scss`) in which you'll find a `pyxis.css` file.

---


