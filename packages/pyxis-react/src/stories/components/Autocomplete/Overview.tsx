import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import Autocomplete from "./Autocomplete";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Autocompletes allow users to enter any combination of letters, numbers, or symbols of their choosing
      (unless otherwise restricted), and receive one or more suggested matches in a list below the input.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const stateDescription = (
  <>
    <p>
      Autocomplete have default (with placeholder), hover, focus, filled, error, hint and disable states.
    </p>
    <p>
      <strong className="text-l-bold">Hint:</strong> Interact with components to see hover and focus states.
    </p>
  </>
);

const generateStateBody = (): TableRow[] => [
  [
    <Autocomplete />,
    "Default",
  ],
  [
    <Autocomplete initialValue="Italy"/>,
    "Filled / Validate",
  ],
  [
    <Autocomplete error />,
    "Error",
  ],
  [
    <Autocomplete hint />,
    "Hint",
  ],
  [
    <Autocomplete disabled />,
    "Disabled",
  ],
];


const sizeDescription = (
  <p>
    Autocomplete can have two size: default or small.
  </p>
);

const generateSizeBody = (): TableRow[] => [
  [
    <Autocomplete />,
    "Default",
  ],
  [
    <Autocomplete size="small" />,
    "Small",
  ],
];

const dropdownAddonDescription = (
  <p>
    Autocomplete dropdown can have several addons, such as suggestion or header.
    They are used to make the user understand the purpose of the field better.
    They can also be used simultaneously.
  </p>
);

const generateDropdownAddonBody = (): TableRow[] => [
  [
    <Autocomplete withSuggestion />,
    "With Suggestion",
  ],
  [
    <Autocomplete withHeader />,
    "With Header",
  ],
  [
    <Autocomplete noResultAction />,
    "Action link on no result",
  ],
];

const accessibilityDescription = (
  <>
    <p>
      Whenever possible, use the label element to associate text with form elements explicitly.
      The <code>for</code> attribute of the label must exactly match the <code>id</code> of the form input.
    </p>
    <p>
      When a error message is present, please remember that it also should be connected to the group
      by adding a proper id to the message and the <code>aria-describedby</code> attribute to the group.
    </p>
  </>
);

const classDescription = (
  <p>
    Autocomplete is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="form-field" key={shortid.generate()} />,
    'Base Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field--error" key={shortid.generate()} />,
    'State Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field--disabled" key={shortid.generate()} />,
    'State Modifier',
    <code>div</code>,
    'Use it along with the `disabled` attribute on input',
  ],
  [
    <CopyableCode text="form-field--with-opened-dropdown" key={shortid.generate()} />,
    'State Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__wrapper" key={shortid.generate()} />,
    'Component Wrapper',
    <code>label</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__autocomplete" key={shortid.generate()} />,
    'Autocomplete Element',
    <code>input</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__autocomplete--filled" key={shortid.generate()} />,
    'Autocomplete Modifier',
    <code>input</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__autocomplete--small" key={shortid.generate()} />,
    'Autocomplete Modifier',
    <code>input</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__addon" key={shortid.generate()} />,
    'Base Class',
    <code>div</code>,
    'In Autocomplete Field, contrary to what happens in the Text Field, the addon is always active by default.',
  ],
  [
    <CopyableCode text="form-field__addon__reset" key={shortid.generate()} />,
    'Reset Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="fform-field__addon__reset--small" key={shortid.generate()} />,
    'Reset Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown-wrapper" key={shortid.generate()} />,
    'Dropdown Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown-wrapper--small" key={shortid.generate()} />,
    'Dropdown Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown" key={shortid.generate()} />,
    'Dropdown Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown--with-header" key={shortid.generate()} />,
    'Dropdown Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__header" key={shortid.generate()} />,
    'Header Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__suggestion" key={shortid.generate()} />,
    'Suggestion Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__suggestion__icon" key={shortid.generate()} />,
    'Suggestion Icon Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__suggestion__wrapper" key={shortid.generate()} />,
    'Suggestion Wrapper Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__suggestion__title" key={shortid.generate()} />,
    'Suggestion Title Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__suggestion__subtitle" key={shortid.generate()} />,
    'Suggestion Subtitle Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__item" key={shortid.generate()} />,
    'Item Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__item--active" key={shortid.generate()} />,
    'Item Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__item--active" key={shortid.generate()} />,
    'Item Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__no-results" key={shortid.generate()} />,
    'No Result Class',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-dropdown__no-results__action" key={shortid.generate()} />,
    'No Result Action Class',
    <code>div</code>,
    '-',
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Autocomplete 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-autocomplete-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["State", "Addon", "Size", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="State" description={stateDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateStateBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizeDescription}>
      <Table
        head={['Sample', 'Size']}
        body={generateSizeBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Dropdown Addon" description={dropdownAddonDescription}>
      <Table
        head={['Sample', 'Size']}
        body={generateDropdownAddonBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="350px 250px 100px 2fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
