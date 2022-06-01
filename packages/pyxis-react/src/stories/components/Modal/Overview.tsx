import React, { FC } from "react";
import {Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import Modal from "./Modal";
import {linkTo} from "@storybook/addon-links";

const overviewDescription = (
  <>
    <p>
      <em>
        Work in progress: React component will be developed soon. In this documentation there are only
        examples developed in HTML + SCSS.
      </em>
    </p>
    <p>
      A modal activates a state (or mode) that focuses the user’s attention exclusively on one task or piece of relevant information. When a modal dialog is active, the content of the underneath page is obscured and inaccessible until the user completes the task or dismisses the modal.
    </p>
    <p>
      <strong>Please note:</strong> whenever the modal is open it should add the <code>scroll-locked</code> class to the <code>html</code> tag.
      This will improve the usability of the modal, preventing scrolling of the entire page.
    </p>
    <p>
      All the properties described below concern the visual implementation of the component.
    </p>
  </>
);

const sizeDescription = (
  <>
    <p>
      Size available are Small, Medium (default) and Large. Each sizes refers to the max-width that the modal can take.
    </p>
    <p>
      <strong>Please note:</strong> Under the <code>xsmall</code> breakpoint the modals will appear as a bottom sheet,
      and the size will always be the width of the screen.
    </p>
  </>
);

const generateSizeBody = (): TableRow[] => [
  [
    <Modal size="small" />,
    <CopyableCode text="small" key={shortid.generate()} />,
    <code>500px</code>
  ],
  [
    <Modal size="medium" />,
    <CopyableCode text="medium" key={shortid.generate()} />,
    <code>800px</code>
  ],
  [
    <Modal size="large" />,
    <CopyableCode text="large" key={shortid.generate()} />,
    <code>1000px</code>,
  ],
];

const behaviourOnMobileDescription = (
  <p>
    Modal are designed to behave like a bottomsheet on small screens. &nbsp;
    <span className="link" onClick={linkTo('components-modal-🚧-all-stories--default-on-mobile')}>
      See the related story
    </span>.
  </p>
)

const centeredDescription = (
  <p>
    By default modal is always "docked" to the top of the screen, but it is also possible to center it vertically.
    This use is recommended only if the modal is not tall.
  </p>
);

const generateCenteredBody = (): TableRow[] => [
  [
    <Modal size="small" shortContent />,
    "Default"
  ],
  [
    <Modal size="small" isCentered  shortContent />,
    "Centered",
  ],
];

const headerAddonsDescription = (
  <>
    <p>
      Modal Header can have several addons, such as badge or icon. They are used to make the user understand the purpose of the modal better.
    </p>
    <p>
      It is also possible to set a completely custom header, but this will totally replace the content of the header, including the title.
      Use it carefully and in accordance with the design.
    </p>
    <p>
      <strong className="text-l-bold">Please Note:</strong> don't use badge and icon together.
    </p>
  </>
);

const generateHeaderAddonsBody = (): TableRow[] => [
  [
    <Modal size="small" withBadge shortContent/>,
    "Badge"
  ],
  [
    <Modal size="small" withIcon shortContent/>,
    "Icon",
  ],
  [
    <Modal size="small" stickyHeader />,
    "Sticky Header",
  ],
  [
    <Modal size="small" customHeader={<div>💈 Custom header</div>} shortContent/>,
    "Custom Header",
  ],
];

const footerAddonsDescription = (
  <>
    <p>
      Modal Footer can have several addons, such as text or theme.
    </p>
    <p>
      It is also possible to set a completely custom footer, but like custom header this will totally replace the content of the footer.
      Use it carefully and in accordance with the design.
    </p>
  </>
);

const generateFooterAddonsBody = (): TableRow[] => [
  [
    <Modal size="medium" footerText="Footer text" />,
    "Footer Text"
  ],
  [
    <Modal size="medium" altFooter />,
    "Alternative Theme",
  ],
  [
    <Modal size="small" stickyFooter />,
    "Sticky Footer",
  ],
  [
    <Modal size="small" fullWidthButton />,
    "Full width button (visible only in bottom sheet mode)",
  ],
  [
    <Modal size="small" customFooter={<div>💈 Custom footer</div>} />,
    "Custom Footer",
  ],
];

const nonClosableModalDescription = (
  <p>
    In some special cases the modals may not have the closing button and the closing with a click outside the modal.
    In that case the developer will have to pass a close function to one of the internal buttons or in a custom way in the modal.
  </p>
)

const accessibilityDescription = (
  <>
    <p>
      There are many rules that make a modal accessible. Some of these are:
    </p>
    <ul>
      <li>It should have a <code>role="dialog"</code></li>
      <li>It should have an <code>aria-modal</code></li>
      <li>It should have an <code>aria-hidden</code> set to <code>true</code> when closed and to <code>false</code> when open.</li>
      <li>It should have an <code>aria-labeledby</code> with an <code>id</code> pointing to the title of the modal</li>
      <li>It should have an <code>aria-describedby</code> with an <code>id</code> pointing to the accessible description visible only to screen readers.</li>
    </ul>
    <p>
      We recommend that you see our sample HTML or the&nbsp;
      <a href="https://www.w3.org/TR/2017/NOTE-wai-aria-practices-1.1-20171214/examples/dialog-modal/dialog.html" target="_blank" className="link">W3C example</a>.
      <br />
    </p>
  </>
);

const classDescription = (
  <p>
    Modal is based upon this list of CSS classes.
  </p>
);

const tableClassBody: TableRow[] = [
  [
    <CopyableCode text="modal-backdrop" key={shortid.generate()} />,
    'Backdrop element',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal-backdrop--show" key={shortid.generate()} />,
    'Backdrop modifier',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal-close" key={shortid.generate()} />,
    'Backdrop close element',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal" key={shortid.generate()} />,
    'Modal element',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal--$size" key={shortid.generate()} />,
    'Modal modifier',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal--center" key={shortid.generate()} />,
    'Modal modifier',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__header" key={shortid.generate()} />,
    'Header element',
    <code>header</code>,
  ],
  [
    <CopyableCode text="modal__header--sticky" key={shortid.generate()} />,
    'Header modifier',
    <code>header</code>,
  ],
  [
    <CopyableCode text="modal__header__wrapper" key={shortid.generate()} />,
    'Header Wrapper element',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__header__wrapper--custom" key={shortid.generate()} />,
    'Header Wrapper modifier',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__header__badge" key={shortid.generate()} />,
    'Badge wrapper',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__header__title" key={shortid.generate()} />,
    'Title element',
    <code>header</code>,
  ],
  [
    <CopyableCode text="modal__content" key={shortid.generate()} />,
    'Content element',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__footer" key={shortid.generate()} />,
    'Footer element',
    <code>footer</code>,
  ],
  [
    <CopyableCode text="modal__footer--alt" key={shortid.generate()} />,
    'Footer modifier',
    <code>footer</code>,
  ],
  [
    <CopyableCode text="modal__footer--sticky" key={shortid.generate()} />,
    'Footer modifier',
    <code>footer</code>,
  ],
  [
    <CopyableCode text="modal__footer--custom" key={shortid.generate()} />,
    'Footer modifier',
    <code>footer</code>,
  ],
  [
    <CopyableCode text="modal__footer__text" key={shortid.generate()} />,
    'Footer text element',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__footer__buttons" key={shortid.generate()} />,
    'Button wrapper',
    <code>div</code>,
  ],
  [
    <CopyableCode text="modal__footer__buttons--full-width" key={shortid.generate()} />,
    'Button wrapper modifier',
    <code>div</code>,
  ],
];

const Overview: FC = () => (
  <>
    <OverviewTemplate title="Modal 🚧" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-modal-🚧-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Size", "Behaviour on mobile", "Centered", "Header Addons", "Footer Addons", "Non-closable Modal", "Accessibility", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizeDescription}>
      <Table
        head={['Sample', 'Size', 'Max width']}
        body={generateSizeBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Behaviour on mobile" description={behaviourOnMobileDescription} />
    <OverviewTemplate title="Centered" description={centeredDescription}>
      <Table
        head={['Sample', 'State']}
        body={generateCenteredBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Header Addons" description={headerAddonsDescription}>
      <Table
        head={['Sample', 'Addon']}
        body={generateHeaderAddonsBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Footer Addons" description={footerAddonsDescription}>
      <Table
        head={['Sample', 'Addon']}
        body={generateFooterAddonsBody()}
        gridTemplateColumns="200px"
      />
    </OverviewTemplate>
    <OverviewTemplate title="Non-closable Modal" description={nonClosableModalDescription}>
      <Modal size="small" shortContent withoutCloseButton />
    </OverviewTemplate>
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Overview of CSS classes" description={classDescription}>
      <Table
        head={['Class', 'Type', 'Apply to']}
        body={tableClassBody}
        gridTemplateColumns="320px"
      />
    </OverviewTemplate>
  </>
);

export default Overview;
