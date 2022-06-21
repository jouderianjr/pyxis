import React, { FC } from "react";
import {ArgsTable, Canvas, Story} from "@storybook/addon-docs";
import OverviewTemplate from "stories/utils/OverviewTemplate";
import OverviewIndex from "stories/utils/OverviewIndex";
import Table, {TableRow} from "stories/utils/Table";
import CopyableCode from "stories/utils/CopyableCode";
import shortid from "shortid";
import {linkTo} from "@storybook/addon-links";
import Modal from "components/Modal";

const overviewDescription = (
  <>
    <p>
      A modal activates a state (or mode) that focuses the user’s attention exclusively on one task or piece of relevant information. When a modal dialog is active, the content of the underneath page is obscured and inaccessible until the user completes the task or dismisses the modal.
    </p>
    <p>
      <strong>Please note:</strong> whenever the modal is open it should add the <code>scroll-locked</code> class to the <code>html</code> tag.
      This will improve the usability of the modal, preventing scrolling of the entire page.
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
    <CopyableCode text="small" key={shortid.generate()} />,
    <code>500px</code>,
    <span onClick={linkTo('components-display-modal-all-stories--size-small')} className="link">
      See the related story
    </span>
  ],
  [
    <CopyableCode text="medium" key={shortid.generate()} />,
    <code>800px</code>,
    '-'
  ],
  [
    <CopyableCode text="large" key={shortid.generate()} />,
    <code>1000px</code>,
    <span onClick={linkTo('components-display-modal-all-stories--size-large')} className="link">
      See the related story
    </span>
  ],
];

const behaviourOnMobileDescription = (
  <p>
    Modal are designed to behave like a bottomsheet on small screens. &nbsp;
    <span className="link" onClick={linkTo('components-display-modal-all-stories--default-on-mobile')}>
      See the related story
    </span>.
  </p>
)

const centeredDescription = (
  <p>
    By default modal is always positioned in the top of the screen, but it is also possible to center it vertically.
    This use is recommended only if the modal is not high. <span className="link" onClick={linkTo('components-display-modal-all-stories--centered-modal')}>
      See the related story
    </span>.
  </p>
);

const modalChildrenDescription = (
  <>
    <p>
      The Modal component accepts three children, both exported from the main Modal component: <span className={"link"} onClick={linkTo('components-display-modal-modal-header--page')}>Modal.Header </span>,
      Modal.Content and <a className={"link"} onClick={linkTo('components-display-modal-modal-footer--page')}>Modal.Footer</a>. While Modal.Header and Modal.Footer are full-blown components,
      Modal.Content acts as just a wrapper for the real content of the modal, and doesn't have specifics props.
    </p>
    <p>
      <strong className="text-l-bold">Please Note:</strong> all three children are mandatory for a correct visualization
      of the component itself, even if the header or the footer are empty.
    </p>
  </>
);

const nonClosableModalDescription = (
  <p>
    In some special cases the modals may not have the closing button and the closing with a click outside the modal.
    In that case the developer will have to pass a close function to one of the internal buttons or in a custom way in the modal.
  </p>
)

const accessibilityDescription = (
  <p>
    The modal component already has the correct <code>role</code> and <code>ARIA-attributes</code>. When using
    it you should just remember to pass a correct description of the modal, through the <code>accessibilityDescription</code> prop,
    and the label for the closing icon through the <code>closeLabel</code> prop.
  </p>
);

const apiDescription = (
  <p>
    Use props below to change modal configuration and behaviour.
  </p>
);

const classDescription = (
  <p>
    The list of Modal and its sub-components CSS classes is
    available <a href="https://prima.design/3794e337c/p/34b4a0-modal/t/64c230" className="link" target="_blank">on zeroheight documentation</a>.
  </p>
);


const Overview: FC = () => (
  <>
    <OverviewTemplate title="Modal" description={overviewDescription} category="Component" isMain>
      <Canvas>
        <Story id="components-display-modal-all-stories--default" />
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Table of contents">
      <OverviewIndex titles={["Size", "Behaviour on mobile", "Centered", "Non-closable Modal", "Modal children", "Accessibility","Component API", "Overview of CSS classes"]} />
    </OverviewTemplate>
    <OverviewTemplate title="Size" description={sizeDescription}>
      <Table
        head={['Size', 'Max width', 'Note']}
        body={generateSizeBody()}
      />
    </OverviewTemplate>
    <OverviewTemplate title="Behaviour on mobile" description={behaviourOnMobileDescription} />
    <OverviewTemplate title="Centered" description={centeredDescription}/>
    <OverviewTemplate title="Non-closable Modal" description={nonClosableModalDescription}>
      <Canvas>
        <Story id="components-display-modal-all-stories--non-closable-modal" height={"500px"}/>
      </Canvas>
    </OverviewTemplate>
    <OverviewTemplate title="Modal children" description={modalChildrenDescription} />
    <OverviewTemplate title="Accessibility" description={accessibilityDescription} />
    <OverviewTemplate title="Component API" description={apiDescription}>
      <ArgsTable of={Modal} />
    </OverviewTemplate>
    <OverviewTemplate title="Overview of CSS classes" description={classDescription} />
  </>
);

export default Overview;
