import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Message from "components/Message";

const overviewDescription = (
  <>
    <p>
      Message highlights feedback or information to the user about the process that he's following or the content
      that he's consuming.
    </p>
  </>
);

const variantDescription = (
  <p>
    Message can have a state that convey a meaning. Supported states are brand, success, error and alert.
    The last (alert) can be used only with a coloured background.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <Message key={shortid.generate()} variant={"brand"}>Message text</Message>,
    'Brand',
    '-'
  ],
  [
    <Message key={shortid.generate()} variant={"success"}>Message text</Message>,
    'Success',
    '-'
  ],
  [
    <Message key={shortid.generate()} variant={"error"}>Message text</Message>,
    'Error',
    '-'
  ],
  [
    <Message key={shortid.generate()} variant={"alert"} hasColoredBackground>Message text</Message>,
    'Alert',
    'Available only with the coloured background.'
  ],
  [
    <Message key={shortid.generate()} variant={"ghost"}>Message text</Message>,
    'Ghost',
    'No colored background available'
  ],
];

const backgroundDescription = (
  <p>
    Messages that have a state can be displayed with a coloured background that enforce the meaning expressed
    by the state itself.
  </p>
);

const generateBackgroundBody = (): TableRow[] =>  [
  [
    <Message key={shortid.generate()} variant={"brand"} hasColoredBackground>Message text</Message>,
    'With coloured background',
    'Please use it only with states above.'
  ],
];

const optionDescription = (
  <p>
    Messages can be displayed also with a title or with a closing icon. Please note that with `ghost` variant
    the no-title option is mandatory.
  </p>
);

const generateOptionBody = (): TableRow[] => [
  [
    <Message key={shortid.generate()} title="Message title">Message text</Message>,
    'With title',
    'Not available on `ghost` variant'
  ],
  [
    <Message key={shortid.generate()} onClose={() => {}}>Message text</Message>,
    'With closing icon',
    'Not available with `ghost` variant.'
  ],
];

const accessibilityDescription = (
  <p>
    Message has a <code>role</code> attribute set to <code>alert</code> when the state is "error",
    and set to <code>status</code> in all other cases. Please remember to pass the <code>onCloseAccessibleLabel</code> prop
    when the closing icon is visible.
  </p>
);

const apiDescription = (
  <p>
    Use props below to change message configuration and behaviour.
  </p>
);

const classDescription = (
  <p>
    The list of Message CSS classes is
    available <a href="https://prima.design/3794e337c/p/2339d4-message/b/539068" className="link" target="_blank">on zeroheight documentation</a>.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Message" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-message-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Variants", "With colored background", "Other Options", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateVariantBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="With colored background" description={backgroundDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateBackgroundBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Other Options" description={optionDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateOptionBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Message} />
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}/>
  </>
)

export default Overview;
