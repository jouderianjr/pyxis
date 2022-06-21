import React, {FC} from "react";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import Form from "./Form";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
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
      Forms are a set of input components whose purpose is to allow data entry.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const anatomyDescription = (
  <p>
    The basic structure of a form is made up of some basic elements: form, fieldset, grid, row column and item.
  </p>
);

const generateAnatomyBody = (): TableRow[] => [
  [
    'Form',
    'Form element represents a document section containing interactive controls for submitting information.'
  ],
  [
    'Fieldset',
    'Fieldset element is used to group several controls as well as labels within a web form.'
  ],
  [
    'Grid',
    'Form Grid is used to group the rows of form with a specific gap between them.'
  ],
  [
    'Row',
    'Form Row is used to define the width of grid and to group the columns inside it.'
  ],
  [
    'Column',
    'Form Column is used to align horizontally and define the width of an element.'
  ],
  [
    'Item',
    'Form Item is used to group labels, fields, errors, hints and any other custom Html you provide.'
  ]
];

const gridDescription = (
  <p>
    Form Grid is used to group the rows of form with a specific gap between them.
  </p>
);

const rowDescription = (
  <p>
    Form Row is used to define the width of grid and to group the columns inside.
  </p>
);

const columnDescription = (
  <p>
    Form Column is used to align horizontally and define the width of a <code>form-item</code>.
    Each row can have a maximum of 6 columns based on its size.
    Normally the columns are divided into equal fractions (<code>fr</code>).
    Anyways, it is possible to set the span of the columns up to a maximum of 5,
    in this way it is possible to have a column wide <code>1</code> and a column wide <code>5</code>.
  </p>
);

const itemDescription = (
  <p>
    Form Item is used to group labels, fields, errors, hints and any other custom Html you provide.
    Check out the <span className="link" onClick={linkTo('components-form-item-overview--page')}>documentation.</span>.
  </p>
);

const accessibilityDescription = (
  <p>
    A <code>legend</code> should always be used inside a <code>fieldset</code>.
    Check out the <span className="link" onClick={linkTo('components-form-all-stories--real-world-example')}>real world example</span>.
  </p>
);

const classDescription = (
  <p>
    Form is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="form" key={shortid.generate()} />,
    'Base Class',
    <code>form</code>
  ],
  [
    <CopyableCode text="form-fieldset" key={shortid.generate()} />,
    'Fieldset Element',
    <code>fieldset</code>
  ],
  [
    <CopyableCode text="form-grid" key={shortid.generate()} />,
    'Grid Element',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid--gap-large" key={shortid.generate()} />,
    'Grid Modifier',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row" key={shortid.generate()} />,
    'Row Element',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row--medium" key={shortid.generate()} />,
    'Row Modifier',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row--small" key={shortid.generate()} />,
    'Row Modifier',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row__column" key={shortid.generate()} />,
    'Column Element',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row__column--span-2" key={shortid.generate()} />,
    'Column Modifier',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row__column--span-3" key={shortid.generate()} />,
    'Column Modifier',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row__column--span-4" key={shortid.generate()} />,
    'Column Modifier',
    <code>div</code>
  ],
  [
    <CopyableCode text="form-grid__row__column--span-5" key={shortid.generate()} />,
    'Column Modifier',
    <code>div</code>
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Form 🚧" description={overviewDescription} category="Component" isMain />
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Form Anatomy", "Grid", "Row", "Column", "Item", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Form Anatomy" description={anatomyDescription}>
      <Canvas>
        <Story id="components-form-all-stories--form-anatomy" />
      </Canvas>
      <Table
        head={['Element', 'Note']}
        body={generateAnatomyBody()}
        gridTemplateColumns="150px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Grid" description={gridDescription}>
      <p>
        <strong>Default gap</strong> is generally used on simple form items like text, textarea, select.
      </p>
      <Canvas>
        <Story id="components-form-all-stories--grid-default-gap" />
      </Canvas>
      <p>
        <strong>Large gap</strong> is generally used on visual elements like legend, radio card, message.
      </p>
      <Canvas>
        <Story id="components-form-all-stories--grid-with-large-gap" />
      </Canvas>
      <p>
        <strong>Sub Grid</strong><br />
        You can create a sub-grid by putting a new grid inside the <code>Row</code>.
        Doing so allows you to control how items span inside columns.
      </p>
      <Canvas>
        <Story id="components-form-all-stories--sub-grid" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Row" description={rowDescription}>
      <p>
        <strong>Default</strong> dimensions are 100% of its base container.
        It is recommended to use this setting for horizontal forms on single or multiple rows.
      </p>
      <Canvas>
        <Story id="components-form-all-stories--row-default" />
      </Canvas>
      <p>
        <strong>Medium</strong> dimensions are recommended to use this setting for vertical development forms
        with the possibility of placing components not belonging to the same group side by side.
      </p>
      <Canvas>
        <Story id="components-form-all-stories--row-medium" />
      </Canvas>
      <p>
        <strong>Small</strong> dimensions are recommended to use this setting for vertical development forms
        with the possibility of tiling only components of the same group.
      </p>
      <Canvas>
        <Story id="components-form-all-stories--row-small" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Column" description={columnDescription}>
      <Canvas>
        <Story id="components-form-all-stories--columns" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Item" description={itemDescription} />
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
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
