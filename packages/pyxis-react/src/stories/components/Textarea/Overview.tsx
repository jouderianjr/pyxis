import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import TextArea from "./TextArea";
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
      Text areas are used when the user may insert longer form content, typically spanning across multiple lines.
      Text areas can hold any amount of text and in doing they so grow in height as the user is entering their information.
      Unlike text fields, textarea doesn't support the addons.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const stateDescription = (
  <>
    <p>
      Text Area have default (with placeholder), hover, focus, filled, error, hint and disable states.
    </p>
    <p>
      <strong className="text-l-bold">Hint:</strong> Interact with components to see hover and focus states.
    </p>
  </>
);

const generateStateBody = (): TableRow[] => [
  [
    <TextArea />,
    "Default",
  ],
  [
    <TextArea value="Text Field"/>,
    "Filled / Validate",
  ],
  [
    <TextArea error />,
    "Error",
  ],
  [
    <TextArea hint />,
    "Hint",
  ],
  [
    <TextArea disabled />,
    "Disabled",
  ],
];

const sizeDescription = (
  <p>
    Text field can have two size: default or small.
  </p>
);

const generateSizeBody = (): TableRow[] => [
  [
    <TextArea />,
    "Default",
  ],
  [
    <TextArea size="small" />,
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
      <Story id="components-form-text-area-🚧-all-stories--with-accessible-label" />
    </Canvas>
  </>
);

const classDescription = (
  <p>
    Text Area is based upon this list of CSS classes.
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
    <CopyableCode text="form-field__textarea" key={shortid.generate()} />,
    'Textarea Element',
    <code>textarea</code>,
    '-',
  ],
  [
    <CopyableCode text="form-field__textarea--small" key={shortid.generate()} />,
    'Textarea Modifier',
    <code>textarea</code>,
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
    <OverviewTemplate title="Text Area 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-text-area-🚧-all-stories--default" />
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
