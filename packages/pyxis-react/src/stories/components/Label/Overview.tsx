import React, { FC } from "react";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import {linkTo} from "@storybook/addon-links";
import Label from "components/Form/Label";

const overviewDescription = (
  <>
    <p>
      Combined with other components, Label provides some information about the content of that specific instance.
    </p>
    <p>
      Label component just renders the label and possibly a sub-label. In a form, to link a label with its input
      both logically and visually, please wrap it in a <span className="link" onClick={linkTo('components-form-item-overview--page')}>
      Form.Item</span>.
    </p>
  </>
);

const subTextDescription = (
    <p>
      Label can hold an sub-text, a longer description that could help the user to better understand the input content.
    </p>
);

const generateSubTextBody = (): TableRow[] => [
  [
    <Label subText="Label with sub-text">Label</Label>,
    "Sub-text",
  ],
];

const sizeDescription = (
  <p>
    Label can have two size: default or small.
  </p>
);

const generateSizeBody = (): TableRow[] => [
  [
    <Label>Label</Label>,
    "Default",
  ],
  [
    <Label size="small">Label</Label>,
    "Small",
  ],
];

const accessibilityDescription = (
  <p>
    If you're using Label as a standalone component, outside the <code>Form.Item</code>, you should remember to associate it with its input
    explicitly by adding the <code>for</code> attribute equal to the <code>id</code> of the input.
  </p>
);

const apiDescription = (
  <p>
    Label component could be customized through the following props.
  </p>
);

const classDescription = (
  <p>
    The list of Label CSS classes is
    available <a href="https://prima.design/3794e337c/p/32886d-label/b/9594d0" className="link" target="_blank">on
    zeroheight documentation</a>.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Label" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-label-all-stories--inside-form-item" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Size", "With a sub-text", "Accessibility", "Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizeDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateSizeBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="With a sub-text" description={subTextDescription}>
      <Table
        head={['Sample', 'Addon']}
        body={generateSubTextBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Label} />
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}/>
  </>
)

export default Overview;
