import React, {FC} from "react";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import {Canvas, Story} from "@storybook/addon-docs";
import { linkTo } from '@storybook/addon-links';
import OverviewIndex from "stories/utils/OverviewIndex";
import CheckboxCard from "./CheckboxCard";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      Checkbox Card lets the user make zero or multiple selection from a list of options. In comparison to
      a normal checkbox, it's more graphical and appealing, as it can display an image or an icon and also
      has a slot for a more descriptive label. As normal checkbox, checkbox cards can be combined together
      in groups too, in order to have a clean user experience.
    </p>
  </>

);

const stateDescription = (
  <p>
    Checkboxes have idle, disabled, error, hover, and focus states.
  </p>
);

const generateStateBody = (): TableRow[] =>  [
  [
    <CheckboxCard key={shortid.generate()} />,
    'Idle'
  ],
  [
    <CheckboxCard checked key={shortid.generate()} />,
    'Checked'
  ],
  [
    <CheckboxCard error key={shortid.generate()} />,
    'Error'
  ],
  [
    <CheckboxCard disabled key={shortid.generate()} />,
    'Disabled'
  ]
];

const largeDescription = (
  <p>
    Checkbox cards are also available in a larger size. In this case, please remember that the addon is
    mandatory, and it could be only a image, neither a icon nor a text.
  </p>
)

const generateLargeBody = (): TableRow[] =>  [
  [
    <CheckboxCard checked isLarge key={shortid.generate()} />,
    'Large variant',
    'With the larger size adding a image as addon is mandatory.'
  ]
];

const addonDescription = (
  <p>
    Checkbox cards at the default size can have an icon addon or a text addon. In the first case it must
    be positioned on the left of the main text, in the other on the right.
  </p>
)

const generateAddonBody = (): TableRow[] =>  [
  [
    <CheckboxCard checked addon key={shortid.generate()} />,
    'With icon',
    'The icon must be placed on the left and have a `L` size.'
  ],
  [
    <CheckboxCard checked priceAddon key={shortid.generate()} />,
    'With extra text',
    'Text must be placed on the right.'
  ]
];

const otherDescription = (
  <p>
    In particular situations having a smaller text could be easier, so neither title nor description are
    required, but at least one of them has to be present.
  </p>
)

const generateOtherBody = (): TableRow[] =>  [
  [
    <CheckboxCard checked hasText={false} key={shortid.generate()} />,
    'Only with title'
  ],
  [
    <CheckboxCard checked hasTitle={false} key={shortid.generate()} />,
    'Only with description'
  ]
];

const groupDescription = (
  <>
    <p>
      Checkbox card can be organized in groups to provide structure to the content, placing element such as label
      and error message in a pleasant and clear way. Also, groups could display a hint message to help final user fill
      themselves.
    </p>
    <p>
      Cards are normally displayed vertically up to the <code>xsmall</code> breakpoint (768px),
      above it they are displayed horizontally. Anyways, some classes let the user display
      cards always horizontally or always vertically, regardless of the breakpoint.
    </p>
    <p>
      Usage Examples:
    </p>
    <ul className="list">
      <li className="list__item">
        <span className="link" onClick={linkTo('components-control-checkboxcard-🚧-all-stories--default')}>Default Layout</span>
      </li>
      <li className="list__item">
        <span className="link" onClick={linkTo('components-control-checkboxcard-🚧-all-stories--horizontal-layout')}>Horizontal Layout</span>
      </li>
      <li className="list__item">
        <span className="link" onClick={linkTo('components-control-checkboxcard-🚧-all-stories--vertical-layout')}>Vertical Layout</span>
      </li>
    </ul>
  </>
)

const accessibilityDescription = (
  <>
    <p>
      As always, when a image or an icon is present, please remember to add the <code>aria-label</code> attribute
      when the image has a meaning that help to understand the content. If the image or icon is purely decorative
      use the <code>aria-hidden</code> attribute instead.
    </p><p>
      A checkbox card group should have <code>role='group'</code> and a proper label, linked to it via the ARIA
      attribute <code>aria-labelledby</code>.
    </p><p>
      Moreover, when a error message is present, please remember that it also should be connected to the group
      by adding a proper id to the message and the <code>aria-describedby</code> attribute to the group.
    </p>
  </>
);

const classDescription = (
  <p>
    Checkbox card group is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="form-card" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="form-card--checked" key={shortid.generate()} />,
    'State Modifier',
    <code key={shortid.generate()}>label</code>,
    'Use it along with the `checked` attribute on input.',
  ],
  [
    <CopyableCode text="form-card--error" key={shortid.generate()} />,
    'State Modifier',
    <code key={shortid.generate()}>label</code>,
    '-',
  ],
  [
    <CopyableCode text="form-card--disabled" key={shortid.generate()} />,
    'State Modifier',
    <code key={shortid.generate()}>label</code>,
    'Use it along with the `disabled` attribute on input',
  ],
  [
    <CopyableCode text="form-card--large" key={shortid.generate()} />,
    'Size Modifier',
    <code key={shortid.generate()}>label</code>,
    'Remember to add a image as addon when size is large.',
  ],
  [
    <CopyableCode text="form-card__addon" key={shortid.generate()} />,
    'Addon Element',
    <code key={shortid.generate()}>span, div</code>,
    'It could be an image if size is large, otherwise a text or an icon.',
  ],
  [
    <CopyableCode text="form-card__addon--with-icon" key={shortid.generate()} />,
    'Addon Element Modifier',
    <code key={shortid.generate()}>span, div</code>,
    'Remember to add it if the addon is an icon',
  ],
  [
    <CopyableCode text="form-card__content-wrapper" key={shortid.generate()} />,
    'Content Wrapper Element',
    <code key={shortid.generate()}>span, div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-card__title" key={shortid.generate()} />,
    'Title Element',
    <code key={shortid.generate()}>span, div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-card__text" key={shortid.generate()} />,
    'Text Element',
    <code key={shortid.generate()}>span, div</code>,
    '-',
  ],
  [
    <CopyableCode text="form-card__checkbox" key={shortid.generate()} />,
    'Input Element',
    <code key={shortid.generate()}>input</code>,
    '-',
  ],
  [
    <CopyableCode text="form-card-group" key={shortid.generate()} />,
    'Base Class',
    <code key={shortid.generate()}>div</code>,
    'It displays checkbox card horizontally by default.',
  ],
  [
    <CopyableCode text="form-card-group--column" key={shortid.generate()} />,
    'Layout Modifier',
    <code key={shortid.generate()}>div</code>,
    'Use it to display checkbox card vertically',
  ],
  [
    <CopyableCode text="form-card-group__error-message" key={shortid.generate()} />,
    'Error Element',
    <code key={shortid.generate()}>div, span</code>,
    '-',
  ]
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Checkbox Card 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-control-checkboxcard-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["States", "Large size", "With addon", "CheckboxCard Group", "Other variants", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="State" description={stateDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateStateBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="With addon" description={addonDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateAddonBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Large size" description={largeDescription}>
      <Table
        head={['Sample', 'State', 'Note']}
        body={generateLargeBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Other variants" description={otherDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateOtherBody()}
        gridTemplateColumns="300px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="CheckboxCard Group" description={groupDescription} />
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to', 'Note']}
        body={tableClassBody}
        gridTemplateColumns="300px 1fr 100px 2fr"
      />
    </OverviewTemplate>
  </>
)

export default Overview;
