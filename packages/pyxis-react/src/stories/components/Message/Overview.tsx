import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import Message from "./Message";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Message highlights feedback or information to the user about the process that he's following or the content
      that he's consuming.
    </p>
  </>
);

const stateDescription = (
  <p>
    Message can have a state that convey a meaning. Supported states are brand, success, error and alert.
    The last (alert) can be used only with a coloured background.
  </p>
);

const generateStateBody = (): TableRow[] =>  [
  [
    <Message key={shortid.generate()} state={"brand"}/>,
    'Brand',
    '-'
  ],
  [
    <Message key={shortid.generate()} state={"success"}/>,
    'Success',
    '-'
  ],
  [
    <Message key={shortid.generate()} state={"error"}/>,
    'Error',
    '-'
  ],
  [
    <Message key={shortid.generate()} state={"alert"} withBackground />,
    'Alert',
    'Available only with the coloured background.'
  ],
];

const variantDescription = (
  <p>
    Messages that have a state can be displayed with a coloured background that enforce the meaning expressed
    by the state itself. Also, messages are available in ghost mode for side information.
  </p>
);

const generateVariantBody = (): TableRow[] =>  [
  [
    <Message key={shortid.generate()} state={"brand"} withBackground />,
    'With coloured background',
    'Please use it only with states above.'
  ],
  [
    <Message key={shortid.generate()} ghost/>,
    'Ghost',
    'Available only with the default state.'
  ],
];

const optionDescription = (
  <p>
    Messages can be displayed also with no title or with a closing icon. Please note that with `ghost` variant
    the no-title option is mandatory.
  </p>
);

const generateOptionBody = (): TableRow[] => [
  [
    <Message key={shortid.generate()} withTitle={false} />,
    'With no title',
    '-'
  ],
  [
    <Message key={shortid.generate()} withClose={true} />,
    'With closing icon',
    'Not available with `ghost` variant.'
  ],
];

const accessibilityDescription = (
  <p>
    Message should have a <code>role</code> attribute set to <code>alert</code> when the state is "error",
    and set to <code>status</code> in all other cases. Also, please remember to add a proper description to the icon
    on the left when the state conveys a feedback (success, alert, error).
  </p>
);

const classDescription = (
  <p>
    Message is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="message" key={shortid.generate()} />,
    'Base Class',
    '-',
  ],
  [
    <CopyableCode text="message--brand" key={shortid.generate()} />,
    'State Modifier',
    '-',
  ],
  [
    <CopyableCode text="message--success" key={shortid.generate()} />,
    'State Modifier',
    '-',
  ],
  [
    <CopyableCode text="message--alert" key={shortid.generate()} />,
    'State Modifier',
    'Use it along with `message--with-background-color` class',
  ],
  [
    <CopyableCode text="message--error" key={shortid.generate()} />,
    'State Modifier',
    '-',
  ],
  [
    <CopyableCode text="message--ghost" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="message--with-background-color" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="message__icon" key={shortid.generate()} />,
    'Icon element',
    '-',
  ],
  [
    <CopyableCode text="message__title" key={shortid.generate()} />,
    'Title Element',
    '-',
  ],
  [
    <CopyableCode text="content-wrapper__title" key={shortid.generate()} />,
    'Content Wrapper Element',
    '-',
  ],
  [
    <CopyableCode text="message__text" key={shortid.generate()} />,
    'Text element',
    '-',
  ],
  [
    <CopyableCode text="message__close" key={shortid.generate()} />,
    'Close icon element',
    '-',
  ]
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Message 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-message-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["State", "Variants", "Other Options", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="State" description={stateDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateStateBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Variants" description={variantDescription}>
      <Table
        head={['Sample', 'Variant', 'Note']}
        body={generateVariantBody()}
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
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="300px 1fr 1fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
