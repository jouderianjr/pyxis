import React, {FC} from "react";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewIndex from "stories/utils/OverviewIndex";
import {pascalToKebab} from "commons/utils/string";
import Item from "components/Form/Item";

const overviewDescription = (
  <>
    <p>
      The Form Item is used to group label, field, error/hint or other custom HTML. It's a wrapper that is useful to
      display elements with the right space and order.
    </p>
    <p>
      Even if in the examples below the <code>Item</code> component is used, it's recommendable to use the exported
      component <code>Form.Item</code>.
    </p>
  </>
);

const elementDescription = (
  <p>
    Form Item could hold a Label, a field (Input, Textarea, Radiogroups...) and a custom HTML content. You can find some
    examples in the related stories.
  </p>
);

const variantDescription = (
  <p>
    Item could also display a hint or error message.
  </p>
);

const apiDescription = (
  <p>
    Form item could be customized through the following props.
  </p>
);

// @TODO: add the link once the zeroheight doc is available
const classDescription = (
  <p>
    The list of Form.Item CSS classes is
    available <a href="#" className="link" target="_blank">on
    zeroheight documentation</a>.
  </p>
);

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Form Item" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-form-item-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Element composition", "Variants", "Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Element composition" description={elementDescription}/>
    <OverviewTemplate title="Variants" description={variantDescription}>
      {['With hint', 'With error'].map(variant => (
        <>
          <strong>{variant}</strong>
          <Canvas className="full-width">
            <Story id={`components-form-item-all-stories--${pascalToKebab(variant)}`} />
          </Canvas>
        </>
      ))}
    </OverviewTemplate>
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Item} />
    </OverviewTemplate>
    {/* @TODO: remove comment below once doc on zeroheight is available */}
    {/*<OverviewTemplate title="Overview of CSS classes" description={classDescription}/>*/}
  </>
)

export default Overview;
