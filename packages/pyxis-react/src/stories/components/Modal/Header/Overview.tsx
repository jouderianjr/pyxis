import React, { FC } from "react";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import shortid from "shortid";
import {linkTo} from "@storybook/addon-links";
import Header from "components/Modal/Header";
import {IconCar} from "components/Icon/Icons";
import Badge from "components/Badge";

const overviewDescription = (
  <p>
    The Modal.Header component provides an header to the Modal component. It could display a title, an Icon or a Badge,
    and, if an proper callback is provided, the closing button.
  </p>
);

const addonDescription = (
    <p>
      Modal.Header can hold a badge or a icon (mutually exclusive) to better describe the content of the Modal itself.
    </p>
);

const generateAddonBody = (): TableRow[] => [
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Header icon={<IconCar />} id="header-icon" title="Modal Header" key={shortid.generate()} />
    </div>,
    <code>Icon</code>
  ],
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Header badge={<Badge>Badge</Badge>} id="header-icon" title="Modal Header" key={shortid.generate()} />
    </div>,
    <code>Badge</code>,
  ],
];

const stickyDescription = (
    <p>
      Modal.Header can be sticky. <span className="link" onClick={linkTo('components-display-modal-all-stories--with-sticky-header-and-footer')}>
      See the related story
    </span>.
    </p>
);

const customDescription = (
    <p>
      For particular style or content, could be useful to fully customize the header. Doing that is possible, just writing the
      custom content as children, but please note that doing this will overwrite the default structure and props.
    </p>
);

const apiDescription = (
  <p>
    Use props below to change modal configuration and behaviour.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Modal.Header" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <div className="bg-neutral-95 padding-m">
          <Story id="components-display-modal-modal-header-stories--header-default" />
        </div>
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Addons", "Sticky Header", "Custom Header", "Component API"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Addon" description={addonDescription}>
      <Table
        head={['Sample', 'Addon']}
        body={generateAddonBody()}
        gridTemplateColumns="500px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Sticky Header" description={stickyDescription}/>
    <OverviewTemplate title="Custom Header" description={customDescription}>
      <Canvas>
        <div className="bg-neutral-95 padding-m">
          <Story id="components-display-modal-modal-header-stories--custom-header"/>
        </div>
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Header} />
    </OverviewTemplate>
  </>
);

export default Overview;
