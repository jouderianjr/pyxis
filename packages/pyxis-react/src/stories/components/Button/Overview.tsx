import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import Button from "components/Button";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import shortid from "shortid";
import CopyableCode from "stories/utils/CopyableCode";
import {IconPenEdit} from "components/Icon/Icons";
import {
  buttonIconPlacements,
  buttonSizes,
  buttonVariant,
  iconPlacementUsage,
  sizeUsage,
  variantUsage
} from "./common";

const overviewDescription = (
  <>
    <p>
      Buttons allow the user to perform actions and make decisions with a single tap or click.
      <br/>
      Use buttons to take a user from one point of the experience to another.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component,
      in addition to these properties the component also supports all the&nbsp;
      <a className="link" target="_blank" href="https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/react/index.d.ts#L2059">properties</a>
      &nbsp;of a <code>{`<button>`}</code> component,
      in case you want to render an <code>{`<a>`}</code>, just use the <a className="link" href="#link" target="_self">attribute href</a>,
      in this way the allowed&nbsp;
      <a className="link" target="_blank" href="https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/react/index.d.ts#L2023">properties</a>
      &nbsp;will become those of an <code>{`<a>`}</code>.
    </p>
  </>
);

const variantDescription = (
  <p>
    Variants set the visual style of the button, each button should have a visual hierarchy in the page.
    <br/>
    Variants help the user to understand this hierarchy.
  </p>
);

const generateVariantBody = (): TableRow[] => buttonVariant.map(variant => [
  <Button variant={variant}>Button</Button>,
  <CopyableCode text={variant} key={shortid.generate()} />,
  variantUsage(variant)
]);

const sizesDescription = (
  <p>
    Sizes set the occupied space of the button.
    <br />
    They can be useful when the actions need to be more prominent or when the space for the actions is little.
  </p>
);

const generateSizesBody = (): TableRow[] => buttonSizes.map(size => [
  <Button size={size}>Button</Button>,
  <CopyableCode text={size} key={shortid.generate()} />,
  sizeUsage(size)
]);

const iconsDescription = (
  <p>
    Buttons can also accommodate an icon. The icon can be inserted in the append or prepend of the label.
    The button can also contain only the icon, in this case it is advisable to add an <code>aria-label</code> to
    the button to improve accessibility.
  </p>
);

const generateIconsBody = (): TableRow[] => buttonIconPlacements.map(placement => [
  <Button iconPlacement={placement} icon={IconPenEdit}>Button</Button>,
  <CopyableCode text={placement} key={shortid.generate()} />,
  iconPlacementUsage(placement)
]);

const optionsDescription = (
  <p>
    Below are all the remaining parameters that change the appearance. All this options are boolean.
  </p>
);

const generateOptionsBody = (): TableRow[] => [
  [
    <Button shadow>Button</Button>,
    <CopyableCode text="shadow" key={shortid.generate()} />,
    'Adds a shadow to the button. Is only allowed with `primary` or `brand` variant.'
  ],
  [
    <Button loading>Button</Button>,
    <CopyableCode text="loading" key={shortid.generate()} />,
    'Adds a loading animation to the button. This option removes the ability to click the button. Is not allowed with `ghost` variant.'
  ],
  [
    <Button disabled>Button</Button>,
    <CopyableCode text="disabled" key={shortid.generate()} />,
    '-'
  ],
  [
    <Button contentWidth>Button</Button>,
    <CopyableCode text="contentWidth" key={shortid.generate()} />,
    'Remove the min-width to the button. Is not allowed with `ghost` variant and iconPlacement `only`'
  ],
  [
    <div className="alt-wrapper">
      <Button alt>Button</Button>
    </div>,
    <CopyableCode text="alt" key={shortid.generate()} />,
    'Use on dark background.'
  ],
];

const linkDescription = (
  <p>
    The <code>href</code> prop allow to specify an address.
    This will change the underlying <code>Button</code> element to be rendered as an <code>a</code> anchor element.
  </p>
);

const generateLinksBody = (): TableRow[] => [
  [
    <Button href="https://prima.it">Button</Button>,
    'An anchor with the style of a button'
  ],
];

const accessibilityDescription = (
  <>
    <p>
      When you use the iconPlacement `only` options remember to add
      the prop <code>aria-label</code> to component with a meaningful label for users relying on screen readers.
    </p>
  </>
);

const classDescription = (
  <>
    <p>
      Button component is based upon this list of CSS classes.
    </p>
    <p>
      <strong>Please note</strong>: In a React or Elm environment using the appropriate prop to change
      size or variant is mandatory.
    </p>
  </>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="button" key={shortid.generate()} />,
    'Base Class',
    '-',
  ],
  [
    <CopyableCode text="button--primary" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--secondary" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--tertiary" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--brand" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--ghost" key={shortid.generate()} />,
    'Variant Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--huge" key={shortid.generate()} />,
    'Size Modifier',
    'Is only allowed with with `primary` variant.',
  ],
  [
    <CopyableCode text="button--large" key={shortid.generate()} />,
    'Size Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--medium" key={shortid.generate()} />,
    'Size Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--small" key={shortid.generate()} />,
    'Size Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--prepend-icon" key={shortid.generate()} />,
    'Icon Placement Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--append-icon" key={shortid.generate()} />,
    'Icon Placement Modifier',
    '-',
  ],
  [
    <CopyableCode text="button--icon-only" key={shortid.generate()} />,
    'Icon Placement Modifier',
    'Is not allowed with with `small` size.',
  ],
  [
    <CopyableCode text="button--shadow" key={shortid.generate()} />,
    'Shadow Modifier',
    'Is only allowed with `primary` or `brand` variant.',
  ],
  [
    <CopyableCode text="button--loading" key={shortid.generate()} />,
    'Loading Modifier',
    'Is not allowed with `ghost` variant.',
  ],
  [
    <CopyableCode text="button--content-width" key={shortid.generate()} />,
    'Content Width Modifier',
    'Is not allowed with `ghost` variant and iconPlacement `only`',
  ],
  [
    <CopyableCode text="button--alt" key={shortid.generate()} />,
    'Alternative Background Modifier',
    '-',
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Button" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-action-button-all-stories--primary" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Variant", "Size", "With Icon", "Generic Options", "Link", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Variant" description={variantDescription}>
      <Table
        head={['Sample', 'Variant', 'Usage']}
        body={generateVariantBody()}
        gridTemplateColumns="240px 200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizesDescription}>
      <Table
        head={['Sample', 'Size', 'Usage']}
        body={generateSizesBody()}
        gridTemplateColumns="240px 200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="With Icon" description={iconsDescription}>
      <Table
        head={['Sample', 'Placement', 'Usage']}
        body={generateIconsBody()}
        gridTemplateColumns="240px 200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Generic Options" description={optionsDescription}>
      <Table
        head={['Sample', 'Option', 'Usage']}
        body={generateOptionsBody()}
        gridTemplateColumns="240px 200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Link" description={linkDescription}>
      <Table
        head={['Sample', 'Usage']}
        body={generateLinksBody()}
        gridTemplateColumns="240px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="240px"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
