import React, {FC} from 'react';
import OverviewTemplate from 'stories/utils/OverviewTemplate';
import Table, {TableRow} from 'stories/utils/Table';
import shortid from 'shortid';
import CopyableCode from 'stories/utils/CopyableCode';
import {Source} from "@storybook/addon-docs";
import {linkTo} from "@storybook/addon-links";

const layoutDescription = (
  <p>
    Hiding rules are utilities used to hide an element in a particular breakpoint.
  </p>
);

const usageDescription = (
  <p>
    Hiding rules can be used via mixins and atomic classes.
  </p>
);

const hideMixinDescription = (
  <>
    <h4 className="title-s-bold c-neutral-base margin-b-2xs">
      Mixin <CopyableCode text="hide($fromBreakpoint, $untilBreakpoint)" key={shortid.generate()} />
    </h4>
    <p className="margin-b-2xs">
      Use this mixin to hide an element from a specific breakpoint or in a range of breakpoints.<br />
      You can find all the breakpoint list in the <span className="link" onClick={linkTo('foundations-layout--page')}>layout</span> page.
    </p>
    <p>
      <strong>Please note</strong>
      : You cannot use a <code>$untilBreakpoint</code> value smaller or equal than <code>$fromBreakpoint</code> value.
    </p>
    <Source dark language={"css"} code={
    `
.element {
  @include pyxis.hide(small);
}

// Compiles to 
// @media screen and (min-width:768px) {
//  .element {
//    display: none;
//  }
// }

.element {
  @include pyxis.hide(small, medium);
}

// Compiles to 
// @media screen and (min-width:768px) and (max-width:991px) {
//   .element {
//     display: none;
//   }
// }
`
    } />
  </>
);

const hideScrollbarMixinDescription = (
  <>
    <h4 className="title-s-bold c-neutral-base margin-b-2xs">
      Mixin <CopyableCode text="hideScrollbar()" key={shortid.generate()} />
    </h4>
    <p className="margin-b-2xs">
      Use this mixin to hide the scrollbar inside an element. Using this mixin sparingly could penalize ux.
    </p>
    <Source dark language={"css"} code={
      `
.element {
  @include pyxis.hideScrollbar;
}
`
    } />
  </>
);

const tableUsageBody: TableRow[] = [
  [
    'Hide',
    <CopyableCode text=".hide" key={shortid.generate()} />,
  ],
  [
    'Hide on specific breakpoint',
    <CopyableCode text=".hide-on-$breakpoint" key={shortid.generate()} />,
  ],
  [
    'Hide from specific breakpoint',
    <CopyableCode text=".hide-from-$breakpoint" key={shortid.generate()} />,
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Hiding" description={layoutDescription} category="Foundation" isMain />
    <OverviewTemplate title="Usage" description={usageDescription}>
      {hideMixinDescription}
      {hideScrollbarMixinDescription}
      <div className="title-s-bold c-neutral-base">Classes</div>
      <Table
        head={['Name', 'Atomic class']}
        body={tableUsageBody}
      />
    </OverviewTemplate>
  </>
);

export default Overview;
