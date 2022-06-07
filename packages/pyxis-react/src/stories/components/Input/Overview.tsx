import React, { FC } from "react";
import {ArgsTable, Canvas, PRIMARY_STORY, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import {IconPlate} from "components/Icon/Icons";
import Input from "components/Form/Input";
import {linkTo} from "@storybook/addon-links";

const overviewDescription = (
  <>
    <p>
      Input is used when the user should include short form content, including text, numbers, e-mail addresses, or passwords.
    </p>
    <p>
      Input component just renders the input field with its addon. To display a label, hint or error message,
      please wrap the Input component inside a <span className="link" onClick={linkTo('components-form-🚧-item--page')}>
      Form.Item</span>.
    </p>
  </>
);

const stateDescription = (
  <>
    <p>
      Inputs have default (with placeholder), hover, focus, filled, error and disable states.
    </p>
    <p>
      <strong className="text-l-bold">Hint:</strong> Interact with components to see hover and focus states.
    </p>
  </>
);

const generateStateBody = (): TableRow[] => [
  [
    <Input placeholder="Input field" />,
    "Default",
  ],
  [
    <Input value="Input field"/>,
    "Filled / Validate",
  ],
  [
    <Input placeholder="Input field" hasError />,
    "Error",
  ],
  [
    <Input placeholder="Input field" disabled />,
    "Disabled",
  ],
];

const addonDescription = (
  <>
    <p>
      Input can hold an addon, that could be a string or an <code>Icon</code>.
      Addons are used to make the user better understand the purpose of the field.
    </p>
    <p>
      <strong className="text-l-bold">Please Note:</strong> use these addons one at a time.
    </p>
  </>
);

const generateAddonBody = (): TableRow[] => [
  [
    <Input  placeholder="Input field" addon={IconPlate} />,
    "Icon Prepend",
  ],
  [
    <Input  placeholder="Input field" addon={IconPlate} addonPlacement="append" />,
    "Icon Append",
  ],
  [
    <Input  placeholder="Input field" addon="€" />,
    "Text Prepend",
  ],
  [
    <Input  placeholder="Input field" addon="mq" addonPlacement="append" />,
    "Text Append",
  ],
];

const sizeDescription = (
  <p>
    Input can have two size: default or small.
  </p>
);

const generateSizeBody = (): TableRow[] => [
  [
    <Input placeholder="Input field" />,
    "Default",
  ],
  [
    <Input placeholder="Input field" size="small" />,
    "Small",
  ],
  [
    <Input placeholder="Input field" size="small" addon={IconPlate}/>,
    "Small with Icon",
  ],
  [
    <Input placeholder="Input field" size="small" addon="€"/>,
    "Small with Text",
  ],
];

const accessibilityDescription = (
  <>
    <p>
      Both when you use the <code>Input</code> component as <code>Form.Input</code> inside a <code>Form.Item</code> and when
      you use it as a standalone component, please remember to add a label that describes the type of content expected
      by the input.
    </p>
    <p>
      However, there are some differences in the approaches above, as in the first case the association between
      input and label is automatic, in the second one you should remember to associate them explicitly by adding
      the <code>for</code> attribute to the label equal to the <code>id</code> of the input.
    </p>
    <p>
      If for some reasons you do not want a visible label, please provide an accessible label to the screen readers through
      the <code>aria-label</code> attribute.
    </p>
    <p>
      Also, if <code>Input</code> is used as a standalone component, remember to populate the props <code>errorId</code> and&nbsp;
      <code>hintId</code> if an error message or a hint is present.
    </p>
  </>
);

const apiDescription = (
  <p>
    Input component could be customized through the following props.
  </p>
);

const classDescription = (
  <p>
    The list of Input CSS classes is
    available <a href="https://prima.design/3794e337c/p/56c1da-text-field/t/423eb9" className="link" target="_blank">on
    zeroheight documentation</a>.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Input" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-input-all-stories--inside-form-item" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["State", "Addon", "Size", "Accessibility", "Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="State" description={stateDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateStateBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Addon" description={addonDescription}>
      <Table
        head={['Sample', 'Addon']}
        body={generateAddonBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizeDescription}>
      <Table
        head={['Sample', 'Size']}
        body={generateSizeBody()}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Input} />
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}/>
  </>
)

export default Overview;
