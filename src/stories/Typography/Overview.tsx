import React, { FC } from 'react';
import OverviewTemplate from 'stories/components/OverviewTemplate';
import Table, { TableRow } from 'stories/components/Table';
import shortid from 'shortid';
import CopyableCode from 'stories/components/CopyableCode';
import Typography from './Typography';
import { pyxisText, pyxisTitle, PyxisTypography } from './common';

const typographyDescription = (
  <>
    <p>
      Here&apos;s typography styles we use throughout all of our services. We use
      <strong> Circular Web </strong>
      font across the entire system, so you can play with weights and sizes in order to convey different
      levels of importance.
    </p>
    <p>
      Typography is divided in title and text, both with different weights and sizes.
    </p>
  </>
);

const titleDescription = (
  <p>
    Titles can be sized ranging from S to XL. They can be book (regular) or bold,
    based on content hierarchy.
  </p>
);

const textDescription = (
  <p>
    Texts can be sized ranging from S to L. They can be light, book (regular) or bold,
    based on content hierarchy or on emphasis.
  </p>
);

const usageDescription = (
  <p>
    Typography can be used via mixins and atomic classes. It is recommended that you use the mixins as specified in
    the user guide.
  </p>
);

const generateBody = ({ sizes, weights, type }: PyxisTypography): TableRow[] => (
  sizes.flatMap(
    (size) => weights.map(
      (weight) => [
        <Typography size={size} weight={weight} type={type} key={size + weight} />,
        <CopyableCode text={size} key={size} />,
        <CopyableCode text={weight} key={weight} />,
      ],
    ),
  )
);

const tableUsageBody: TableRow[] = [
  [
    'Title',
    <CopyableCode text="@include title($size, $weight)" key={shortid.generate()} />,
    <CopyableCode text=".title-$size--$weight" key={shortid.generate()} />,
  ],
  [
    'Text',
    <CopyableCode text="@include text($size, $weight)" key={shortid.generate()} />,
    <CopyableCode text=".text-$size--$weight" key={shortid.generate()} />,
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Typography" description={typographyDescription} category="Foundation" isMain />
    <OverviewTemplate title="Title" description={titleDescription}>
      <Table
        head={['Sample', 'Size', 'Weight']}
        body={generateBody(pyxisTitle)}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Text" description={textDescription}>
      <Table
        head={['Sample', 'Size', 'Weight']}
        body={generateBody(pyxisText)}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Usage" description={usageDescription}>
      <Table
        head={['Name', 'Mixin', 'Atomic class']}
        body={tableUsageBody}
        gridTemplateColumns="20%"
      />
    </OverviewTemplate>
  </>
);

export default Overview;
