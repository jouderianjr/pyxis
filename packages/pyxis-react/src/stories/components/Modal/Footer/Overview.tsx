import React, { FC } from "react";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import shortid from "shortid";
import {linkTo} from "@storybook/addon-links";
import Footer from "components/Modal/Footer";
import Button from "components/Button";

const buttons = <>
  <Button variant={"secondary"}>Secondary</Button>
  <Button variant={"primary"}>Primary</Button>
</>

const overviewDescription = (
    <p>
      The Modal.Footer component provides a slot where the Modal actions are displayed. Also, it can display additional text.
    </p>
);

const elementsDescription = (
  <p>
    Modal.Footer have a slot for actions and also for additional text.
  </p>
);

const generateElementsBody = (): TableRow[] => [
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Footer
        buttons={buttons}
        id="footer-buttons"
        key={shortid.generate()}
      />
    </div>,
    <code>Buttons</code>
  ],
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Footer text="Footer text" id="footer-text" key={shortid.generate()} />
    </div>,
    <code>Text</code>,
  ],
];

const optionsDescription = (
  <p>
    Modal.Footer have the following options.
  </p>
);

const generateOptionsBody = (): TableRow[] => [
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Footer
        buttons={buttons}
        id="footer-sticky"
        key={shortid.generate()}
        isSticky
      />
    </div>,
    'Sticky',
    <span onClick={linkTo('components-modal-all-stories--with-sticky-header-and-footer')} className="link">
      See the related story
    </span>
  ],
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Footer
        buttons={buttons}
        id="footer-buttons"
        key={shortid.generate()}
        alt
      />
    </div>,
    'Alt',
    '-'
  ],
  [
    <div className="bg-neutral-95 padding-xs full-width">
      <Footer
        buttons={buttons}
        id="footer-buttons"
        key={shortid.generate()}
        hasFullWidthButtons
      />
    </div>,
    'Full width buttons on bottomsheet',
    <span onClick={linkTo('components-modal-modal-footer-stories--with-full-width-buttons')} className="link">
      See the related story
    </span>
  ],
];

const customDescription = (
  <p>
    For particular style or content, could be useful to fully customize the footer. Doing that is possible, just writing the
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
    <OverviewTemplate title="Modal.Footer" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <div className="bg-neutral-95 padding-m">
          <Story id="components-modal-modal-footer-stories--footer-default" />
        </div>
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Elements", "Options", "Custom Footer", "Component API"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Elements" description={elementsDescription}>
      <Table
        head={['Sample', 'Element']}
        body={generateElementsBody()}
        gridTemplateColumns="500px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Options" description={optionsDescription}>
      <Table
        head={['Sample', 'Element']}
        body={generateOptionsBody()}
        gridTemplateColumns="500px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Custom Footer" description={customDescription}>
      <Canvas>
        <div className="bg-neutral-95 padding-m">
          <Story id="components-modal-modal-footer-stories--custom-footer"/>
        </div>
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Footer} />
    </OverviewTemplate>
  </>
);

export default Overview;
