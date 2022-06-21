import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import TextSwitch from "./TextSwitch";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      TextSwitch allows a single choice among a group of options. As toggle, they should provide immediate results.
    </p>
  </>
);

const variantDescription = (
  <p>
    TextSwitch could change the way that the single option width is calculated.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <TextSwitch key={shortid.generate()} name="content-width"/>,
    'Content Width',
    'The width of each option depends on its content'
  ],
  [
    <TextSwitch key={shortid.generate()} name="equal-width" optionWidth={"equal"}/>,
    'Equal Width',
    'Each option has the same width'
  ],
];

const labelDescription = (
  <p>
    TextSwitch could have a label that can be positioned on top of text switch (left or center), or on the left.
  </p>
);

const generateLabelBody = (): TableRow[] =>  [
  [
    <TextSwitch key={shortid.generate()} name="label" hasLabel />,
    'Top center label'
  ],
  [
    <TextSwitch key={shortid.generate()} name="label-top-left" hasLabel labelPosition="topLeft"/>,
    'Top left label'
  ],
  [
    <TextSwitch key={shortid.generate()} name="label-top-left" hasLabel labelPosition="left"/>,
    'Left label'
  ],
];

const altDescription = (
  <p>
    TextSwitch also supports an "alt" version for dark background.
  </p>
);

const generateAltBody = (): TableRow[] =>  [
  [
    <div className="bg-neutral-base padding-xs" key={shortid.generate()} >
      <TextSwitch key={shortid.generate()} name="alt" alt/>
    </div>,
    'Alt version',
  ]
];

const accessibilityDescription = (
  <p>
    The <code>div</code> that wraps the options should have a <code>radiogroup</code> role. Also, if
    a label is not provided you should remember to add an <code>aria-label</code> attribute to the
    group.
  </p>
);

const classDescription = (
  <p>
    TextSwitch is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="text-switch-wrapper" key={shortid.generate()} />,
    'Wrapper Base Class',
    <code key={shortid.generate()}>div</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch-wrapper--left-label" key={shortid.generate()} />,
    'Label Position Modifier',
    <code key={shortid.generate()}>div</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch-wrapper--top-left-label" key={shortid.generate()} />,
    'Label Position Modifier',
    <code key={shortid.generate()}>div</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch__label" key={shortid.generate()} />,
    'Label Element',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>div</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch--equal-option-width" key={shortid.generate()} />,
    'Option Width Modifier',
    <code key={shortid.generate()}>div</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch__option" key={shortid.generate()} />,
    'Option Element',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch__option--checked" key={shortid.generate()} />,
    'State Modifier',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch__option-input" key={shortid.generate()} />,
    'Input Element',
    <code key={shortid.generate()}>input</code>,
    '-',
  ],
  [
    <CopyableCode text="text-switch__slider" key={shortid.generate()} />,
    'Slider Element',
    <code key={shortid.generate()}>div</code>,
    '-',
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="TextSwitch 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-control-textswitch-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Option Width Variants", "Label", "Alt Background", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Option Width Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateVariantBody()}
        gridTemplateColumns="400px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Label" description={labelDescription}>
      <Table
        head={['Sample', 'Label']}
        body={generateLabelBody()}
        gridTemplateColumns="400px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Alt Background" description={altDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateAltBody()}
        gridTemplateColumns="400px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="400px 2fr 2fr 1fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
