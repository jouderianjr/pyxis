# 🧭 Pyxis

The name "**Pyxis**" comes from a [small constellation](https://en.wikipedia.org/wiki/Pyxis) in the southern sky. It's the latin term for _compass_ and we chose it to indicate the path to follow for the designs of Prima.

<img alt="Pyxis Design System" src="pyxis.png" width="100%" />

---

## Table of contents

1. [Introduction](#-introduction)
2. [Setup](#-setup)
3. [Documentation](#-documentation)
4. [Development](#️-development)

---

## ✨ Introduction

Pyxis is our Design System which helps developers and designers to create complex UIs and UXs by relying on a solid foundations of best-practices and recognizable colors and patterns.

Pyxis modules are abstraction which help your team to quickly prototype and build experiences without relying on low-level stuff in a common way through Prima organization.

### Internal structure

_Please note that Pyxis is strongly opinionated and maintained by the Pyxis Team._

This repository takes advantage of [Lerna](https://github.com/lerna/lerna) and its capabilities to handle multiple repositories inside a so-called _monorepo_.

By consequence you'll find out that Pyxis is made of different sub-packages:

| Name            | Source                            | Description                                                              |
| --------------- | --------------------------------- | ------------------------------------------------------------------------ |
| `@pyxis/scss`   | [Source](./packages/pyxis-scss)   | Core Scss and CSS module. **Mandatory usage.**                           |
| `@pyxis/elm`    | [Source](./packages/pyxis-elm)    | Elm components and live documentation via Elmbook.                       |
| `@pyxis/react`  | [Source](./packages/pyxis-react)  | React components and live documentation via Storybook.                   |
| `@pyxis/icons`  | [Source](./packages/pyxis-icons)  | Svg icon pack.                                                           |
| `@pyxis/tokens` | [Source](./packages/pyxis-tokens) | A representation of Design Tokens which define some Pyxis' core aspects. |

By following this guide you'll learn [how to install](#⚙️-setup) Pyxis and where to find the [documentation](#📚-documentation) for your project.

---

## ⚙️ Setup

Pyxis is deployed on a [JFrog Artifactory](https://www.jfrog.com/confluence/display/RTF/Npm+Registry) repository with `npm` integration. By consequence you should install the [JFrog cli](https://jfrog.com/getcli/) in order to get things work.

You'll also need to ask DevOps for a JFrog Artifactory account in order to continue.

Now you want to instruct `npm` to download the packages from Prima's Artifactory registry instance. To do that follow the steps below:

1. Configure the _Artifactory registry_ for Pyxis by running the command below in your terminal.

   ```sh
   $ npm config set @pyxis:registry https://prima.jfrog.io/artifactory/api/npm/pyxis-it/
   ```

2. From [JFrog User Profile](https://prima.jfrog.io/ui/admin/artifactory/user_profile) generate an `ApiKey`. This will be used to authorize your profile when pushing/pulling from JFrog.

3. In your terminal run:

   ```sh
   curl -u <JFROG_USER>:<JFROG_APIKEY> http://prima.jfrog.io/artifactory/api/npm/auth >> ~/.npmrc

   ## Usage example with user="aturing" apikey="3n1gm4?3n1gm4!3n1gm4?"
   ## curl -u aturing:3n1gm4?3n1gm4!3n1gm4? http://prima.jfrog.io/artifactory/api/npm/auth >> ~/.npmrc
   ```

4. Your `.npmrc` should now look like this:

   ```
   ## File: .npmrc

   ## This line instruct npm to retrieve @pyxis packages from Artifactory.
   @pyxis:registry=https://prima.jfrog.io/artifactory/api/npm/pyxis-it/

   always-auth=true
   _auth="a-very=very_very-long_auth_token="
   email=name.lastname@domain.com
   ```

   > ⚠️ We're aware about Artifactory's ability to handle third-part dependencies itself. This feature will be available in future releases according to DevOps.

5. Save and close the file. You should now be able to use Pyxis npm modules like this:

   ```sh
   $ npm i @pyxis/scss

   # Or
   # npm i @pyxis/react
   # npm i @pyxis/icons
   ```

   > ⚠️ This isn't suitable for Pyxis Elm package.

6. You're now ready to use Pyxis in your application. Follow the [Documentation](#📚-documentation) in order to learn how to use Pyxis.

---

## 📚 Documentation

Before diving into documentation you should choose between using Pyxis' _precompiled CSS_ and Pyxis' _SCSS source_.

Infact _the use of Pyxis stylesheet is mandatory_.
You cannot do anything with Pyxis without relying on its core (_foundations & components_).

Once you chosen the solution which fits the best for your project you can go ahead with learning Pyxis.

| Package    | Live documentation          | Readme                                      | Mandatory |
| ---------- | --------------------------- | ------------------------------------------- | --------- |
| **SCSS**   | https://prima.design/       | [Readme](./packages/pyxis-scss/README.md)   | X         |
| **Elm**    | https://elm.prima.design/   | [Readme](./packages/pyxis-elm/README.md)    |           |
| **React**  | https://react.prima.design/ | [Readme](./packages/pyxis-react/README.md)  |           |
| **Icons**  | n/a                         | [Readme](./packages/pyxis-icons/README.md)  |           |
| **Tokens** | n/a                         | [Readme](./packages/pyxis-tokens/README.md) |           |

---

## ⌨️ Development

Pyxis was built as a single repository with development simplicity in mind.

We use [Yarn workspaces](https://classic.yarnpkg.com/en/docs/workspaces/) for handling dependencies and [Lerna](https://github.com/lerna/lerna/) to manage versioning and publishing.

Run the following commands to setup your local dev environment:

```sh
# Install `yarn`, alternatives at https://yarnpkg.com/en/docs/install
$ brew install yarn

# Clone the `pyxis` repo
$ git clone git@github.com:primait/pyxis.git
$ cd pyxis

# Install dependencies
$ yarn install

# Run React live-documentation dev server
$ yarn storybook:serve

# Run Elm live-documentation dev server
$ yarn elmbook:serve
```

For more in-depth instructions, development guidelines etc., see the README files for each sub-repository.

### Icons

Pyxis also includes `@pyxis/icons`, a repository which contains all of our SVG icons.

Automatic _code generation_ lets us turn these icons into React components and Elm functions, by running the following command:

```sh
$ yarn generate:icons
```

### Design Tokens

Pyxis foundations is a set of constants derived from the design token entities.

To generate fresh tokens, run the following command:

```sh
$ yarn tokens:build
```
