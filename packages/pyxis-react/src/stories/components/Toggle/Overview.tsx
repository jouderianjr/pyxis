import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import Toggle from "./Toggle";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Toggle afford a choice between one of two opposing states or options. They allow users to choose between two mutually exclusive options,
      and they should provide immediate results.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const stateDescription = (
  <>
    <p>
      Toggle have default, hover, focus and disable states.
    </p>
    <p>
      <strong className="text-l-bold">Hint:</strong> Interact with components to see hover and focus states.
    </p>
  </>
);

const generateStateBody = (): TableRow[] => [
  [
    <Toggle id="toggle-id"/>,
    "Default",
  ],
  [
    <Toggle id="toggle-id-checked" checked />,
    "Checked",
  ],
  [
    <Toggle id="toggle-id-disabled" disabled />,
    "Disabled",
  ],
];

const labelDescription = (
  <p>
    Toggle can have a label but always on the left of the toggle itself.
  </p>
);

const accessibilityDescription = (
  <p>
    Toggle should have a <code>switch</code> role. Also, the <code>aria-checked</code> attribute should always be synchronized
    with the <code>checked</code> one. Lastly, please remember that, if the toggle element doesn't have a visible label,
    it should have a proper <code>aria-label</code> or <code>aria-labelledby</code> attribute.
  </p>
);

const classDescription = (
  <p>
    Toggle is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="toggle" key={shortid.generate()} />,
    'Base Class',
    <code>label</code>,
    '-',
  ],
  [
    <CopyableCode text="toggle--disabled" key={shortid.generate()} />,
    'State Modifier',
    <code>div</code>,
    'Use it along with the `disabled` attribute on input',
  ],
  [
    <CopyableCode text="toggle__input" key={shortid.generate()} />,
    'Input element',
    <code>input</code>,
    '-',
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Toggle 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-control-toggle-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["State", "Accessibility", "Label", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="State" description={stateDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateStateBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Label" description={labelDescription}>
      <Canvas>
        <Story id="components-control-toggle-🚧-all-stories--with-label" />
      </Canvas>
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
