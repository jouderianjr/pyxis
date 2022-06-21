import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import React, {FC} from "react";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import {pascalToKebab} from "commons/utils/string";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      The <code>legend</code> HTML element represents a caption for the content of its parent <code>fieldset</code>.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const variantDescription = (
  <p>
    Variants of legend consist on different combinations of element,
    they are used to explain to the user the context of the form.
  </p>
);

const variantBody: string[] = [
  'Default',
  'With description',
  'With icon',
  'With image',
  'Align left',
];

const classDescription = (
  <p>
    Legend is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="form-legend" key={shortid.generate()} />,
    'Base Class',
    <code>legend</code>
  ],
  [
    <CopyableCode text="form-legend--align-left" key={shortid.generate()} />,
    'Base Modifier',
    <code>legend</code>
  ],
  [
    <CopyableCode text="form-legend__addon" key={shortid.generate()} />,
    'Addon Element',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-legend__title" key={shortid.generate()} />,
    'Title Element',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-legend__text" key={shortid.generate()} />,
    'Text Element',
    <code>div</code>
  ]
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Legend 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-legend-🚧-all-stories--with-image" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Variants", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      {variantBody.map(variant => (
        <>
          <strong>{variant}</strong>
          <Canvas className="full-width">
            <Story id={`components-form-legend-🚧-all-stories--${pascalToKebab(variant)}`} />
          </Canvas>
        </>
      ))}
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to']}
        body={tableClassBody}
        gridTemplateColumns="1fr 200px 200px"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
