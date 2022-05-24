import React, {FC} from 'react';
import OverviewTemplate from 'stories/utils/OverviewTemplate';
import Table, {TableRow} from 'stories/utils/Table';
import shortid from 'shortid';
import CopyableCode from 'stories/utils/CopyableCode';
import {spacings, SpacingRow} from './common';
import { Spacing } from './Spacing';
import {Source} from "@storybook/addon-docs";

const spacingDescription = (
  <>
    <p>
      With almost endless combinations of font, images, and spacing available to use in our designs,
      it&apos;s easy to fall into the trap of sticking with what you know. But if we want people to take
      our interface seriously, we must consider the importance of spacing consistency among all the elements.
    </p>
    <p>
      Spacing helps page components breathe. Every part of a UI should be intentional including the empty space between elements.
      The amount of space between items creates relationships and hierarchy.
    </p>
  </>
);

const usageDescription = (
  <>
    <p>
      Spacing can be used via mixins, functions and atomic classes.
      It is recommended that you use the mixin as specified in the user guide.
    </p>
  </>
);

const functionDescription = (
  <>
    <div className="title-s-bold c-neutral-base">
      Retrieve a space value: <CopyableCode text="spacing($sizes)" key={shortid.generate()} />
    </div>
    <p>
      Use this function to retrieve the value in rem of the token (or list of tokens) passed as argument.
    </p>
    <Source dark language={"css"} code={
      `
gap: spacing(s); 
padding: spacing(m l); 

// Compiles to 
//   gap: 16px;
//   padding: 20px 24px;
        `
    } />
  </>
)

const mixinDescription = (
  <>
    <div className="title-s-bold c-neutral-base">
      Retrieve a space value with responsive behaviour: <CopyableCode text="@include responsiveSpacing($property, $sizes...)" key={shortid.generate()} />
    </div>
    <p>
      Use this mixin to add a spacing with a responsive behaviour. As first argument the property name should be passed,
      then the list of sizes across various breakpoints, in the following order: <code>$fromBase, $fromXxSmall,
      $fromXSmall, $fromSmall, $fromMedium, $fromLarge, $fromXLarge</code>. Among them, only <code>$fromBase</code> is mandatory.
    </p>
    <Source dark language={"css"} code={
      `
@include responsiveSpacing('gap', s, $fromMedium: m, $fromLarge: l);
@include responsiveSpacing('padding', m l, $fromMedium: l xl);

// Compiles to
//   gap: 16px;
//   padding: 20px 24px;
//   
//   @media screen and (min-width: 992px) {
//     gap: 20px;
//     padding: 24px 32px;
//   }
//   
//   @media screen and (min-width: 1200px) {
//     gap: 24px;
//   }
        `
    }/>
  </>
)

const generateRow = ({ size, value }: SpacingRow): TableRow => [
  <Spacing size={size} key={size + value} />,
  <CopyableCode text={size} key={size} />,
  <code key={value}>{`${value}px`}</code>,
];

const tableUsageBody: TableRow[] = [
  [
    'Padding',
    <CopyableCode text=".padding-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Padding on specific edge',
    <CopyableCode text=".padding-$edge-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Vertical padding',
    <CopyableCode text=".padding-v-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Horizontal padding',
    <CopyableCode text=".padding-h-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Margin',
    <CopyableCode text=".margin-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Margin on specific edge',
    <CopyableCode text=".margin-$edge-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Vertical margin',
    <CopyableCode text=".margin-v-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Horizontal margin',
    <CopyableCode text=".margin-h-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Vertical space',
    <CopyableCode text=".space-v-$size" key={shortid.generate()} />,
    'Add a margin-bottom to element, unless it is the last child'
  ],
  [
    'Horizontal space',
    <CopyableCode text=".space-h-$size" key={shortid.generate()} />,
    'Add a margin-right to element, unless it is the last child'
  ],
  [
    'Row gap',
    <CopyableCode text=".row-gap-$size" key={shortid.generate()} />,
    '-'
  ],
  [
    'Column gap',
    <CopyableCode text=".column-gap-$size" key={shortid.generate()} />,
    '-'
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Spacing" description={spacingDescription} category="Foundation" isMain>
      <Table
        head={['Sample', 'Size', 'Value']}
        body={spacings.map(generateRow)}
        gridTemplateColumns="120px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Usage" description={usageDescription}>
      {functionDescription}
      {mixinDescription}
      <div className="title-s-bold c-neutral-base">Classes</div>
      <Table
        head={['Name', 'Atomic class', 'Note']}
        body={tableUsageBody}
        gridTemplateColumns="25%"
      />
    </OverviewTemplate>
  </>
);

export default Overview;
