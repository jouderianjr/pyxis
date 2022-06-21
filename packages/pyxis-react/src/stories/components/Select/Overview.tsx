import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import Select from "./Select";
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
      Select components enable the selection of one out of at least four options provided in a list.
      They are typically used within a form to allow users to make their desired selection from the list of options.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const stateDescription = (
  <>
    <p>
      Select have default (with placeholder), hover, focus, filled, error, hint and disable states.
    </p>
    <p>
      <strong className="text-l-bold">Hint:</strong> Interact with components to see hover, focus states.
    </p>
  </>
);

const generateStateBody = (): TableRow[] => [
  [
    <Select />,
    "Default",
  ],
  [
    <Select filled />,
    "Filled / Validate",
  ],
  [
    <Select error />,
    "Error",
  ],
  [
    <Select hint />,
    "Hint",
  ],
  [
    <Select disabled />,
    "Disabled",
  ],
];

const sizeDescription = (
  <p>
    Select can have two size: default or small.
  </p>
);

const generateSizeBody = (): TableRow[] => [
  [
    <Select />,
    "Default",
  ],
  [
    <Select size="small" />,
    "Small",
  ],
];

const typeDescription = (
  <p>
    Select can have two type: custom dropdown (default) or native.
    The native type must be activated automatically on mobile devices.
  </p>
);

const generateTypeBody = (): TableRow[] => [
  [
    <Select />,
    "Custom Dropdown (default)",
  ],
  [
    <Select native />,
    "Native",
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
    <Canvas>
      <Story id="components-form-select-🚧-all-stories--with-accessible-label" />
    </Canvas>
  </>
);

const classDescription = (
  <p>
    Select is based upon this list of CSS classes.
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
    <CopyableCode text="form-field--with-select-dropdown" key={shortid.generate()} />,
    'State Modifier',
    <code>div</code>,
    'Use it along with custom select (not native)',
  ],
  [
    <CopyableCode text="form-field--with-opened-dropdown" key={shortid.generate()} />,
    'State Modifier',
    <code>div</code>,
    'Use it along with custom select (not native)',
  ],
  [
    <CopyableCode text="form-field__wrapper" key={shortid.generate()} />,
    'Component Wrapper',
    <code>label</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__select" key={shortid.generate()} />,
    'Select Element',
    <code>select</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__select--filled" key={shortid.generate()} />,
    'Select Modifier',
    <code>select</code>,
    'It must be added when a value is selected.',
  ],
  [
    <CopyableCode text="form-field__select--small" key={shortid.generate()} />,
    'Select Modifier',
    <code>select</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__addon" key={shortid.generate()} />,
    'Base Class',
    <code>div</code>,
    'In Select Field, contrary to what happens in the Text Field, the addon is always active by default.',
  ],
  [
    <CopyableCode text="form-dropdown-wrapper" key={shortid.generate()} />,
    'Dropdown Class',
    <code>div</code>,
    'Use it along with custom select (not native)',
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
    'Use it along with custom select (not native)',
  ],
  [
    <CopyableCode text="form-dropdown__item" key={shortid.generate()} />,
    'Item Class',
    <code>div</code>,
    'Use it along with custom select (not native)',
  ],
  [
    <CopyableCode text="form-dropdown__item--active" key={shortid.generate()} />,
    'Item Modifier',
    <code>div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__error-message" key={shortid.generate()} />,
    'Error Element',
    <code>div</code>,
    '-',
  ]
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Select 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-select-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["State", "Size", "Accessibility", "Overview of CSS classes"]} />
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
    <OverviewTemplate title="Type" description={typeDescription}>
      <Table
        head={['Sample', 'Type']}
        body={generateTypeBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="350px 1fr 100px 2fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;