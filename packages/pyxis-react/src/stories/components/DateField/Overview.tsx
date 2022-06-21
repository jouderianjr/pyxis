import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import DateField from "./DateField";
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
      Date Field component enables users to select a date using a calendar view.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const stateDescription = (
  <>
    <p>
      Date fields have default (with placeholder), hover, focus, filled, error, hint and disable states.
    </p>
    <p>
      <strong className="text-l-bold">Hint:</strong> Interact with components to see hover and focus states.
    </p>
  </>
);

const generateStateBody = (): TableRow[] => [
  [
    <DateField />,
    "Default",
  ],
  [
    <DateField value={'2022-01-26'}/>,
    "Filled / Validate",
  ],
  [
    <DateField error />,
    "Error",
  ],
  [
    <DateField hint />,
    "Hint",
  ],
  [
    <DateField disabled />,
    "Disabled",
  ],
];

const sizeDescription = (
  <p>
    Date field can have two size: default or small.
  </p>
);

const generateSizeBody = (): TableRow[] => [
  [
    <DateField />,
    "Default",
  ],
  [
    <DateField size="small" />,
    "Small",
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
      <Story id="components-form-date-field-🚧-all-stories--with-accessible-label" />
    </Canvas>
  </>
);

const classDescription = (
  <p>
    Date Field is based upon this list of CSS classes.
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
    <CopyableCode text="form-field--with-prepend-icon" key={shortid.generate()} />,
    'Addon Modifier',
    <code>div</code>,
    'In Date Field, contrary to what happens in the Text Field, the prepend icon is always active by default.',
  ],
  [
    <CopyableCode text="form-field__wrapper" key={shortid.generate()} />,
    'Component Wrapper',
    <code>label</code>,
    'It is only used if there is a visible addon',
  ],
  [
    <CopyableCode text="form-field__addon" key={shortid.generate()} />,
    'Base Class',
    <code>div</code>,
    'In Date Input, con, contrary to what happens in the Text Field, the addon is always active by default.',
  ],
  [
    <CopyableCode text="form-field__date" key={shortid.generate()} />,
    'Input Element',
    <code>input</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__date--filled" key={shortid.generate()} />,
    'Input Modifier',
    <code>input</code>,
    'In Date Field is necessary specify when the input is filled with this class.',
  ],
  [
    <CopyableCode text="form-field__date--small" key={shortid.generate()} />,
    'Input Modifier',
    <code>input</code>,
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
    <OverviewTemplate title="Date Field 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-date-field-🚧-all-stories--default" />
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
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="300px 1fr 100px 2fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
