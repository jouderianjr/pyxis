import React, { FC } from 'react';
import { ArgsTable, Canvas, Story } from "@storybook/addon-docs";
import shortid from 'shortid';

import OverviewIndex from "stories/utils/OverviewIndex/OverviewIndex";
import OverviewTemplate from 'stories/utils/OverviewTemplate';
import Table, {TableRow} from 'stories/utils/Table';
import CopyableCode from 'stories/utils/CopyableCode';
import {Size, SizeRow, sizes, variants} from './common';
import * as icons from 'components/Icon/Icons';
import Icon from "components/Icon";

const { IconPrimaLogo } = icons;

const iconsDescription = (
  <>
    <p>
      Icons provide visual context and enhance usability, providing clarity and reducing cognitive load.
    </p>
    <p>
      Customize them providing a proper size and variant to the component and remember that the colour will
      be inherited from parent element.
    </p>
  </>
);

const accessibilityDescription = (
  <>
    <p>
      Non-decorative icons need to be read by screen reader, so if the icon to convey a message <strong>please remember
      to add the prop "description"</strong> to component with a meaningful label for users relying on screen readers.
    </p>
    <p>
      Moreover, please pay attention to icon colour as it should meet at least WCAG AA color contrast.
    </p>
  </>
);

const sizeDescription = (
  <p>
    Icons are available in small, medium and large sizes. The default size is medium.
  </p>
);

const variantDescription = (
  <>
    <p>
      Icons by default are the simple svg image. Boxed variants provide a more complex icon with a pre-assigned color
      and wrapped in a rounded box. They could have a neutral color that suggests an informational content, but
      they can be used also to give a feedback to the final user or to indicate a branded content.
    </p>
    <p>Remember to use the Alt variant in case the boxed icon is on a dark background.</p>
  </>
);

const classDescription = (
  <>
    <p>
      Icon component is based upon this list of CSS classes.
    </p>
    <p>
      <strong>Please note</strong>
      : In a React or Elm environment using the appropriate prop to change size or
      variant is mandatory.
    </p>
  </>
);

const apiDescription = (
  <p>
    Set props to change size or variant to icon.
  </p>
);

const generateSizeRow = ({ size, value }:SizeRow): TableRow => [
  <IconPrimaLogo size={size} key={size} />,
  <CopyableCode text={size} key={size} />,
  <code key={value}>{value}</code>,
];

const generateVariantBody = (): TableRow[] => [
  [
    <IconPrimaLogo key={shortid.generate()} />,
    '-',
    '-',
  ],
  ...variants.map((variant) =>
    [
      <IconPrimaLogo boxedVariant={variant} />,
      `boxed ${variant}`,
      '-'
    ]
  ),
  [
    <div className="bg-neutral-base padding-3xs">
      <IconPrimaLogo alt key={shortid.generate()} />
    </div>,
    'alt',
    'Use on dark background.',
  ],
];

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text=".icon" key={shortid.generate()} />,
    'Base',
    '-',
  ],
  [
    <CopyableCode text=".icon--size-s" key={shortid.generate()} />,
    'Size Modifier',
    '-',
  ],
  [
    <CopyableCode text=".icon--size-m" key={shortid.generate()} />,
    'Size Modifier',
    '-',
  ],
  [
    <CopyableCode text=".icon--size-l" key={shortid.generate()} />,
    'Size Modifier',
    '-',
  ],
  [
    <CopyableCode text=".icon--boxed" key={shortid.generate()} />,
    'Variant Modifier',
    'Neutral boxed variant',
  ],
  [
    <CopyableCode text=".icon--brand" key={shortid.generate()} />,
    'Variant Modifier',
    'Use it along with `.icon--boxed`',
  ],
  [
    <CopyableCode text=".icon--success" key={shortid.generate()} />,
    'Variant Modifier',
    'Use it along with `.icon--boxed`',
  ],
  [
    <CopyableCode text=".icon--alert" key={shortid.generate()} />,
    'Variant Modifier',
    'Use it along with `.icon--boxed`',
  ],
  [
    <CopyableCode text=".icon--error" key={shortid.generate()} />,
    'Variant Modifier',
    'Use it along with `.icon--boxed`',
  ],
  [
    <CopyableCode text=".icon--alt" key={shortid.generate()} />,
    'Variant Modifier',
    'Use with `.icon--boxed` on dark background.',
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Icons" description={iconsDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-display-icon-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Sizes", "Variants", "States", "Accessibility", "Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Sizes" description={sizeDescription}>
      <Table
        head={['Sample', 'Size', 'Value']}
        body={sizes.map(generateSizeRow)}
        gridTemplateColumns="100px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateVariantBody()}
        gridTemplateColumns="100px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Icon} />
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="250px"
      />
    </OverviewTemplate>
  </>
);

export default Overview;
