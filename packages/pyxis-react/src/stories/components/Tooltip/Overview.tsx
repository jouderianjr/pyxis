import React, {FC} from "react";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import {Canvas, Story} from "@storybook/addon-docs";
import shortid from "shortid";
import Tooltip from "./Tooltip";
import Button from "components/Button";
import {IconQuestionCircle} from "components/Icon/Icons";
import {linkTo} from "@storybook/addon-links";

const TooltipChildTemplate:FC<any> = (props) =>
  <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost" {...props}>Tooltip</Button>

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Tooltips display additional information upon hover or focus.
      The information should be contextual, useful, and shouldn't need to be visible at all times.
    </p>
  </>
);

const behaviourDescription = (
  <p>
    Tooltips are designed to behave like a bottomsheet on small screens. Bottomsheets have the same content
    as the tooltip, but also could have an additional title. &nbsp;
    <span className="link" onClick={linkTo('components-display-tooltip-🚧-all-stories--default-on-mobile')}>
      See the related story
    </span>.
  </p>
);

const positionDescription = (
  <p>
    Tooltips can appear in many directions relative to the trigger element.
  </p>
);

const generatePositionBody = (): TableRow[] =>  [
  [
    <Tooltip id="tooltip-id-top-left" key={shortid.generate()} position="topLeft"><TooltipChildTemplate /></Tooltip>,
    'Top Left'
  ],
  [
    <Tooltip id="tooltip-id-top" key={shortid.generate()} position="top"><TooltipChildTemplate /></Tooltip>,
    'Top'
  ],
  [
    <Tooltip id="tooltip-id-top-right" key={shortid.generate()} position="topRight"><TooltipChildTemplate /></Tooltip>,
    'Top Right'
  ],
  [
    <Tooltip id="tooltip-id-right" key={shortid.generate()}><TooltipChildTemplate /></Tooltip>,
    'Right'
  ],
  [
    <Tooltip id="tooltip-id-bottom-left" key={shortid.generate()} position="bottomRight"><TooltipChildTemplate /></Tooltip>,
    'Bottom Right'
  ],
  [
    <Tooltip id="tooltip-id-bottom" key={shortid.generate()} position="bottom"><TooltipChildTemplate /></Tooltip>,
    'Bottom'
  ],
  [
    <Tooltip id="tooltip-id-bottom-left" key={shortid.generate()} position="bottomLeft"><TooltipChildTemplate /></Tooltip>,
    'Bottom Left'
  ],
  [
    <Tooltip id="tooltip-id-left" key={shortid.generate()} position="left"><TooltipChildTemplate /></Tooltip>,
    'Left'
  ],
];

const variantDescription = (
  <p>
    Tooltips have a neutral background by default, but they can also be brand-colored.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <Tooltip id="tooltip-id-neutral" key={shortid.generate()}><TooltipChildTemplate /></Tooltip>,
    'Neutral'
  ],
  [
    <Tooltip id="tooltip-id-brand" key={shortid.generate()} variant="brand"><TooltipChildTemplate /></Tooltip>,
    'Brand'
  ]
];

const optionDescription = (
  <p>
    Tooltips can also have an icon or a customized behaviour on small screens.
  </p>
);

const generateOptionBody = (): TableRow[] =>  [
  [
    <Tooltip id="tooltip-id-with-icon" key={shortid.generate()} hasIcon><TooltipChildTemplate /></Tooltip>,
    'With Icon',
    '-'
  ],
  [
    <Tooltip id="tooltip-id-no-title" key={shortid.generate()} hasBottomSheetTitle={false}>
      <TooltipChildTemplate />
    </Tooltip>,
    'Without a bottomsheet title on mobile',
    <span>Not recommended -&nbsp;
      <span className="link" onClick={linkTo('components-display-tooltip-🚧-all-stories--no-bottomsheet-title')} key={shortid.generate()}>
        See the related story
      </span>
    </span>
  ],
];

const altDescription = (
  <p>
    Tooltips support also an "alt" version for dark background.
  </p>
);

const generateAltBody = (): TableRow[] =>  [
  [
    <div className="padding-s bg-neutral-base full-width" key={shortid.generate()} >
      <Tooltip id="tooltip-id-alt" alt position={"right"}><TooltipChildTemplate alt /></Tooltip>
    </div>,
    'Alt version',
  ]
];

const accessibilityDescription = (
  <>
    <p>
      On large screens, Tooltip element should have the <code>role</code> set to <code>tooltip</code>. Also, the element
      that triggers the tooltip should be have the ARIA attribute <code>aria-describedby</code> set with the ID of
      the tooltip element.
    </p>
    <p>
      When mobile and tooltip is in the bottomsheet the main <code>div</code> should always have <code>role="dialog"</code>
      and the attribute <code>aria-modal</code> set to <code>true</code>. Also, it should have the ARIA attribute
      <code>aria-labelledby</code> and <code>aria-describedby</code> set with the IDs of title, if present, and text respectively.
      Moreover, when the bottomsheet is not visible the <code>aria-hidden</code> attribute should be set to true.
    </p>
  </>
);

const classDescription = (
  <p>
    Tooltip and its bottomsheet are based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="tooltip-wrapper" key={shortid.generate()} />,
    'Wrapper Class',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--brand" key={shortid.generate()} />,
    'Variant Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--alt" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--top-left" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--top" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--top-right" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--right" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--bottom-right" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--bottom" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--bottom-left" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip--left" key={shortid.generate()} />,
    'Position Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
];

const tableBottomSheetClassBody: TableRow[] = [
  [
    <CopyableCode text="tooltip-wrapper" key={shortid.generate()} />,
    'Wrapper Class',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip-backdrop" key={shortid.generate()} />,
    'Backdrop Class',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip-backdrop--show" key={shortid.generate()} />,
    'Visibility Modifier',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="tooltip__header" key={shortid.generate()} />,
    'Header Element',
    <code key={shortid.generate()} >header, div</code>,
  ],
  [
    <CopyableCode text="tooltip__header__title" key={shortid.generate()} />,
    'Title Element',
    <code key={shortid.generate()} >div</code>,
  ],
  [
    <CopyableCode text="tooltip__header__close" key={shortid.generate()} />,
    'Close Element',
    <code key={shortid.generate()} >button</code>,
  ],
  [
    <CopyableCode text="tooltip__content" key={shortid.generate()} />,
    'Content Element',
    <code key={shortid.generate()} >div</code>,
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Tooltip 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-control-toggle-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Behaviour on mobile", "Available positions", "Variants", "Other options", "Alt Background", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Behaviour on mobile" description={behaviourDescription}/>
    <OverviewTemplate title="Available positions" description={positionDescription}>
      <Table
        head={['Sample', 'Position']}
        body={generatePositionBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant']}
        body={generateVariantBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Other options" description={optionDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateOptionBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Alt Background" description={altDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateAltBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <div className="title-s-bold c-neutral-base">Tooltip classes</div>
      <Table
        head={['Class', 'Type', 'Apply to']}
        body={tableClassBody}
        gridTemplateColumns="300px 1fr 1fr"
      />
      <div className="title-s-bold c-neutral-base">Bottomsheet classes</div>
      <Table
        head={['Class', 'Type', 'Apply to']}
        body={tableBottomSheetClassBody}
        gridTemplateColumns="300px 1fr 1fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
