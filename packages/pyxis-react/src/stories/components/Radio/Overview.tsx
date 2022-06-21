import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Radio from "./Radio";
import {linkTo} from "@storybook/addon-links";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Radio buttons let the user make a single selection from a list of two or more options.<br/>
      Combine them together in radio groups to have a clean user experience.
    </p>
  </>
);

const stateDescription = (
  <p>
    Radios have idle, disabled, error, hover, and focus states.
  </p>
);

const generateStateBody = (): TableRow[] =>  [
  [
    <Radio name="idle" checked key={shortid.generate()} />,
    'Idle'
  ],
  [
    <Radio name="error" error key={shortid.generate()} />,
    'Error'
  ],
  [
    <Radio name="disabled" disabled key={shortid.generate()} />,
    'Disabled'
  ]
];

const groupDescription = (
  <>
    <p>
      A radio group is used to combine and provide structure to group of radio buttons, placing element such as label
      and error message in a pleasant and clear way. Also, it could display a hint message to help final user fill
      the group.
    </p>
    <p>
      Radio group have a horizontal layout as default, but with more then two items a vertical layout is recommended.
    </p>
    <p>
      Usage Examples:
    </p>
    <ul className="list">
      <li className="list__item">
        <span className="link" onClick={linkTo('components-control-radio-🚧-all-stories--default')}>Horizontal Layout</span>
      </li>
      <li className="list__item">
        <span className="link" onClick={linkTo('components-control-radio-🚧-all-stories--vertical-layout')}>Vertical Layout</span>
      </li>
    </ul>
  </>
)

const accessibilityDescription = (
  <>
    <p>
      A radio group should have <code>role='radiogroup'</code> and a proper label, linked to it via the ARIA
      attribute <code>aria-labelledby</code>.
    </p><p>
      Moreover, when a error message is present, please remember that it also should be connected to the group
      by adding a proper id to the message and the <code>aria-describedby</code> attribute to the group.
    </p>
  </>
);

const classDescription = (
  <p>
    Radio group is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="form-control" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="form-control--error" key={shortid.generate()} />,
    'State Modifier',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="form-control--disabled" key={shortid.generate()} />,
    'State Modifier',
    <code key={shortid.generate()}>label</code>,
    'Use it along with the `disabled` attribute on input',
  ],
  [
    <CopyableCode text="form-control__radio" key={shortid.generate()} />,
    'Input Element',
    <code key={shortid.generate()}>input</code>,
    '-',
  ],
  [
    <CopyableCode text="form-control-group" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>div</code>,
    'It displays radio buttons horizontally by default.',
  ],
  [
    <CopyableCode text="form-control-group--column" key={shortid.generate()} />,
    'Layout Modifier',
    <code key={shortid.generate()}>div</code>,
    'Use it to display radio buttons vertically',
  ],
  [
    <CopyableCode text="form-control-group__error-message" key={shortid.generate()} />,
    'Error Element',
    <code key={shortid.generate()}>div, span</code>,
    '-',
  ]
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Radio Button 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-control-radio-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["States", "Radio Group", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="State" description={stateDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateStateBody()}
        gridTemplateColumns="140px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Radio Group" description={groupDescription} />
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
