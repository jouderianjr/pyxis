import React, { FC } from "react";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import {IconCar, IconDownload} from "components/Icon/Icons";
import ButtonCard from "components/ButtonCard";
import {linkTo} from "@storybook/addon-links";

const overviewDescription = (
  <p>
    ButtonCard are a type of special button that provides both a title and a subtitle, and also an icon. It is mainly used for the download of files.
  </p>
);

const variantsDescription = (
  <p>
    The ButtonCard is effectively a button, but it also has some display options available.
  </p>
);

const generateOptionsBody = (): TableRow[] => [
  [
    <ButtonCard icon={IconDownload} subtitle="Subtitle">Button title</ButtonCard>,
    <CopyableCode text="subtitle" key={shortid.generate()} />,
    'Adds a subtitle to the button.'
  ],
  [
    <ButtonCard icon={IconCar} subtitle="Subtitle">Button title</ButtonCard>,
    <CopyableCode text="icon" key={shortid.generate()} />,
    'The icon is customizable.'
  ],
  [
    <ButtonCard icon={IconDownload} loading>Button title</ButtonCard>,
    <CopyableCode text="loading" key={shortid.generate()} />,
    'Adds a loading animation to the button. This option removes the ability to click the button.'
  ],
  [
    <ButtonCard icon={IconDownload} disabled>Button title</ButtonCard>,
    <CopyableCode text="disabled" key={shortid.generate()} />,
    '-'
  ],
  [
    <div className="alt-wrapper">
      <ButtonCard icon={IconDownload} alt>Button title</ButtonCard>
    </div>,
    <CopyableCode text="alt" key={shortid.generate()} />,
    'Use on dark background.'
  ],
];

const linkDescription = (
  <p>
    Like the <span className="link" onClick={linkTo('components-button-overview--page')}>Button</span> component, the ButtonCard can also be an anchor, so we can use the anchor attributes (such as href and download) on it.
  </p>
);


const apiDescription = (
  <p>
    ButtonCard could be customized through the following props.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Button Card" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-buttoncard-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Variants", "Link", "Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantsDescription}>
      <Table
        head={['Sample', 'Variant', 'Usage']}
        body={generateOptionsBody()}
        gridTemplateColumns="240px 200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Link" description={linkDescription}>
      <Canvas>
        <Story id="components-buttoncard-all-stories--with-href" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={ButtonCard} />
    </OverviewTemplate>
  </>
)

export default Overview;