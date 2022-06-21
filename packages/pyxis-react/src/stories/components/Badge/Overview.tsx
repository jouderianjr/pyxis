import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Badge from "components/Badge";

const overviewDescription = (
  <p>
    Badges are labels which hold small amounts of information. They are composed of text inside
    a <code>span</code> element.
  </p>
);

const variantDescription = (
  <p>
    Variants of badge consist on different combinations of colours and each of them conveys a different
    meaning to the user.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <Badge key={shortid.generate()}>Neutral</Badge>,
    'Default',
    '-'
  ],
  [
    <Badge variant="brand" key={shortid.generate()}>Brand</Badge>,
    'Brand',
    '-'
  ],
  [
    <Badge variant="action" key={shortid.generate()}>Action</Badge>,
    'Action',
    '-'
  ],
  [
    <Badge variant="success" key={shortid.generate()}>Success</Badge>,
    'Success',
    '-'
  ],
  [
    <Badge variant="alert" key={shortid.generate()}>Alert</Badge>,
    'Alert',
    '-'
  ],
  [
    <Badge variant="error" key={shortid.generate()}>Error</Badge>,
    'Error',
    '-'
  ],
  [
    <Badge variant="neutralGradient" key={shortid.generate()}>Neutral Gradient</Badge>,
    'Neutral Gradient',
    'Available only on light background'
  ],
  [
    <Badge variant="brandGradient" key={shortid.generate()}>Brand Gradient</Badge>,
    'Brand Gradient',
    'Available only on light background'
  ],
  [
    <div className="alt-wrapper" key={shortid.generate()}>
      <Badge variant={"ghost"}>Ghost</Badge>
    </div>,
    'Ghost',
    'Available only on dark background'
  ]
];

const altDescription = (
  <p>
    Some variants of badges support also an "alt" version for dark background.
  </p>
);

const generateAltBody = (): TableRow[] =>  [
  [
    <div className="alt-wrapper" key={shortid.generate()} >
      <Badge alt >Neutral</Badge>
    </div>,
    'Alt version',
  ]
];

const apiDescription = (
  <p>
    Set props to change variant to badge.
  </p>
);

const classDescription = (
  <p>
    The list of Badge CSS classes is
    available <a href="https://prima.design/3794e337c/p/64fbee-badge" className="link" target="_blank">on zeroheight documentation</a>.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Badge" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-display-badge-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Variants", "Alt Background", "Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateVariantBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Alt Background" description={altDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateAltBody()}
        gridTemplateColumns="100px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Badge} />
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}/>
  </>
)

export default Overview;
