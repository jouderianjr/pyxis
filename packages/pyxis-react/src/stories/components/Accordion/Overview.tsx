import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Accordion from "./Accordion";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Accordions are used to expand and collapse content related to a given heading,
      allowing larger sections of information to be presented to the user in a more understandable format.
    </p>
  </>
);

const variantDescription = (
  <p>
    Accordion can have different background.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <Accordion id="default" key={shortid.generate()} onlyItem />,
    'Default'
  ],
  [
    <div className="bg-neutral-95 padding-xs" key={shortid.generate()}>
      <Accordion id="light" onlyItem color="white"/>
    </div>,
    'Light Background'
  ],
];

const addonDescription = (
  <p>
    Accordion header also supports addon. Image and icon are mutually exclusive, while the action text is
    a message that should help the user to better understand the toggle icon.
  </p>
);

const generateAddonBody = (): TableRow[] =>  [
  [
    <Accordion id="action-text" key={shortid.generate()} onlyItem hasActionText/>,
    'With action text'
  ],
  [
    <Accordion id="icon" key={shortid.generate()} onlyItem hasIcon />,
    'With icon'
  ],
  [
    <Accordion id="image" key={shortid.generate()} onlyItem hasImage/>,
    'With image'
  ],
];

const altDescription = (
  <p>
    Accordion also support an "alt" version for dark background.
  </p>
);

const generateAltBody = (): TableRow[] =>  [
  [
    <div className="bg-neutral-base padding-xs" key={shortid.generate()} >
      <Accordion id="alt" onlyItem alt/>
    </div>,
    'Alt version',
  ]
];

const behaviourDescription = (
  <p>
    Accordion has two strategies to manage the opening behaviour, in fact items could be all opened
    at the same time or just once at time.
  </p>
)

const accessibilityDescription = (
  <p>
    Each header should mutually linked to its section through the ARIA
    attributes <code>aria-controls</code> and <code>aria-labelledby</code>. Also, the current state
    of each item should be reported to <code>aria-expanded</code> attribute in the header.
  </p>
)

const classDescription = (
  <p>
    Accordion is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="accordion" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item" key={shortid.generate()} />,
    'Item Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item--light" key={shortid.generate()} />,
    'Variant Modifier',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item--alt" key={shortid.generate()} />,
    'Alternative Background Modifier',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header" key={shortid.generate()} />,
    'Header Element',
    <code key={shortid.generate()}>button</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__addon" key={shortid.generate()} />,
    'Addon Element',
    <code key={shortid.generate()}>button</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__addon" key={shortid.generate()} />,
    'Addon Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__content-wrapper" key={shortid.generate()} />,
    'Content Wrapper Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__title" key={shortid.generate()} />,
    'Title Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__subtitle" key={shortid.generate()} />,
    'Subtitle Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__action-wrapper" key={shortid.generate()} />,
    'Action Wrapper Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__action-label" key={shortid.generate()} />,
    'Action Label Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__action-icon" key={shortid.generate()} />,
    'Action Icon Element',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__header__action-icon--open" key={shortid.generate()} />,
    'Icon Element Modifier',
    <code key={shortid.generate()}>div</code>,
  ],
  [
    <CopyableCode text="accordion-item__panel" key={shortid.generate()} />,
    'Panel Element',
    <code key={shortid.generate()}>section</code>,
  ],
  [
    <CopyableCode text="accordion-item__panel--open" key={shortid.generate()} />,
    'Panel Element Modifier',
    <code key={shortid.generate()}>section</code>,
  ],
  [
    <CopyableCode text="accordion-item__panel__inner-wrapper" key={shortid.generate()} />,
    'Panel Content Element',
    <code key={shortid.generate()}>div</code>,
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Accordion 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-display-accordion-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Variants", "Header Addons", "Alt background", "Behaviour", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant']}
        body={generateVariantBody()}
        gridTemplateColumns="50%"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Header Addons" description={addonDescription}>
      <Table
        head={['Sample', 'Addon', 'Note']}
        body={generateAddonBody()}
        gridTemplateColumns="50%"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Alt Background" description={altDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateAltBody()}
        gridTemplateColumns="50%"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Behaviour" description={behaviourDescription}/>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription}/>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="400px"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
