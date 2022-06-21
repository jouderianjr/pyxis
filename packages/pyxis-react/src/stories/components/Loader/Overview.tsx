import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Loader from "./Loader";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Loaders indicate that content will process for an indeterminate amount of time.
    </p>
  </>
);

const variantDescription = (
  <p>
    There are you types of Loader, the classic spinner or an animated car illustration.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <Loader type={"spinner"} key={shortid.generate()}/>,
    'Spinner',
  ],
  [
    <Loader type={"car"} key={shortid.generate()}/>,
    'Car',
  ],
];

const sizeDescription = (
  <p>
    Loader of type `spinner` could also have a small size.
  </p>
);

const generateSizeBody = (): TableRow[] =>  [
  [
    <Loader type={"spinner"} size={"small"} key={shortid.generate()}/>,
    'Small',
    'Available only for spinners'
  ],
];

const descriptionDescription = (
  <p>
    Both types of loader could have a text description.
  </p>
);

const generateDescriptionBody = (): TableRow[] =>  [
  [
    <Loader type={"spinner"} hasText key={shortid.generate()}/>,
    'Spinner with description',
  ],
  [
    <Loader type={"car"} hasText key={shortid.generate()}/>,
    'Car loader with description',
  ],
];

const altDescription = (
  <p>
    Both Car loader and Spinner support the "alt" version for dark background.
  </p>
);

const generateAltBody = (): TableRow[] =>  [
  [
    <div className="alt-wrapper" key={shortid.generate()} >
      <Loader type={"spinner"} alt />
    </div>,
    'Spinner alt version',
  ],
  [
    <div className="alt-wrapper" key={shortid.generate()} >
      <Loader type={"car"} alt />
    </div>,
    'Car loader alt version',
  ]
];

const accessibilityDescription = (
  <p>
    Loaders have a <code>status</code> role and also a default <code>aria-label</code> set to "Loading...".
  </p>
);

const classDescription = (
  <p>
    Loader is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="loader" key={shortid.generate()} />,
    'Base Class',
    '-',
  ],
  [
    <CopyableCode text="loader--with-car" key={shortid.generate()} />,
    'Type Modifier',
    '-',
  ],
  [
    <CopyableCode text="loader--small" key={shortid.generate()} />,
    'Size Modifier',
    'Should not be used with a car loader',
  ],
  [
    <CopyableCode text="loader--alt" key={shortid.generate()} />,
    'Alternative Background Class',
    '-',
  ],
  [
    <CopyableCode text="loader__spinner" key={shortid.generate()} />,
    'Spinner Element',
    '-',
  ],
  [
    <CopyableCode text="loader__car" key={shortid.generate()} />,
    'Car Loader Element',
    '-',
  ],
  [
    <CopyableCode text="loader__text" key={shortid.generate()} />,
    'Description Element',
    '-',
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Loader 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-display-loader-🚧-all-stories--spinner-loader" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={[
        "Types",
        "Size",
        "With description",
        "Alt Background",
        "Accessibility",
        "Overview of CSS classes"]}
      />
    </OverviewTemplate>
    <OverviewTemplate title="Types" description={variantDescription}>
      <Table
        head={['Sample', 'Type']}
        body={generateVariantBody()}
        gridTemplateColumns="150px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizeDescription}>
      <Table
        head={['Sample', 'Size', 'Note']}
        body={generateSizeBody()}
        gridTemplateColumns="150px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="With description" description={descriptionDescription}>
      <Table
        head={['Sample', 'Description']}
        body={generateDescriptionBody()}
        gridTemplateColumns="150px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Alt Background" description={altDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateAltBody()}
        gridTemplateColumns="150px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="300px 1fr 1fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
